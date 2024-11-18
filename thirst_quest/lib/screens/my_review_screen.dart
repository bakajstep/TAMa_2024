import 'package:flutter/material.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  _MyReviewsScreenState createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  bool isLoading = true; // Stav pro načítání
  List<String> reviews = []; // Mock dat, nebo data z API
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchReviews(); // Načti recenze při inicializaci
  }

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Simulace API volání
      await Future.delayed(const Duration(seconds: 2)); // Umělá prodleva
      setState(() {
        reviews = [
          "Výborné místo!",
          "Skvělá obsluha.",
          "Jídlo by mohlo být lepší."
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Chyba při načítání recenzí: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Moje recenze")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Zobraz indikátor načítání
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Zobraz chybovou zprávu
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(reviews[index]),
                    );
                  },
                ),
    );
  }
}
