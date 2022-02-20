import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/chat.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:surf_practice_chat_flutter/services/location.dart';

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
  bool showSpinner = false;
  List<MessageBubble> messageWidgets = [];
  final messageTextController = TextEditingController();

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  void getMessages() async {
    setState(() {
      showSpinner = true;
    });
    messageWidgets.clear();
    var messages = await widget.chatRepository.messages;
    for (var message in messages.reversed) {
      if (message.runtimeType.toString() == 'ChatMessageGeolocationDto') {
        messageWidgets.add(
          MessageBubble(
            author: message.author.name,
            text: message.toString(),
            isMe: message.author.name == 'SuperSasha',
          ),
        );
      } else {
        messageWidgets.add(
          MessageBubble(
            author: message.author.name,
            text: message.message,
            isMe: message.author.name == 'SuperSasha',
          ),
        );
      }
    }
    setState(() {
      showSpinner = false;
    });
  }

  void sendMessage() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await widget.chatRepository.sendMessage('SuperSasha', messageText);
    } catch (e) {
      print(e);
    }
    getMessages();
  }

  Future<dynamic> getLocation() async {
    setState(() {
      showSpinner = true;
    });
    Location location = Location();
    await location.getCurrentLocation();
    print(location.latitude);
    print(location.longitude);
    ChatGeolocationDto geo = ChatGeolocationDto(
        latitude: location.latitude, longitude: location.longitude);

    try {
      await widget.chatRepository.sendGeolocationMessage(
        nickname: 'SuperSasha',
        location: geo,
      );
      // https://www.google.ru/maps/@${location.latitude},${location.longitude}
    } catch (e) {
      print(e);
    }
    getMessages();
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
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  getMessages();
                  messageWidgets.clear();
                }),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: messageWidgets,
                    //itemExtent: 40,
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          getLocation();
                        },
                        child: const Icon(Icons.share_location_outlined,
                            color: Colors.black),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Сообщение',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            controller: messageTextController,
                            onChanged: (value) {
                              setState(() {
                                messageText = value;
                              });
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (messageText == '') {
                            return;
                          } else {
                            messageTextController.clear();
                            sendMessage();
                          }
                        },
                        child: !showSpinner
                            ? const Icon(Icons.send, color: Colors.black)
                            : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
    throw UnimplementedError();
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.author,
    required this.text,
    required this.isMe,
    this.isGeo = false,
  });

  final String author;
  final String text;
  final bool isMe;
  final bool isGeo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
      child: Row(
        children: [
          Chip(
            label: Text('$author', style: const TextStyle(fontSize: 14)),
            backgroundColor: Colors.white,
            side: const BorderSide(width: 1.0, color: Color(0xFFD0EDF2)),
            avatar: CircleAvatar(
              backgroundColor: Color(
                      (author.hashCode.toInt() / 1000000000 * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              child: Text(
                author.toUpperCase().substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: isMe
                  ? const Color(0xFF3E9AAA).withOpacity(0.25)
                  : const Color(0xFFC3B47A).withOpacity(0.25),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('$text', style: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
