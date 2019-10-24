import 'package:flutter/material.dart';
import 'package:hangman/bloc/bloc_provider.dart';
import 'package:hangman/bloc/main_game_bloc.dart';
import 'package:hangman/util/word_checker_util.dart';
import 'package:hangman/widgets/challenge_word.dart';
import 'package:hangman/widgets/keyboard.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mainGameBloc == null) {
      mainGameBloc = BlocProvider.of<MainGameBloc>(context);
      mainGameBloc.randomizeWord();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
