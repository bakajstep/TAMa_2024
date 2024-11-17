import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/states/global_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GlobalState>(context, listen: false);
    if (!state.user.isLoggedIn) {
      // Pokud není uživatel přihlášen, přesměruj na přihlašovací obrazovku
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen())));
      return const SizedBox(); // Vrať prázdnou obrazovku, dokud nedojde k přesměrování
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() {
                state.user.logout(); // Odhlásí uživatele
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Personal Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Name:"),
                const SizedBox(width: 8),
                Text(state.user.identity!.username), // Zobraz aktuální jméno
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Akce pro úpravu jména
                    _editName(state);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Email:"),
                const SizedBox(width: 8),
                Text(state.user.identity!.email), // Zobraz aktuální email
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Akce pro úpravu emailu
                    _editEmail(state);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pro úpravu jména
  void _editName(GlobalState state) {
    TextEditingController nameController = TextEditingController(text: state.user.identity!.username);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  state.updateUsername(nameController.text);
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Dialog pro úpravu emailu
  void _editEmail(GlobalState state) {
    TextEditingController emailController = TextEditingController(text: state.user.identity!.email);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Email"),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  state.updateEmail(emailController.text);
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
