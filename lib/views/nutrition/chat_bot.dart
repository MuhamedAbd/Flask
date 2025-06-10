import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ChatProvider>(context, listen: false).initializeSession());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('AI Nutrition Assistant'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => provider.initializeSession(),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      final isUser = message['isUser'] == 'true';
                      
                      return MessageBubble(
                        text: message['text']!,
                        isMe: isUser,
                        sender: isUser ? 'You' : 'AI Assistant',
                      );
                    },
                  ),
                ),
                if (provider.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    ),
                  ),
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
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => provider.sendMessage(),
                        ),
                      ),
                      IconButton(
                        onPressed: () => provider.sendMessage(),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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