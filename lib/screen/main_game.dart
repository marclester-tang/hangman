import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hangman/bloc/bloc_provider.dart';
import 'package:hangman/bloc/main_game_bloc.dart';
import 'package:hangman/screen/home.dart';
import 'package:hangman/util/word_checker_util.dart';
import 'package:hangman/widgets/challenge_word.dart';
import 'package:hangman/widgets/keyboard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainGame extends StatefulWidget {
  MainGame({Key key}) : super(key: key);

  static const routeName = "/game";

  @override
  _MainGameState createState() {
    return _MainGameState();
  }
}

class _MainGameState extends State<MainGame> {
  MainGameBloc mainGameBloc;
  bool isSkipWordUsed = false;
  bool isRemoveWrongLettersUsed = false;
  bool isRevealLettersUsed = false;
  StreamSubscription<int> _wrongTriesCountStreamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mainGameBloc == null) {
      mainGameBloc = BlocProvider.of<MainGameBloc>(context);
      mainGameBloc.randomizeWord();
      _wrongTriesCountListener(mainGameBloc);
    }
  }

  @override
  void dispose() {
    super.dispose();
    mainGameBloc.dispose();
    _wrongTriesCountStreamSubscription.cancel();
  }

  void _wrongTriesCountListener(MainGameBloc bloc) {
    _wrongTriesCountStreamSubscription = bloc.wrongTriesCountStream.listen(
      (int wrongTriesCount) {
        if (wrongTriesCount >= mainGameBloc.maxNumberOfTries) {
          _onGameOver();
        }
      },
    );
  }

  Future<void> _onGameOver() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Game Over',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Exit'),
              onPressed: () => Navigator.popUntil(
                context,
                (route) => route.settings.name == Home.routeName,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpAction({IconData icon, Function onPressed, Color color}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(20),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(
            String.fromCharCode(icon.codePoint),
            style: TextStyle(
                fontSize: 30,
                fontFamily: icon.fontFamily,
                package: icon.fontPackage,
                color: Colors.white),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildHelpActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildHelpAction(
          icon: MdiIcons.debugStepOver,
          onPressed: isSkipWordUsed
              ? null
              : () {
                  mainGameBloc.skipWord();
                  setState(() {
                    isSkipWordUsed = true;
                  });
                },
          color: isSkipWordUsed ? Colors.grey : Colors.blue,
        ),
        _buildHelpAction(
          icon: MdiIcons.alphabeticalOff,
          onPressed: isRemoveWrongLettersUsed
              ? null
              : () {
                  mainGameBloc.removeWrongLetters();
                  setState(() {
                    isRemoveWrongLettersUsed = true;
                  });
                },
          color: isRemoveWrongLettersUsed ? Colors.grey : Colors.red,
        ),
        _buildHelpAction(
          icon: MdiIcons.eyeCircle,
          onPressed: isRevealLettersUsed
              ? null
              : () {
                  mainGameBloc.revealLetters();
                  setState(() {
                    isRevealLettersUsed = true;
                  });
                },
          color: isRevealLettersUsed ? Colors.grey : Colors.lime,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: mainGameBloc.gameRoundStream,
          builder: (context, snapshot) {
            final List<String> toGuess =
                snapshot.hasData ? (snapshot.data[0] ?? []) : [];
            final List<String> selectedLetters =
                snapshot.hasData ? (snapshot.data[1] ?? []) : [];
            final int wrongTriesCount =
                snapshot.hasData ? (snapshot.data[2] ?? 0) : 0;
            final bool isAlreadyGuessed =
                isWordGuessed(toGuess, selectedLetters);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChallengeWord(
                  word: toGuess,
                  selectedLetters: selectedLetters,
                  isAlreadyGuessed: isAlreadyGuessed,
                ),
                Expanded(
                  child: Placeholder(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHelpActions(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Number of Tries Left: ${mainGameBloc.maxNumberOfTries - wrongTriesCount}',
                      ),
                    ),
                  ],
                ),
                Keyboard(
                  selectedLetters: selectedLetters,
                  onPress: isAlreadyGuessed ? null : mainGameBloc.selectLetter,
                ),
                // Text(wrongAnswers.toString())
              ],
            );
          },
        ),
      ),
    );
  }
}
