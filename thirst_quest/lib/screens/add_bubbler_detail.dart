import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';

class AddBubblerDetailsScreen extends StatefulWidget {
  final LatLng location;

  const AddBubblerDetailsScreen({super.key, required this.location});

  @override
  AddBubblerDetailsScreenState createState() => AddBubblerDetailsScreenState();
}

class AddBubblerDetailsScreenState extends State<AddBubblerDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  bool _isFavorite = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;

  Future<void> _pickImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages = pickedImages;
      });
    }
  }

  Future<Uint8List> _loadImageBytes(XFile xfile) async {
    return await xfile.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bubbler detail"),
      ),
      body: Center(
        child:
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Bubbler's name"),
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
              SizedBox(height: 25),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Mark as Favorite"),
                value: _isFavorite,
                onChanged: (bool? value) {
                  setState(() {
                    _isFavorite = value ?? false;
                  });
                },
              ),
              SizedBox(height: 5),
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
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter the bubbler's name.")),
                      );
                      return;
                    }

                    final WaterBubbler bubbler = WaterBubbler.fromLatLng(
                      latLng: widget.location,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      favorite: _isFavorite,
                    );

                    // Tady můžete uložit obrázky společně s bubblerem dle potřeby.

                    bubblerService.createWaterBubbler(bubbler);
                    Navigator.pop(context, bubbler);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text("Create"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
