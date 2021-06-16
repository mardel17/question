import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/util.dart';
import 'package:question/widget/entry_column.dart';
import 'package:question/widget/submit_button.dart';

import 'package:question/utils/globals.dart' as Globals;

class SignupPage extends StatelessWidget {
  final teUsername = TextEditingController();
  final teEmail = TextEditingController();
  final tePassword = TextEditingController();
  final teCPassword = TextEditingController();

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
                    "S'inscrire sur Questionne moi",
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
                    title: "Votre adresse email",
                    hint: "Votre adresse email",
                    teController: teEmail,
                  ),
                  SizedBox(height: 16),
                  EntryColumn(
                    title: "Mot de passe",
                    hint: "Mot de passe",
                    teController: tePassword,
                    isPassword: true,
                  ),
                  SizedBox(height: 16),
                  EntryColumn(
                    title: "Confirmez votre mot de passe",
                    hint: "Confirmez votre mot de passe",
                    teController: teCPassword,
                    isPassword: true,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 160,
                    child: SubmitButton(
                      title: "S'inscrire",
                      callback: () {
                        signup(context);
                      },
                    ),
                  ),
                  Divider(
                    color: COLOR.GRAY.withOpacity(0.2),
                    thickness: 0.5,
                    height: 32,
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed(ROUTE.LOGIN),
                    child: Text(
                      "Vous avez un compte ? Se connecter !",
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

  Future signup(BuildContext context) async {
    FocusScope.of(context).unfocus();

    String username = teUsername.text.trim();
    String email = teEmail.text.trim();
    String password = tePassword.text;
    String cpassword = teCPassword.text;

    if (username.isEmpty) {
      showToast(context, "Veuillez saisir votre nom d'utilisateur");
      return;
    }

    if (!isValidEmail(email)) {
      showToast(context, "Veuillez saisir une adresse email valide");
      return;
    }

    if (password.isEmpty) {
      showToast(context, "Veuillez saisir votre mot de passe");
      return;
    }

    if (password != cpassword) {
      showToast(context, "Le mot de passe ne correspond pas");
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    String result = await Util.signup(username, email, password);
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

      Navigator.of(context).pushReplacementNamed(ROUTE.HOME);
    } else {
      showToast(context, result);
    }
  }
}
