import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class Question extends StatefulWidget {
  @override
  QuestionState createState() => QuestionState();

  String questionDescription;
  List options;
}

class QuestionState extends State<Question> {
  final _questionList = <Question>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _savedQuestion = Set<Question>();

  Widget _buildQuestionList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _questionList.length) {
            _questionList.addAll(getNewQuestions().take(10)); /*4*/
          }
          return _buildRow(_questionList[index]);
        });
  }

  Widget _buildRow(Question question) {
    final alreadySaved = _savedQuestion.contains(question);
    return _listTileQuestionFavouritePage(question, alreadySaved);
  }

  void _pushSavedQuestion() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedQuestion.map((Question question) {
        return _listTileQuestionMainPage(question);
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text("Saved questions"),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  Iterable<Question> getNewQuestions() {
    var questionList = new List<Question>();
    var question = new Question();
    final mockQuestions = new File('./question_db/mock_questions.txt');

    var questionsMap = {
      0: ["What do you think of ISIS?", "Good", "Bad"],
      1: ["Is Corona exagerated?", "Yes", "No"],
      2: ["Tabs or spaces?", "Tabs", "Spaces"]
    };
    Random rnd;

    rnd = new Random();
    var randomQuestionIndex = rnd.nextInt(questionsMap.length);
    question.questionDescription = questionsMap[randomQuestionIndex][0];
    question.options = questionsMap[randomQuestionIndex];
    questionList.add(question);

    //question.questionDescription = "questionDesc";
    //question.options = "option_1";
    //questionList.add(question);
    return questionList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhaddYaThink'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSavedQuestion)
        ],
      ),
      body: _buildQuestionList(),
    );
  }
  Widget _listTileQuestionMainPage(Question question) {
    return ListTile(
      title: Text(
        question.questionDescription,
        style: TextStyle(fontSize: 16),
      ),
      //subtitle: Text(question.options[1] + " - " + question.options[2])
      subtitle: ButtonBar(children: <Widget>[
        FlatButton(
          child: Text(question.options[1]),
          color: Colors.blue,
          onPressed: () {/** */},
        ),FlatButton(
          child: Text(question.options[2]),
          color: Colors.blue,
          onPressed: () {/** */},
        )]),
    );
  }
  Widget _listTileQuestionFavouritePage(Question question, bool alreadySaved) {
    return ListTile(
        title: Text(
          question.questionDescription,
          style: _biggerFont,
        ),
        subtitle: ButtonBar(children: <Widget>[
          FlatButton(
            child: Text(question.options[1]),
            color: Colors.blue,
            onPressed: () {/** */},
          ),FlatButton(
            child: Text(question.options[2]),
            color: Colors.blue,
            onPressed: () {/** */},
          )]),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _savedQuestion.remove(question);
            } else {
              _savedQuestion.add(question);
            }
          });
        });
  }





}
