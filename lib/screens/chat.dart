import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageText = '';
  String userNick = '';
  List<MessageBubble> messageWidgets = [];

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  void getMessages() async {
    messageWidgets.clear();
    var messages = await widget.chatRepository.messages;
    for (var message in messages.reversed) {
      messageWidgets.add(
        MessageBubble(
          author: message.author.name,
          text: message.message,
          //time: message.
          isMe: message.author.name == 'SuperSasha',
        ),
      );
    }
  }

  void sendMessage() async {
    try {
      await widget.chatRepository.sendMessage('SuperSasha', messageText);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: InputDecoration(
              hintText: 'Введите ник',
              hintStyle: TextStyle(
                color: Colors.deepPurple[200],
              ),
            ),
            onChanged: (value) {
              userNick = value;
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  getMessages();
                  messageWidgets.clear();
                }),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: messageWidgets,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Сообщение',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          //controller: messageTextController,
                          onChanged: (value) {
                            setState(() {
                              messageText = value;
                            });
                          },
                          //decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print(messageText);
                        sendMessage();
                        getMessages();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
    throw UnimplementedError();
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.author,
    required this.text,
    //required this.time,
    required this.isMe,
  });

  final String author;
  final String text;
  //final Timestamp time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
      child: Row(
        children: [
          Chip(
            label: Text('$author', style: TextStyle(fontSize: 14)),
            backgroundColor: Colors.white,
            side: BorderSide(width: 1.0, color: Color(0xFFD0EDF2)),
            avatar: CircleAvatar(
              backgroundColor: Color(
                      (author.hashCode.toInt() / 1000000000 * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              child: Text(
                author.toUpperCase().substring(0, 1),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: isMe
                  ? Color(0xFF3E9AAA).withOpacity(0.25)
                  : Color(0xFFC3B47A).withOpacity(0.25),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('$text', style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
