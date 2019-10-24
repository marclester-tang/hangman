import 'package:flutter/material.dart';

class LetterWidget extends StatelessWidget {
  final String letter;
  final bool isHighlighted;

  LetterWidget(this.letter, {this.isHighlighted = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 30,
          height: 50,
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.orange
                : letter != null ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          child: Center(
            child: Text(
              letter != null ? letter.toUpperCase() : "",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
