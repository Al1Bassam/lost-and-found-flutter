import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/api_service.dart';
import '../utils/storage.dart';
import 'chat_screen.dart';

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  final _apiService = ApiService();
  List<Item> _items = [];
  bool _isLoading = true;

  String? _selectedStatus;    // null = all
  String? _selectedCategory;  // null = all

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await _apiService.getItems(
        status: _selectedStatus,
        category: _selectedCategory,
      );
      setState(() => _items = items);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found Items'),
        backgroundColor:Color.fromARGB(255, 205, 218, 243),
        actions: [
          // 🔽 Status filter dropdown
          PopupMenuButton<String?>(
            initialValue: _selectedStatus,
            onSelected: (status) {
              setState(() => _selectedStatus = status);
              _loadItems();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Statuses')),
              const PopupMenuItem(value: 'lost', child: Text('Lost')),
              const PopupMenuItem(value: 'found', child: Text('Found')),
            ],
          ),
          // 🔽 Category filter dropdown
          PopupMenuButton<String?>(
            initialValue: _selectedCategory,
            onSelected: (category) {
              setState(() => _selectedCategory = category);
              _loadItems();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Categories')),
              const PopupMenuItem(value: 'electronics', child: Text('Electronics')),
              const PopupMenuItem(value: 'books', child: Text('Books')),
              const PopupMenuItem(value: 'clothing', child: Text('Clothing')),
              const PopupMenuItem(value: 'other', child: Text('Other')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No items found'))
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return _buildItemCard(item);
                  },
                ),
    );
  }

  Widget _buildItemCard(Item item) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${item.category}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Status: ${item.status}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Posted by: ${item.posterName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final currentUser = await Storage.getUser();
                  if (currentUser == null) return;

                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          itemId: item.id,
                          otherUserId: item.userId,
                          otherUserName: item.posterName,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Message Poster'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
