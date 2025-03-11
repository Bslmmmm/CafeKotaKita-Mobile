import 'package:flutter/material.dart';

class Comunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comunity"),
        backgroundColor: Color(0xFFB13841)
       
      ),
      body: Center(
        child: Text(
          "Comunity",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}