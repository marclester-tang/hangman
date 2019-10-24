import 'dart:math';

import 'package:hangman/constants.dart';
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
  Stream get gameRoundStream => Observable.combineLatestList(
      [randomWordStream, selectedLettersStream, wrongSelectionStream]);

  List<String> alreadyAppearedWords = [];

  Future<void> revealWord() async {
    final List<String> currentLetters = _selectedLettersSubject.value ?? [];
    final List<String> randomWord = _randomWordSubject.value ?? [];

    _selectedLettersSubject.sink.add([
      ...currentLetters,
      ...randomWord,
    ]);

    await nextWord();
  }

  Future<void> nextWord() async {
    await Future.delayed(Duration(seconds: 1));
    randomizeWord();
  }

  void randomizeWord() {
    final String randomWord = generateNoun().take(1).toList()[0].asString;
    _selectedLettersSubject.sink.add([]);
    _wrongSelectionSubject.sink.add(0);

    if (randomWord.length < 5 ||
        (alreadyAppearedWords.contains(randomWord) &&
            alreadyAppearedWords.length < 1000)) {
      randomizeWord();
      return;
    }

    if (alreadyAppearedWords.length >= 1000) {
      alreadyAppearedWords = [];
    }

    alreadyAppearedWords.add(randomWord);

    _randomWordSubject.sink.add(randomWord.toUpperCase().split(''));
  }

  Future<void> selectLetter(String letter) async {
    List<String> currentLetters = _selectedLettersSubject.value ?? [];

    currentLetters.add(letter.toUpperCase());

    List<String> randomWord = _randomWordSubject.value ?? [];

    _selectedLettersSubject.sink.add(currentLetters);
    if (!_randomWordSubject.value.contains(letter.toUpperCase())) {
      _wrongSelectionSubject.sink.add(_wrongSelectionSubject.value + 1);
    }

    if (isWordGuessed(randomWord, currentLetters)) {
      await nextWord();
      return;
    }
  }

  Future<void> skipWord() async {
    await revealWord();
  }

  void removeWrongLetters() {
    final List<String> currentLetters = _selectedLettersSubject.value ?? [];
    final List<String> randomWord = _randomWordSubject.value ?? [];
    final List<String> unselectedWrongLetters = LETTERS
        .where((String letter) =>
            ![...randomWord, ...currentLetters].contains(letter))
        .toList();

    if (unselectedWrongLetters.isEmpty) {
      return;
    }

    unselectedWrongLetters.shuffle();

    _selectedLettersSubject.sink.add([
      ...currentLetters,
      ...unselectedWrongLetters.sublist(
          0, (unselectedWrongLetters.length / 2).ceil()),
    ]);
  }

  Future<void> revealLetters() async {
    final List<String> randomWord = _randomWordSubject.value ?? [];
    final List<String> currentLetters = _selectedLettersSubject.value ?? [];
    final List<String> unrevealedLetters = randomWord
        .where((String letter) => !currentLetters.contains(letter))
        .toList();

    if (unrevealedLetters.isEmpty) {
      return;
    }

    final int letterIndex = Random().nextInt(unrevealedLetters.length);
    final String letterToReveal = unrevealedLetters[letterIndex];
    final List<String> updatedCurrentLetters = [
      ...currentLetters,
      letterToReveal,
    ];

    _selectedLettersSubject.sink.add(updatedCurrentLetters);

    if (isWordGuessed(randomWord, updatedCurrentLetters)) {
      await nextWord();
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
