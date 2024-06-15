import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sexpertise/Interfaces/ChatBot/History.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final bool isFromHistory;
  String? messageId;
  ChatScreen({required this.isFromHistory, this.messageId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isLoading = false; // Add this variable

  @override
  void initState() {
    super.initState();
    if (widget.isFromHistory) {
      _loadMessageHistory();
    } else {
      // Simulate receiving a message after 2 seconds
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    // _loadMessageHistory();
    // Show typing indicator while fetching response
    _sendMessage(text);
    _showTypingIndicator(true);
  }

  void _showTypingIndicator(bool show) {
    if (show) {
      ChatMessage typingMessage = ChatMessage(
        text: 'Typing...',
        isUserMessage: false,
        isTyping: true,
      );
      setState(() {
        _messages.insert(0, typingMessage);
      });
    } else {
      // Remove the typing indicator when the response is received
      _messages.removeWhere((message) => message.isTyping);
    }
  }

  void _loadMessageHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? historyStrings =
        prefs.getStringList(MessageHistory.historyKey);

    if (historyStrings == null) {
      return;
    }

    // Extract unique conversation IDs from the loaded messages
    Set conversationIds = historyStrings.map((String jsonString) {
      Map<String, dynamic> jsonMap =
          Map<String, dynamic>.from(json.decode(jsonString));
      return jsonMap['conversationId'];
    }).toSet();

    // Load messages for each conversation
    for (String conversationId in conversationIds) {
      List<Message> conversationMessages =
          await MessageHistory.getMessageHistoryByConversation(conversationId);

      // Display the messages in the UI, you may need to update your UI accordingly
      for (Message message in conversationMessages.reversed) {
        _receiveMessage(message.text, message.isUserMessage);
      }
    }
  }

  void _sendMessage(String text) {
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUserMessage: true,
      isTyping: false,
    );
    _saveMessageToHistory(text, true); // Save user message to history

    // Fetch response from the API
    _fetchResponse(text);
    setState(() {
      _messages.insert(0, userMessage);
    });
  }

  void _fetchResponse(String userMessage) async {
    try {
      String apiUrl =
          ' https://33c4-35-231-115-10.ngrok-free.app/?message=$userMessage';

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      var request = await httpClient.getUrl(Uri.parse(apiUrl));
      var response = await request.close();
      // var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // String botResponse = response.body;
        String botResponse = await response.transform(utf8.decoder).join();
        _showTypingIndicator(false); // Hide typing indicator
        _receiveMessage(botResponse, false);
      } else {
        //throw Exception('Failed to fetch response');
        throw Exception('Failed to fetch response: ${response.statusCode}');
      }
    } catch (e) {
      _showTypingIndicator(false); // Hide typing indicator on error
      print('Error fetching response: $e');
    }
  }

  void _receiveMessage(String text, bool isUserMessage) {
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: isUserMessage,
      isTyping: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _saveMessageToHistory(String text, bool isUserMessage) async {
    final String conversationId =
        DateTime.now().millisecondsSinceEpoch.toString();

    MessageHistory.saveMessage(Message(
      id: '',
      text: text,
      isUserMessage: isUserMessage,
      conversationId: conversationId,
      timestamp: DateTime.now(), // Include the timestamp
    ));
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(
        color: Color.fromARGB(255, 0, 74, 173),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type something here....',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 35,
              child: Image.asset('lib/Assets/chatbot.png'),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sexpertise Chatbot",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 74, 173),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Stack(
              children: [
                ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) => _messages[index],
                ),
              ],
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final bool isTyping;

  ChatMessage(
      {required this.text,
      required this.isUserMessage,
      required this.isTyping});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the alignment and colors based on isUserMessage
    CrossAxisAlignment messageAlignment =
        isUserMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    Color bubbleColor = isUserMessage
        ? Colors.blueGrey.withOpacity(0.5)
        : const Color.fromARGB(255, 0, 74, 173);
    Color textColor = isUserMessage ? Colors.black : Colors.white;

    return Container(
      width: screenWidth,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (isUserMessage) // Add user icon for user messages
            Spacer(),
          Column(
            crossAxisAlignment: messageAlignment,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: bubbleColor,
                ),
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
