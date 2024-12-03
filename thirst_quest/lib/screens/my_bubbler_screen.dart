import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';

class MyBubblerScreen extends StatefulWidget {
  const MyBubblerScreen({super.key});

  @override
  MyBubblerScreenState createState() => MyBubblerScreenState();
}

class MyBubblerScreenState extends State<MyBubblerScreen> {
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  bool isLoading = true; // Loading state
  List<WaterBubbler> bubblers = []; // List of bubblers from API
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchBubblers(); // Fetch bubblers on initialization
  }

  Future<void> fetchBubblers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch user-created bubblers using the service
      final userBubblers = await bubblerService.getWaterBubblerCreatedByUser();
      setState(() {
        bubblers = userBubblers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error during loading bubblers: $e";
        isLoading = false;
      });
    }
  }

  void deleteBubbler(String bubblerId) async {
    try {
      await bubblerService.deleteWaterBubbler(bubblerId); // Delete the bubbler using the service
      setState(() {
        bubblers.removeWhere((bubbler) => bubbler.id == bubblerId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during deletion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bubblers")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!), // Display error message
                )
              : bubblers.isEmpty
                  ? const Center(
                      child: Text(
                        "No bubblers found",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: bubblers.length,
                      itemBuilder: (context, index) {
                        final bubbler = bubblers[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 7.5,
                            horizontal: 10,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bubbler.name ?? 'Unnamed Bubbler',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text('Are you sure you want to delete this bubbler?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Perform the delete action
                                              deleteBubbler(bubbler.id!);
                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
