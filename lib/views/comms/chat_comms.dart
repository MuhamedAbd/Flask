// chatcomms.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/comms/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/chatcomms_services.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider()..initialize(),
      child: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: const Text('MessageMe'),
              centerTitle: true,
            ),
            body: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Message Stream
                      Expanded(
                        child: MessagesStream(
                          chatCommsService: provider.controller.chatCommsService,
                          currentUserEmail: provider.loggedInUserEmail ?? '',
                        ),
                      ),
                      // Message Input
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: provider.messageController,
                                decoration: InputDecoration(
                                  hintText: 'Write your message here...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  provider.updateMessageText(value);
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: provider.sendMessage,
                              icon: Icon(Icons.send, color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final ChatCommsService chatCommsService;
  final String currentUserEmail;

  const MessagesStream({
    required this.chatCommsService,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatCommsService.getMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.purple,
            ),
          );
        }

        final messages = snapshot.data!.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: messageSender == currentUserEmail,
          );
          messageBubbles.add(messageBubble);
        }

        return ListView(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          children: messageBubbles,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 12 : 0),
              topRight: Radius.circular(isMe ? 0 : 12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            elevation: 2,
            color: isMe ? Colors.purple : Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : Colors.black,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
