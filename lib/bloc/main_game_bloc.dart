import "package:rxdart/rxdart.dart";
import 'package:hangman/bloc/bloc_base.dart';

class MainGameBloc implements BlocBase {
  final BehaviorSubject<List<String>> _selectedLetters = new BehaviorSubject<List<String>>();
  final BehaviorSubject<List<String>> _randomWord = new BehaviorSubject<List<String>>();

  Stream<List<String>> get selectedLetters => _selectedLetters.stream;
  Stream<List<String>> get randomWord => _randomWord.stream;

  Stream get gameRoundStream => CombineLatestStream([
    randomWord,
    selectedLetters,
  ], (values) => values);

  void randomizeWord() {
    _randomWord.sink.add(['H', "E", "L", "L", "O", "W", "O", "R", "L", "D"]);
  }

  void selectLetter(String letter) {
    List<String> currentLetters = _selectedLetters.value ?? [];

    currentLetters.add(letter);

    _selectedLetters.sink.add(currentLetters);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _selectedLetters.close();
    _randomWord.close();
  }

}