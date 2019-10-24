import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hangman/constants.dart';
import 'package:hangman/widgets/letter_widget.dart';

class Keyboard extends StatelessWidget {
  final List<String> selectedLetters;
  final Function onPress;

  Keyboard({Key key, this.selectedLetters, this.onPress}) : super(key: key);

  Widget letterButton(letter) => Padding(
        padding: EdgeInsets.all(2),
        child: GestureDetector(
          onTap:
              onPress == null || selectedLetters.contains(letter.toUpperCase())
                  ? null
                  : () {
                      onPress(letter);
                    },
          child: LetterWidget(
            selectedLetters.contains(letter.toUpperCase()) ? null : letter,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: LETTERS.map((letter) => letterButton(letter)).toList(),
    );
  }
}
