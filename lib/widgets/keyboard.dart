import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Keyboard extends StatelessWidget {
  final List<String> selectedLetters;
  final onPress;

  Keyboard({Key key, this.selectedLetters, this.onPress})
      : super(key: key);

  final List<String> availableLetters = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];

  Widget letterButton(letter) => Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
          onTap: () {onPress(letter);},
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
                width: 30,
                height: 50,
                decoration: new BoxDecoration(
                    color: selectedLetters.indexOf(letter) > -1 ? Colors.grey : Colors.green,
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(10.0),
                    )),
                child: Center(
                    child: Text(
                  selectedLetters.indexOf(letter) > -1 ? "" : letter.toUpperCase(),
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ))),
          )));

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      alignment: WrapAlignment.center,
        children:
            availableLetters.map((letter) => letterButton(letter)).toList());
  }
}
