import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hangman/bloc/bloc_provider.dart';
import 'package:hangman/bloc/main_game_bloc.dart';
import 'package:hangman/screen/home.dart';
import 'package:hangman/util/word_checker_util.dart';
import 'package:hangman/widgets/animated_hangman.dart';
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
  StreamSubscription<int> _wrongTriesCountStreamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mainGameBloc == null) {
      mainGameBloc = BlocProvider.of<MainGameBloc>(context);
      mainGameBloc.initialize();
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
    mainGameBloc.revealWord();

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
    return StreamBuilder(
      stream: mainGameBloc.helpActionsUsedStream,
      builder: (context, snapshot) {
        final bool isSkipWordUsed =
            snapshot.hasData ? (snapshot.data[0] ?? false) : false;
        final bool isRemoveWrongLettersUsed =
            snapshot.hasData ? (snapshot.data[1] ?? false) : false;
        final bool isRevealLetterUsed =
            snapshot.hasData ? (snapshot.data[2] ?? false) : false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildHelpAction(
              icon: MdiIcons.debugStepOver,
              onPressed: isSkipWordUsed ? null : mainGameBloc.skipWord,
              color: isSkipWordUsed ? Colors.grey : Colors.blue,
            ),
            _buildHelpAction(
              icon: MdiIcons.alphabeticalOff,
              onPressed: isRemoveWrongLettersUsed
                  ? null
                  : mainGameBloc.removeWrongLetters,
              color: isRemoveWrongLettersUsed ? Colors.grey : Colors.red,
            ),
            _buildHelpAction(
              icon: MdiIcons.eyeCircle,
              onPressed: isRevealLetterUsed ? null : mainGameBloc.revealLetter,
              color: isRevealLetterUsed ? Colors.grey : Colors.lime,
            ),
          ],
        );
      },
    );
  }

  Widget _buildScoreStatsWidget() {
    return StreamBuilder(
      stream: mainGameBloc.scoreStatsStream,
      builder: (context, snapshot) {
        final int score = snapshot.hasData ? (snapshot.data[0] ?? 0) : 0;
        final int wrongTriesCount =
            snapshot.hasData ? (snapshot.data[1] ?? 0) : 0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Score: $score',
              ),
              Text(
                'Number of Tries Left: ${mainGameBloc.maxNumberOfTries - wrongTriesCount}',
              ),
            ],
          ),
        );
      },
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
                  child: AnimatedHangman(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHelpActions(),
                    _buildScoreStatsWidget(),
                  ],
                ),
                Keyboard(
                  selectedLetters: selectedLetters,
                  onPress: isAlreadyGuessed ? null : mainGameBloc.selectLetter,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
