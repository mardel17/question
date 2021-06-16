import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:question/utils/const.dart';
import 'package:question/utils/globals.dart' as Globals;

import 'package:question/model/question.dart';
import 'package:question/model/detail.dart';

class HomeProvider with ChangeNotifier {
  bool _isValidate;
  bool get isValidate => _isValidate ?? false;
  set isValidate(bool value) {
    _isValidate = value;
    notifyListeners();
  }

  Future<List<Question>> getMCQFromServer() async {
    try {
      final http.Response response = await http.get(
        BASE_URL + API.MCQ_TYPE + "mcq",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Globals.userToken,
        },
      );

      // print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result["success"] == true) {
        return Question.fromJsonList(result["mcqs"] as List);
      } else {
        return Future.error(Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(child: Text(result[API.MESSAGE] ?? "")),
        ));
        // return Future.error(Container());
      }
    } catch (e) {
      throw Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Échec de la connexion au serveur'),
        ),
      );
    }
  }

  Future<List<Question>> getASMRFromServer() async {
    try {
      final http.Response response = await http.get(
        BASE_URL + API.MCQ_TYPE + "asmr",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Globals.userToken,
        },
      );

      // print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result["success"] == true) {
        return Question.fromJsonList(result["mcqs"] as List);
      } else {
        return Future.error(Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(child: Text(result[API.MESSAGE] ?? "")),
        ));
        // return Future.error(Container());
      }
    } catch (e) {
      throw Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Échec de la connexion au serveur'),
        ),
      );
    }
  }

  Future<Detail> getDetailFromServer(String id) async {
    try {
      final http.Response response = await http.get(
        BASE_URL + API.MCQ_DETAIL + id,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Globals.userToken,
        },
      );

      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result["success"] == true) {
        return Detail.fromJson(result);
      } else {
        return Future.error(Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(child: Text(result[API.MESSAGE] ?? "")),
        ));
        // return Future.error(Container());
      }
    } catch (e) {
      throw Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Échec de la connexion au serveur'),
        ),
      );
    }
  }
}
