import 'package:ai_chat_bot/apis/appwrite.dart';
import 'package:ai_chat_bot/config/config.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  Future<void> _initializeMessages() async {
    List<Document> dbMessages = await Appwrite.getItems(env['msg_collection_id'] ?? '');
    List<Map<String, String>> formattedMessages = dbMessages.map((doc) {
      return {
        'sender': doc.data['sender']?.toString() ?? '',
        'text': doc.data['text'].toString(),
      };
    }).toList();
    setState(() {
      messages = formattedMessages;
    });
  }

  // makes app scroll to bottom when new message is added
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // function to send message
  void sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'text': text, 'sender': 'user'});
      controller.clear();
    });
    _scrollToBottom();
    Appwrite.addMessage(env['msg_collection_id'] ?? '', {'sender': 'user', 'text': text}); // adds user message to db

    String fullRes = "";
    setState(() {
      messages.add({'text': "", 'sender': 'ai'});
    });
    Gemini.instance.promptStream(
        parts: [Part.text(text)], model: "gemini-1.5-flash").listen((value) {
      final res = value?.output ?? '';
      fullRes += " $res";
      setState(() {
        // ignore: prefer_interpolation_to_compose_strings
        messages[messages.length - 1]['text'] = (messages[messages.length - 1]['text'] ?? '') + " $res";
      });
      _scrollToBottom();
    }, onDone: () {
      setState(() {
        messages[messages.length - 1]['text'] = fullRes;
        Appwrite.addMessage(env['msg_collection_id'] ?? '', {'sender': 'ai', 'text': fullRes}); // adds ai response to db
      });
    });
  }

  // ui of chat page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Chat Page'),
      // ),
      backgroundColor: Color(0xff253649),
      extendBody: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/download.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isUser ? const Color.fromARGB(143, 2, 40, 69) : const Color.fromARGB(140, 3, 65, 5),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.lightBlue,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: TextStyle(color: Colors.white70), // Change this line to set the text color-
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white70,),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
        ],
      )
    );
  }
}
