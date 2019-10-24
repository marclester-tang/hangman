import 'package:flutter/material.dart';
import 'package:hangman/widgets/letter_widget.dart';

class ChallengeWord extends StatelessWidget {
  final List<String> word;
  final List<String> selectedLetters;
  final bool isAlreadyGuessed;

  ChallengeWord(
      {Key key, this.selectedLetters, this.word, this.isAlreadyGuessed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: word != null && word.isNotEmpty
          ? FittedBox(
              child: Row(
                children: word
                    .map(
                      (letter) => LetterWidget(
                        selectedLetters.contains(letter) ? letter : null,
                        isHighlighted: isAlreadyGuessed,
                      ),
                    )
                    .toList(),
              ),
            )
          : Container(),
    );
  }
}
