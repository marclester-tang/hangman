import 'dart:math';

import 'package:hangman/constants.dart';
import 'package:hangman/util/word_checker_util.dart';
import 'package:random_words/random_words.dart';
import "package:rxdart/rxdart.dart";
import 'package:hangman/bloc/bloc_base.dart';

class MainGameBloc implements BlocBase {
  final int maxNumberOfTries = 7;
  final int pointPerCorrectTry = 10;

  final BehaviorSubject<List<String>> _selectedLettersSubject =
      new BehaviorSubject<List<String>>();
  final BehaviorSubject<List<String>> _randomWordSubject =
      new BehaviorSubject<List<String>>();
  final BehaviorSubject<int> _wrongTriesCountSubject =
      new BehaviorSubject<int>();
  final BehaviorSubject<bool> _isSkipWordUsedSubject =
      new BehaviorSubject<bool>();
  final BehaviorSubject<bool> _isRemoveWrongLettersUsedSubject =
      new BehaviorSubject<bool>();
  final BehaviorSubject<bool> _isRevealLetterUsedSubject =
      new BehaviorSubject<bool>();
  final BehaviorSubject<int> _scoreSubject = new BehaviorSubject<int>();

  Stream<List<String>> get selectedLettersStream =>
      _selectedLettersSubject.stream;
  Stream<List<String>> get randomWordStream => _randomWordSubject.stream;
  Stream<int> get wrongTriesCountStream => _wrongTriesCountSubject.stream;
  Stream get gameRoundStream => CombineLatestStream.list([
        randomWordStream,
        selectedLettersStream,
      ]);
  Stream<bool> get isSkipWordUsedStream => _isSkipWordUsedSubject.stream;
  Stream<bool> get isRemoveWrongLettersUsedStream =>
      _isRemoveWrongLettersUsedSubject.stream;
  Stream<bool> get isRevealLetterUsedStream =>
      _isRevealLetterUsedSubject.stream;
  Stream get helpActionsUsedStream => CombineLatestStream.list([
        isSkipWordUsedStream,
        isRemoveWrongLettersUsedStream,
        isRevealLetterUsedStream,
      ]);
  Stream<int> get scoreStream => _scoreSubject.stream;
  Stream get scoreStatsStream => CombineLatestStream.list([
        scoreStream,
        wrongTriesCountStream,
      ]);

  List<String> alreadyAppearedWords = [];

  @override
  void dispose() {
    _selectedLettersSubject.close();
    _randomWordSubject.close();
    _wrongTriesCountSubject.close();
    _isSkipWordUsedSubject.close();
    _isRemoveWrongLettersUsedSubject.close();
    _isRevealLetterUsedSubject.close();
    _scoreSubject.close();
  }

  void initialize() {
    _isSkipWordUsedSubject.sink.add(false);
    _isRemoveWrongLettersUsedSubject.sink.add(false);
    _isRevealLetterUsedSubject.sink.add(false);
    _scoreSubject.sink.add(0);
    _wrongTriesCountSubject.sink.add(0);

    randomizeWord();
  }

  Future<void> revealWord() async {
    final List<String> currentLetters = _selectedLettersSubject.value ?? [];
    final List<String> randomWord = _randomWordSubject.value ?? [];

    _selectedLettersSubject.sink.add([
      ...currentLetters,
      ...randomWord,
    ]);

    if (_wrongTriesCountSubject.value < maxNumberOfTries) {
      await nextWord();
    }
  }

  Future<void> nextWord() async {
    await Future.delayed(Duration(seconds: 1));
    randomizeWord();
  }

  void randomizeWord() {
    String randomWord = '';

    if (Random().nextInt(2) == 0) {
      randomWord = generateNoun().take(1).toList()[0].asString;
    } else {
      randomWord = generateAdjective().take(1).toList()[0].asString;
    }

    _selectedLettersSubject.sink.add([]);
    _wrongTriesCountSubject.sink.add(0);

    if (randomWord.length < 5 ||
        (alreadyAppearedWords.contains(randomWord) &&
            alreadyAppearedWords.length < 500)) {
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
      _wrongTriesCountSubject.sink.add(_wrongTriesCountSubject.value + 1);
    }

    if (isWordGuessed(randomWord, currentLetters)) {
      _scoreSubject.sink.add(_scoreSubject.value +
          (pointPerCorrectTry +
              (maxNumberOfTries - _wrongTriesCountSubject.value - 1)));
      await nextWord();
      return;
    }
  }

  Future<void> skipWord() async {
    _isSkipWordUsedSubject.sink.add(true);

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

    _isRemoveWrongLettersUsedSubject.sink.add(true);
  }

  Future<void> revealLetter() async {
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
    _isRevealLetterUsedSubject.sink.add(true);

    if (isWordGuessed(randomWord, updatedCurrentLetters)) {
      await nextWord();
      return;
    }
  }
}
