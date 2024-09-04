import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dhikr {
  String id;
  String title;
  Color beadsColor;
  Color stringColor;
  Color backgroundColor;
  String totalCount;
  int lastCount;
  Timestamp timestamp;
  String pray;

  Dhikr(
      {required this.id,
      required this.title,
      required this.beadsColor,
      required this.stringColor,
      required this.backgroundColor,
      required this.totalCount,
      this.lastCount = 0,
      required this.timestamp,
      this.pray = ""});

  factory Dhikr.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Dhikr(
      id: doc.id,
      title: data['title'],
      beadsColor: Color(data['beadsColor']),
      stringColor: Color(data['stringColor']),
      backgroundColor: Color(data['backgroundColor']),
      totalCount: data['totalCount'],
      lastCount: data['lastCount'],
      timestamp: data['timestamp'],
      pray: data['pray'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'beadsColor': beadsColor.value,
      'stringColor': stringColor.value,
      'backgroundColor': backgroundColor.value,
      'totalCount': totalCount,
      'lastCount': lastCount,
      'timestamp': timestamp,
      'pray': pray,
    };
  }
}
