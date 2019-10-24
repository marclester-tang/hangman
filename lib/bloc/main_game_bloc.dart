import 'dart:math';

import 'package:hangman/util/word_checker_util.dart';
import 'package:random_words/random_words.dart';
import "package:rxdart/rxdart.dart";
import 'package:hangman/bloc/bloc_base.dart';

class MainGameBloc implements BlocBase {
  final BehaviorSubject<List<String>> _selectedLettersSubject =
      new BehaviorSubject<List<String>>();
  final BehaviorSubject<List<String>> _randomWordSubject =
      new BehaviorSubject<List<String>>();
  final BehaviorSubject<int> _wrongSelectionSubject =
      new BehaviorSubject<int>();

  Stream<List<String>> get selectedLettersStream =>
      _selectedLettersSubject.stream;
  Stream<List<String>> get randomWordStream => _randomWordSubject.stream;
  Stream<int> get wrongSelectionStream => _wrongSelectionSubject.stream;

  Stream get gameRoundStream => Observable.combineLatestList([
        randomWordStream,
        selectedLettersStream,
        wrongSelectionStream
      ]);

  void randomizeWord() {
    String randomWord = '';

    if (Random().nextInt(2) == 0) {
      generateNoun().take(1).forEach((n) {
        randomWord = n.asString;
      });
    } else {
      generateAdjective().take(1).forEach((a) {
        randomWord = a.asString;
      });
    }

    _randomWordSubject.sink.add(randomWord.toUpperCase().split(''));
    _selectedLettersSubject.sink.add([]);
    _wrongSelectionSubject.sink.add(0);
  }

  Future<void> selectLetter(String letter) async {
    List<String> currentLetters = _selectedLettersSubject.value ?? [];

    currentLetters.add(letter.toUpperCase());

    List<String> randomWord = _randomWordSubject.value ?? [];

    _selectedLettersSubject.sink.add(currentLetters);
    if(!_randomWordSubject.value.contains(letter.toUpperCase())) {
      _wrongSelectionSubject.sink.add(_wrongSelectionSubject.value + 1);
    }

    if (isWordGuessed(randomWord, currentLetters)) {
      await Future.delayed(Duration(seconds: 1));
      randomizeWord();

      return;
    }
  }

  @override
  void dispose() {
    _selectedLettersSubject.close();
    _randomWordSubject.close();
    _wrongSelectionSubject.close();
  }
}
