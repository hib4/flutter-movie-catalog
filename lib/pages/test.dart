import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Table(
            children: [
              TableRow(
                children: [
                  Text("Halle"),
                  Text("Halle"),
                  Text("Halle"),
                ]
              )
            ],
          ),
        ],
      ),
    );
  }
}
