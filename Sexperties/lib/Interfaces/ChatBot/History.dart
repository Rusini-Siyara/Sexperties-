import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Message {
  late String id;
  late String text;
  late bool isUserMessage;
  DateTime timestamp;
  late String conversationId; // Add this field

  Message(
      {required this.id,
      required this.text,
      required this.timestamp,
      required this.isUserMessage,
      required this.conversationId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isUserMessage': isUserMessage,
      'conversationId':
          conversationId, // Include conversationId in serialization
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isUserMessage: json['isUserMessage'],
      conversationId: json['conversationId'], // Deserialize conversationId
    );
  }
}

class MessageHistory {
  static const String _historyKey = 'message_history';
  static String get historyKey => _historyKey;

  static Future<void> saveMessage(Message message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyStrings = prefs.getStringList(_historyKey) ?? [];

    // Add a unique ID to the message
    message.id = DateTime.now().millisecondsSinceEpoch.toString();

    historyStrings
        .add(json.encode(message.toJson())); // Convert Message to JSON string
    await prefs.setStringList(_historyKey, historyStrings);
  }

  static Future<List<Message>> getMessageHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the value from SharedPreferences
    final List<String>? historyStrings = prefs.getStringList(_historyKey);

    if (historyStrings == null) {
      return [];
    }

    List<Message> history = historyStrings.map((String jsonString) {
      Map<String, dynamic> jsonMap =
          Map<String, dynamic>.from(json.decode(jsonString));
      return Message.fromJson(jsonMap);
    }).toList();

    return history;
  }

  static Future<List<Message>> getMessageHistoryByConversation(
      String conversationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? historyStrings = prefs.getStringList(_historyKey);

    if (historyStrings == null) {
      return [];
    }

    List<Message> conversationMessages = historyStrings
        .map((String jsonString) => Message.fromJson(json.decode(jsonString)))
        .where((message) => message.conversationId == conversationId)
        .toList();

    return conversationMessages;
  }

  static Future<void> clearMessageHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
