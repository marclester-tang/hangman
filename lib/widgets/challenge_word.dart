import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChallengeWord extends StatelessWidget {
  final List<String> word;
  final List<String> selectedLetters;

  ChallengeWord({Key key, this.selectedLetters, this.word}) : super(key: key);

  Widget letterButton(letter) {
    String checkLetter = letter.toLowerCase();
    return Padding(
        padding: EdgeInsets.all(2),
        child: Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
              width: 30,
              height: 50,
              decoration: new BoxDecoration(
                  color: selectedLetters.indexOf(checkLetter) > -1
                      ? Colors.green
                      : Colors.grey,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(10.0),
                  )),
              child: Center(
                  child: Text(
                selectedLetters.indexOf(checkLetter) > -1
                    ? letter.toUpperCase()
                    : "",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        //alignment: WrapAlignment.center,
        child: Row(
        children: (word ?? ["A", "B"]).map((letter) => letterButton(letter)).toList())
    ));
  }
}
