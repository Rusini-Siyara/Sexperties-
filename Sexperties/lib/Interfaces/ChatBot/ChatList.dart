import 'package:flutter/material.dart';
import 'package:sexpertise/Interfaces/ChatBot/ChatUI.dart';
import 'package:sexpertise/Interfaces/ChatBot/History.dart';


class Conversation {
  final String id;
  final String text;
  final bool isUserMessage;

  Conversation({
    required this.id,
    required this.text,
    required this.isUserMessage,
  });
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  TextEditingController _search = TextEditingController();
  String search = '';
  List<Message> _messageHistory = [];
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadMessageHistory();
  }

  void _loadMessageHistory() async {
    List<Message> history = await MessageHistory.getMessageHistory();

    // Map to store the latest message for each conversation ID
    Map<String, Message> lastMessagesMap = {};

    for (Message message in history) {
      if (!lastMessagesMap.containsKey(message.conversationId) ||
          lastMessagesMap[message.conversationId]!
              .timestamp
              .isBefore(message.timestamp)) {
        lastMessagesMap[message.conversationId] = message;
      }
    }

    List<Conversation> conversations = lastMessagesMap.values.map((message) {
      return Conversation(
        id: message.conversationId,
        text: message.text,
        isUserMessage: message.isUserMessage,
      );
    }).toList();

    setState(() {
      _conversations = conversations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Chats",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 74, 173),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'option1',
                  child: Text('Clear History'),
                ),
              ];
            },
            onSelected: (String value) {
              MessageHistory.clearMessageHistory();
              setState(() {
                _loadMessageHistory();
              });
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          isFromHistory: false,
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add_circle,
                    color: Color.fromARGB(255, 0, 74, 173),
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    width: 100,
                    height: 45,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 0, 74, 173),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 74, 173),
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Search',
                      ),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          search = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            isFromHistory: true,
                            messageId: _conversations[index].id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 18),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 243, 243),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 74, 173),
                        ),
                      ),
                      child: Wrap(
                        children: [
                          Text(
                            _conversations[index].text,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
