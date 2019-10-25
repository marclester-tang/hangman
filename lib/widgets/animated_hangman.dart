import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AnimatedHangman extends StatefulWidget {
  AnimatedHangman({Key key}) : super(key: key);

  @override
  _AnimatedHangmanState createState() {
    return _AnimatedHangmanState();
  }
}

class _AnimatedHangmanState extends State<AnimatedHangman> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlareActor("assets/anim/hangman.flr",
        alignment: Alignment.center, fit: BoxFit.contain, animation: "tie hands");
    ;
  }
}
