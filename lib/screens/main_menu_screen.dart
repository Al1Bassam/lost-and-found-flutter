import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'auth_screen.dart';
import 'items_list_screen.dart';
import 'post_item_screen.dart';
import 'my_posts_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Lost & Found'),
        backgroundColor:Color.fromARGB(255, 205, 218, 243),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Storage.clearUser();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(
              context,
              'Lost Something?',
              Icons.search,
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ItemsListScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'Found Something?',
              Icons.add_circle,
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PostItemScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              'My Posts',
              Icons.list,
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MyPostsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 32),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
} 