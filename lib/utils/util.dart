import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/globals.dart' as Globals;
import 'package:question/model/user.dart';

class Util {
  static Future<String> login(String username, String password) async {
    try {
      final http.Response response = await http.post(BASE_URL + API.USER_LOGIN,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'username': username,
            'password': password,
          }));
      // print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(KEY.SAVED_USER_NAME, username);
        prefs.setString(KEY.SAVED_USER_PASSWORD, password);

        Globals.userToken = result["token"] ?? "";
        return "Success";
      } else {
        List<dynamic> errors = result["errors"] as List;
        if (errors != null && errors.length > 0) {
          return errors[0];
        } else {
          return "Échec de la connexion";
        }
      }
    } catch (e) {
      // print(e);
      return "Échec de la connexion";
    }
  }

  static Future<String> signup(
      String username, String email, String password) async {
    try {
      final http.Response response =
          await http.post(BASE_URL + API.USER_REGISTER,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'username': username,
                'email': email,
                'password': password,
              }));
      // print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(KEY.SAVED_USER_NAME, username);
        prefs.setString(KEY.SAVED_USER_PASSWORD, password);

        Globals.userToken = result["token"] ?? "";
        return "Success";
      } else {
        Map<String, String> errors = Map.from(result["errors"]);
        if (errors != null) {
          return errors.values.toList()[0];
        } else {
          return "Échec de l'inscription";
        }
      }
    } catch (e) {
      return "Échec de l'inscription";
    }
  }

  static Future<dynamic> userProfile() async {
    try {
      final http.Response response = await http.get(
        BASE_URL + API.USER_PROFILE,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + Globals.userToken,
        },
      );

      // print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        return User.fromJson(result);
      } else {
        return "Erreur du serveur";
      }
    } catch (e) {
      return "Échec de la conversion";
    }
  }

  static Future<String> updateDeviceToken() async {
    if (Globals.deviceToken.isEmpty) {
      return "Identifiant de l'appareil non trouvé";
    }

    try {
      final http.Response response = await http.post(BASE_URL + API.USER_FCM,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + Globals.userToken,
          },
          body: jsonEncode(<String, dynamic>{
            'fcm_token': Globals.deviceToken,
          }));

      // print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        return "Success";
      } else {
        return "Échec";
      }
    } catch (e) {
      return "Échec";
    }
  }

  static Future<dynamic> uploadFile(File file) async {
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse(BASE_URL + API.UPLOAD));

      request.headers.addAll(<String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + Globals.userToken,
      });

      var photo = await http.MultipartFile.fromPath("file", file.path);
      request.files.add(photo);

      http.Response response =
          await http.Response.fromStream(await request.send());

      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        return result;
      } else {
        List<dynamic> errors = result["errors"] as List;
        if (errors != null && errors.length > 0) {
          return errors[0];
        } else {
          return "Échec de la connexion au serveur";
        }
      }
    } catch (e) {
      return "Échec de la conversion";
    }
  }

  static Future<String> becomeCustomer(
    String name,
    String firstline,
    String secondline,
    String code,
    String city,
    String country,
  ) async {
    try {
      final http.Response response =
          await http.post(BASE_URL + API.USER_CUSTOMER,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ' + Globals.userToken,
              },
              body: jsonEncode(<String, dynamic>{
                'name': name,
                'firstline': firstline,
                'secondline': secondline,
                'postcode': code,
                'city': city,
                'country': country,
              }));
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        Globals.currentUser.customer = result["uuid"] ?? "";
        return "Success";
      } else {
        List<dynamic> errors = result["errors"] as List;
        if (errors != null && errors.length > 0) {
          return errors[0];
        } else {
          return "Échec de la connexion au serveur";
        }
      }
    } catch (e) {
      return "Échec";
    }
  }

  static Future<dynamic> makePayment(
      double price, int page, String type) async {
    try {
      final http.Response response = await http.post(BASE_URL + API.MCQ_PAYMENT,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + Globals.userToken,
          },
          body: jsonEncode(<String, dynamic>{
            'price': price,
            'pages': page,
            'type': type,
            'customer': Globals.currentUser.customer
          }));
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        return result;
      } else {
        List<dynamic> errors = result["errors"] as List;
        if (errors != null && errors.length > 0) {
          return errors[0];
        } else {
          return "Échec de la connexion au serveur";
        }
      }
    } catch (e) {
      return "Échec";
    }
  }

  static Future<String> makeRequest(
      String type, List<String> files, String invoice) async {
    try {
      final http.Response response = await http.post(BASE_URL + API.MCQ_REQUEST,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + Globals.userToken,
          },
          body: jsonEncode(<String, dynamic>{
            'type': type,
            'files': files,
            'invoice': invoice
          }));
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);

      if (result["success"] == true) {
        return "Success";
      } else {
        List<dynamic> errors = result["errors"] as List;
        if (errors != null && errors.length > 0) {
          return errors[0];
        } else {
          return "Échec de la connexion au serveur";
        }
      }
    } catch (e) {
      return "Échec";
    }
  }
}
