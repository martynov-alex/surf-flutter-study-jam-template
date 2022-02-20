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
  List<Text> messageWidgets = [];

  void getMessages() async {
    var messages = await widget.chatRepository.messages;
    for (var message in messages) {
      final messageText = message.message;
      print(messageText);

      messageWidgets.add(Text(
        messageText,
        style: TextStyle(color: Colors.black),
      ));
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
                            messageText = value;
                          },
                          //decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //messageTextController.clear();
                        // _firestore.collection('messages').add({
                        //   'text': messageText,
                        //   'sender': loggedInUser.email,
                        //   'time': FieldValue.serverTimestamp(),
                        // });
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
