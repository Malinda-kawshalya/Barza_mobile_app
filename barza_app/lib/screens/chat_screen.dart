import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  ChatScreen({required this.chatId, required this.otherUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  bool isChatInitialized = false;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    checkChatExists();
  }

  void checkChatExists() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();

    setState(() {
      isChatInitialized = chatDoc.exists;
    });
  }

  void sendMessage({String? mediaUrl}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null &&
        messageController.text.trim().isEmpty &&
        mediaUrl == null) return;

    String currentUserId = user!.uid;
    String messageText = messageController.text.trim();

    if (!isChatInitialized) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.otherUserId)
          .get();

      String? otherUserName = userDoc.exists
          ? (userDoc.data() as Map<String, dynamic>)['fullName']
          : null;

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .set({
        'participants': [currentUserId, widget.otherUserId],
        'lastMessage': mediaUrl != null ? 'Media' : messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'fullName': otherUserName,
      });

      setState(() {
        isChatInitialized = true;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': mediaUrl != null ? 'Media' : messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': mediaUrl == null ? messageText : '',
      'timestamp': FieldValue.serverTimestamp(),
      'mediaUrl': mediaUrl,
    });

    messageController.clear();
  }

  Future<void> _sendMedia() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_media')
          .child(widget.chatId)
          .child(
              '${DateTime.now().millisecondsSinceEpoch}${p.extension(image.path)}');

      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      sendMessage(mediaUrl: url);
    } catch (e) {
      print("Error uploading media: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload media.')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] ==
                        FirebaseAuth.instance.currentUser?.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: (message.data() as Map<String, dynamic>)
                                    .containsKey('mediaUrl') &&
                                message['mediaUrl'] != null
                            ? Image.network(message['mediaUrl'], width: 200)
                            : Text(message['text']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: _isUploading ? null : _sendMedia,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isUploading ? null : sendMessage,
                ),
              ],
            ),
          ),
          if (_isUploading) LinearProgressIndicator(),
        ],
      ),
    );
  }
}
