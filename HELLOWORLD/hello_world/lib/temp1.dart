
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.lightBlue,
                title: Text("My First App"),
            ),
            
            backgroundColor: Colors.black,
            
            body: Center(
                child: Text("Hello World"),
            ),
        ),
    ),
  );
}