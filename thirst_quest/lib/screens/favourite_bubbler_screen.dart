import 'package:flutter/material.dart';

class FavoriteBubblerScreen extends StatefulWidget {
  const FavoriteBubblerScreen({super.key});

  @override
  _FavoriteBubblerScreenState createState() => _FavoriteBubblerScreenState();
}

class _FavoriteBubblerScreenState extends State<FavoriteBubblerScreen> {
  bool isLoading = true; // Stav pro načítání
  List<String> favoriteDrinks = []; // Mock dat, nebo data z API
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFavoriteDrinks(); // Načti oblíbená pítka při inicializaci
  }

  Future<void> fetchFavoriteDrinks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Simulace API volání
      await Future.delayed(const Duration(seconds: 2)); // Umělá prodleva
      setState(() {
        favoriteDrinks = ["Káva", "Čaj", "Pomerančový džus", "Latte"];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Chyba při načítání oblíbených pít: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Oblíbená pítka")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Zobraz indikátor načítání
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Zobraz chybovou zprávu
              : ListView.builder(
                  itemCount: favoriteDrinks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.local_drink),
                      title: Text(favoriteDrinks[index]),
                    );
                  },
                ),
    );
  }
}
