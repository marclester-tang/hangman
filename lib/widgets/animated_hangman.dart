import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flutter/material.dart';
import 'package:hangman/controller/hangman_controller.dart';

class AnimatedHangman extends StatefulWidget {

  final HangmanController controller;

  AnimatedHangman({Key key, this.controller}) : super(key: key);

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
    return FlareActor(
      "assets/anim/hangman.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      controller: widget.controller,
    );
    ;
  }
}
