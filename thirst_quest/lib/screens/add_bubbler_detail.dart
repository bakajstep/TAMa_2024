import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';

class AddBubblerDetailsScreen extends StatefulWidget {
  final LatLng location;

  const AddBubblerDetailsScreen({super.key, required this.location});

  @override
  _AddBubblerDetailsScreenState createState() => _AddBubblerDetailsScreenState();
}

class _AddBubblerDetailsScreenState extends State<AddBubblerDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bubbler detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Bubbler's name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text("Mark as Favorite"),
              value: _isFavorite,
              onChanged: (bool? value) {
                setState(() {
                  _isFavorite = value ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
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
                bubblerService.createWaterBubbler(bubbler);
                Navigator.pop(context, bubbler);
              },
              child: Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
