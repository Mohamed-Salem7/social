import 'package:flutter/material.dart';

class MessageModels
{
  late String receiverId;
  late String senderId;
  late String text;
  late String dateTime;


  MessageModels({
    required this.receiverId,
    required this.senderId,
    required this.text,
    required this.dateTime,
  });


  MessageModels.fromJason(Map<String,dynamic> json)
  {
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    text = json['text'];
    dateTime = json['time'];
  }


  Map<String,dynamic> toMap()
  {
    return
      {
        'receiverId' : receiverId,
        'senderId' : senderId,
        'text' : text,
        'time' : dateTime,
      };
  }
}