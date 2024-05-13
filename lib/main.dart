import 'package:flutter/material.dart';
import 'views/yahtzee.dart';

void main() {
  runApp(MaterialApp(
    title: 'Yahtzee',
    home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Yahtzee',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 5, 208, 79),
        ),
        body: const SafeArea(child: Yahtzee())),
    debugShowCheckedModeBanner: false,
  ));
}
