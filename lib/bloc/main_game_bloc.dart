import "package:rxdart/rxdart.dart";
import 'package:hangman/bloc/bloc_base.dart';

class MainGameBloc implements BlocBase {
  final BehaviorSubject<List<String>> _selectedLettersSubject =
      new BehaviorSubject<List<String>>();
  final BehaviorSubject<List<String>> _randomWordSubject =
      new BehaviorSubject<List<String>>();

  Stream<List<String>> get selectedLettersStream =>
      _selectedLettersSubject.stream;
  Stream<List<String>> get randomWordStream => _randomWordSubject.stream;

  Stream get gameRoundStream => Observable.combineLatestList([
        randomWordStream,
        selectedLettersStream,
      ]);

  void randomizeWord() {
    _randomWordSubject.sink
        .add(['H', "E", "L", "L", "O", "W", "O", "R", "L", "D"]);
    _selectedLettersSubject.sink.add([]);
  }

  void selectLetter(String letter) {
    List<String> currentLetters = _selectedLettersSubject.value ?? [];

    currentLetters.add(letter.toUpperCase());

    _selectedLettersSubject.sink.add(currentLetters);
  }

  @override
  void dispose() {
    _selectedLettersSubject.close();
    _randomWordSubject.close();
  }
}
