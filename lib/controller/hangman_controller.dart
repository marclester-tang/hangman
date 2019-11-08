import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

enum Animation { STEP1, STEP2, STEP3, STEP4, STEP5 }

class HangmanController extends FlareControls {
  String _default;
  String _tieHands;
  String _tieHandsWithRope;
  String _tieFeet;
  String _tieFeetWithRope;
  String _coverHead;
  String _nooze;
  String _hang;
  List<String> animations;


  HangmanController(){
    _default = "0";
    _tieHands = "1. tie hands";
    _tieHandsWithRope = "2. tie hands w/ rope";
    _tieFeet = "3. tie feet";
    _tieFeetWithRope = "4. tie feet w/ rope";
    _coverHead = "5. cover head";
    _nooze = "6. noose";
    _hang = "7. hang";
    animations = [
      _default,
      _tieHands,
      _tieHandsWithRope,
      _tieFeet,
      _tieFeetWithRope,
      _coverHead,
      _nooze,
      _hang
    ];
  }

  void playAnimationByTries(int tries) {
    this.play(animations[tries]);
  }
}
