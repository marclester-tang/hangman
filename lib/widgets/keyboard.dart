import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hangman/widgets/letter_widget.dart';

class Keyboard extends StatelessWidget {
  final List<String> selectedLetters;
  final onPress;

  Keyboard({Key key, this.selectedLetters, this.onPress}) : super(key: key);

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
          onTap: () {
            onPress(letter);
          },
          child: LetterWidget(
            selectedLetters.contains(letter) ? null : letter,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: availableLetters.map((letter) => letterButton(letter)).toList(),
    );
  }
}
