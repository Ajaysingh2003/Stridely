
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      child: Center(
        child: Text(
          'Second Screen',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

}