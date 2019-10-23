import 'package:flutter/material.dart';
import 'package:hangman/widgets/letter_widget.dart';

class ChallengeWord extends StatelessWidget {
  final List<String> word;
  final List<String> selectedLetters;

  ChallengeWord({Key key, this.selectedLetters, this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: word != null && word.isNotEmpty
          ? FittedBox(
              child: Row(
                children: word
                    .map(
                      (letter) => LetterWidget(
                        selectedLetters.contains(letter) ? letter : null,
                      ),
                    )
                    .toList(),
              ),
            )
          : Container(),
    );
  }
}
