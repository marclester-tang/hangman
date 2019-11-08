import 'package:flutter/material.dart';
import 'package:hangman/screen/main_game.dart';
import 'package:hangman/screen/leaderboard.dart';
import 'package:hangman/widgets/keyboard.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  static const routeName = "/";

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
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
    int _counter = 0;

    void _incrementCounter() {
      setState(() {
        _counter++;
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MainGame.routeName);
              },
              child: Text('New Game'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Leaderboard.routeName);
              },
              child: Text('Highscores'),
            ),
          ],
        ),
      ),
    );
  }
}
