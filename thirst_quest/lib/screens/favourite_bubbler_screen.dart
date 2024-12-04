import 'package:flutter/material.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/services/water_bubbler_service.dart';

class FavoriteBubblerScreen extends StatefulWidget {
  const FavoriteBubblerScreen({super.key});

  @override
  FavoriteBubblerScreenState createState() => FavoriteBubblerScreenState();
}

class FavoriteBubblerScreenState extends State<FavoriteBubblerScreen> {
  final WaterBubblerService bubblerService = DI.get<WaterBubblerService>();
  bool isLoading = true; // Stav pro načítání
  List<WaterBubbler> bubblers = []; // List of bubblers from API
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchBubblers();
  }

  Future<void> fetchBubblers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch user-created bubblers using the service
      final userBubblers = await bubblerService.getUsersFavoriteWaterBubblers();
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

  void removeFavoriteWaterBubbler(WaterBubbler waterBubbler) async {
    try {
      await bubblerService.toggleFavorite(waterBubbler); // Remove buubler from favorite
      setState(() {
        bubblers.removeWhere((bubbler) => bubbler.id == waterBubbler.id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during removing bubbler from favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorite Bubblers")),
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
                                        title: const Text('Confirm Removing Favorite WatterBubbler'),
                                        content:
                                            const Text('Are you sure you want to remove this bubbler from favorite?'),
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
                                              // Perform removing favorite bubbler
                                              bubbler.favorite = false;
                                              removeFavoriteWaterBubbler(bubbler);
                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Remove'),
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
