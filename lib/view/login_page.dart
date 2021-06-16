import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/util.dart';
import 'package:question/widget/entry_column.dart';
import 'package:question/widget/submit_button.dart';

import 'package:question/utils/globals.dart' as Globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final teUsername = TextEditingController();
  final tePassword = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((prefs) {
        String username = prefs.getString(KEY.SAVED_USER_NAME);
        String password = prefs.getString(KEY.SAVED_USER_PASSWORD);
        if (username != null && password != null) {
          teUsername.text = username;
          tePassword.text = password;
          login();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "images/wave.png",
              color: COLOR.BLUE,
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Column(
                children: [
                  Text(
                    "Se connecter sur Questionne moi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 48),
                  EntryColumn(
                    title: "Nom d'utilisateur",
                    hint: "Nom d'utilisateur",
                    teController: teUsername,
                  ),
                  SizedBox(height: 16),
                  EntryColumn(
                    title: "Mot de passe",
                    hint: "Mot de passe",
                    teController: tePassword,
                    isPassword: true,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 160,
                    child: SubmitButton(
                      title: "Se connecter",
                      callback: () {
                        login();
                      },
                    ),
                  ),
                  SizedBox(height: 32),
                  InkWell(
                    // onTap: () =>
                    //     Navigator.of(context).popAndPushNamed(ROUTE.HOME),
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                        color: COLOR.BLUE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Divider(
                    color: COLOR.GRAY.withOpacity(0.2),
                    thickness: 0.5,
                    height: 32,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(ROUTE.SIGNUP),
                    child: Text(
                      "Pas encore de compte ? Corrigons cela !",
                      style: TextStyle(
                        color: COLOR.BLUE,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future login() async {
    FocusScope.of(context).unfocus();

    String username = teUsername.text.trim();
    String password = tePassword.text;

    if (username.isEmpty) {
      showToast(context, "Veuillez saisir votre nom d'utilisateur");
      return;
    }

    if (password.isEmpty) {
      showToast(context, "Veuillez saisir votre mot de passe");
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    String result = await Util.login(username, password);
    await progress.hide();

    if (result == "Success") {
      await progress.show();
      dynamic result = await Util.userProfile();
      await progress.hide();

      if (result is String) {
        //Error
        showToast(context, result);
      } else {
        Globals.currentUser = result;
      }

      await progress.show();
      await Util.updateDeviceToken();
      await progress.hide();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(KEY.SAVED_USER_NAME, username);
      prefs.setString(KEY.SAVED_USER_PASSWORD, password);

      Navigator.of(context).pushReplacementNamed(ROUTE.HOME);
    } else {
      showToast(context, result);
    }
  }
}
