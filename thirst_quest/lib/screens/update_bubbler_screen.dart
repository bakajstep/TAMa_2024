import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/photo.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/assets/thirst_quest_icons.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/add_bubbler.dart';
import 'package:thirst_quest/services/photo_service.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;

class UpdateBubblerDetailsScreen extends StatefulWidget {
  final WaterBubbler bubbler;

  const UpdateBubblerDetailsScreen({super.key, required this.bubbler});

  @override
  UpdateBubblerDetailsScreenState createState() => UpdateBubblerDetailsScreenState();
}

class UpdateBubblerDetailsScreenState extends State<UpdateBubblerDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final MapController _mapController = MapController();
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  final PhotoService photoService = DI.get<PhotoService>();
  bool _valid = true;
  late LatLng _location;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.bubbler.latitude, widget.bubbler.longitude);
    final name = widget.bubbler.name;
    _nameController = TextEditingController(text: name == null ? null : utf8.decode((name).codeUnits));
    final description = widget.bubbler.description;
    _descriptionController =
        TextEditingController(text: description == null ? null : utf8.decode((description).codeUnits));
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages = pickedImages;
      });
    }
  }

  Future<Uint8List> _loadImageBytes(XFile xfile) async {
    return await xfile.readAsBytes();
  }

  void _changeLocation() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddBubblerMapScreen(location: _location, popOnSuccess: true)))
        .then((value) {
      if (value != null) {
        setState(() {
          _location = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Bubbler"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                maxLength: 60,
                decoration: InputDecoration(
                  labelText: "Bubbler's name",
                  errorText: _valid ? null : "Please enter the bubbler's name.",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                minLines: 1,
                maxLines: null,
                maxLength: 255,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(labelText: "Description (optional)"),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: _changeLocation,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.indigo.shade800,
                  textStyle: TextStyle(fontSize: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Change Location"),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                      initialCenter: _location,
                      initialZoom: 15,
                      interactionOptions: InteractionOptions(flags: InteractiveFlag.none)),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        width: constants.markerSize + (constants.markerPadding * 2),
                        height: constants.markerSize + (constants.markerPadding * 2),
                        point: _location,
                        alignment: Alignment.topCenter,
                        rotate: true,
                        child: Transform.translate(
                          offset: Offset(0.0, constants.markerPadding),
                          child: Icon(
                            ThirstQuestIcons.bubblerReflection,
                            color: Colors.indigoAccent,
                            size: constants.markerSize,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.indigo.shade800,
                  textStyle: TextStyle(fontSize: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Pick Images"),
              ),
              SizedBox(height: 10),
              if (_selectedImages != null && _selectedImages!.isNotEmpty)
                FutureBuilder(
                  future: Future.wait(
                    _selectedImages!.map((xfile) => _loadImageBytes(xfile)),
                  ),
                  builder: (context, AsyncSnapshot<List<Uint8List>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      final imagesData = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: imagesData.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // počet obrázků v jednom řádku
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Image.memory(
                            imagesData[index],
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty) {
                      setState(() {
                        _valid = false;
                      });
                      return;
                    }

                    widget.bubbler.latitude = _location.latitude;
                    widget.bubbler.longitude = _location.longitude;
                    widget.bubbler.name = _nameController.text;
                    widget.bubbler.description = _descriptionController.text;

                    // final WaterBubbler tmp = WaterBubbler.fromLatLng(
                    //   latLng: _location,
                    //   name: _nameController.text,
                    //   description: _descriptionController.text,
                    //   favorite: widget.bubbler.favorite,
                    // );

                    await bubblerService.updateWaterBubbler(widget.bubbler);
                    if (_selectedImages != null && _selectedImages!.isNotEmpty) {
                      final uploadFutures = _selectedImages!.map((imageFile) {
                        return photoService.uploadBubblerPhoto(imageFile, widget.bubbler.id, widget.bubbler.osmId);
                      });
                      await Future.wait(uploadFutures);
                    }

                    // fix encoding for local copy (dart interprets json strings as latin1)
                    widget.bubbler.name = latin1.decode(utf8.encode(_nameController.text));
                    widget.bubbler.description = latin1.decode(utf8.encode(_descriptionController.text));
                    if (_selectedImages != null && _selectedImages!.isNotEmpty) {
                      widget.bubbler.photos.addAll(
                          _selectedImages!.map((image) => Photo(id: null, name: image.name, url: image.path)).toList());
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
