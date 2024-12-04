import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/favourite_bubbler_screen.dart';
import 'package:thirst_quest/screens/login_screen.dart';
import 'package:thirst_quest/screens/my_bubbler_screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GlobalState>(context, listen: false);

    if (!state.user.isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen())));
      return const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Vrátí tě zpět na předchozí obrazovku
          },
        ),
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = DI.get<AuthService>();
              await authService.logout(state); // Odhlášení uživatele

              if (!mounted) return;

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: state.user.identity!.pictureUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : ClipOval(
                                child: Image.network(
                                state.user.identity!.pictureUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          // Akce pro úpravu profilového obrázku
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Personal information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyBubblerScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        "My Bubblers",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoriteBubblerScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        "My Favorite Bubblers",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildEditableField(
                  context: context,
                  label: "Name",
                  value: state.user.identity!.username,
                  onEdit: () => _editName(state),
                  googleAuth: state.user.identity!.googleAuth,
                ),
                const SizedBox(height: 16),
                _buildEditableField(
                  context: context,
                  label: "Email",
                  value: state.user.identity!.email,
                  onEdit: () => _editEmail(state),
                  googleAuth: state.user.identity!.googleAuth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onEdit,
    required bool googleAuth,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
          if (!googleAuth)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  // Dialog pro úpravu jména
  void _editName(GlobalState state) {
    TextEditingController nameController =
        TextEditingController(text: state.user.identity!.username);
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
    TextEditingController emailController =
        TextEditingController(text: state.user.identity!.email);
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
