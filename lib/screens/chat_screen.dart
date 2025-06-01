import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../models/message.dart' as my;
import '../services/api_service.dart';
import '../utils/storage.dart';

class ChatScreen extends StatefulWidget {
  final int itemId;
  final int otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.itemId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _apiService = ApiService();
  final _messageController = TextEditingController();
  List<types.Message> _messages = [];
  bool _isLoading = true;
  types.User? _currentUser;
  types.User? _otherUser;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = await Storage.getUser();
      if (currentUser == null) throw Exception('User not logged in');

      _currentUser = types.User(id: currentUser.id.toString());
      _otherUser = types.User(id: widget.otherUserId.toString());

      final messages = await _apiService.getMessages(
        widget.itemId,
        currentUser.id,
        widget.otherUserId,
      );

      setState(() {
        _messages = messages.map((m) {
          final isMe = m.senderId == currentUser.id;
          return types.TextMessage(
            author: isMe ? _currentUser! : _otherUser!,
            id: m.id.toString(),
            text: m.message,
            createdAt: m.createdAt.millisecondsSinceEpoch,
          );
        }).toList();
      });
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

  Future<void> _handleSendPressed(types.PartialText message) async {
    if (_currentUser == null) return;

    final textMessage = types.TextMessage(
      author: _currentUser!,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    try {
      await _apiService.sendMessage(
       my.Message(
          id: 0, 
          itemId: widget.itemId,
          senderId: int.parse(_currentUser!.id),
          receiverId: widget.otherUserId,
          message: message.text,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        backgroundColor:Color.fromARGB(255, 205, 218, 243),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _currentUser!,
            ),
    );
  }
} 