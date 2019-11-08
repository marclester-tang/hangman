import 'package:flutter/material.dart';
import 'package:hangman/screen/main_game.dart';
import 'package:hangman/screen/leaderboard.dart';

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.7), BlendMode.dstATop),
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "HANGMAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(MainGame.routeName);
                },
                child: Text(
                  'New Game',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Leaderboard.routeName);
                },
                child: Text(
                  'Highscores',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
