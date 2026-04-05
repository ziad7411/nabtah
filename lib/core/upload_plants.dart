import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print("🚀 Uploading plants...");

  final String response =
      await rootBundle.loadString('assets/plants.json');

  final List data = jsonDecode(response);

  WriteBatch batch = FirebaseFirestore.instance.batch();

  for (var plant in data) {
    final doc =
        FirebaseFirestore.instance.collection('plants').doc();

    batch.set(doc, plant);
  }

  await batch.commit();

  print("🎉 Done Uploading!");
}