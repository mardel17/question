import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/globals.dart' as Globals;
import 'package:question/widget/entry_column.dart';
import 'package:question/widget/submit_button.dart';

class ProfilePage extends StatelessWidget {
  final teEmail = TextEditingController();
  final teCurrent = TextEditingController();
  final tePassword = TextEditingController();
  final teCPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: SafeArea(
        child: Column(children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(height: 78),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      (Globals.currentUser != null &&
                              Globals.currentUser.avatar.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: Globals.currentUser.avatar,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                "images/avatar.png",
                                width: 60,
                              ),
                            )
                          : Image.asset(
                              "images/avatar.png",
                              width: 60,
                            ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (Globals.currentUser != null)
                                  ? Globals.currentUser.username ?? ""
                                  : "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove(KEY.SAVED_USER_NAME);
                                prefs.remove(KEY.SAVED_USER_PASSWORD);

                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.of(context)
                                    .popAndPushNamed(ROUTE.LOGIN);
                              },
                              child: Text(
                                "Déconnexion",
                                style: TextStyle(
                                    color: COLOR.RED,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: COLOR.GRAY.withOpacity(0.2),
                    thickness: 0.5,
                    height: 32,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EntryColumn(
                            title: "Adresse email",
                            hint: (Globals.currentUser != null)
                                ? Globals.currentUser.email ?? ""
                                : "",
                            teController: teEmail,
                          ),
                          SizedBox(height: 2),
                          Text(
                              "Votre adresse email est uniquement utilisée pour vous envoyer les informations importantes de votre compte."),
                          Divider(
                            color: COLOR.GRAY.withOpacity(0.2),
                            thickness: 0.5,
                            height: 32,
                          ),
                          Text(
                            "Changer de mot de passe",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          EntryColumn(
                            title: "Mot de passe actuel",
                            hint: "Mot de passe actuel",
                            isPassword: true,
                            teController: teCurrent,
                          ),
                          SizedBox(height: 16),
                          EntryColumn(
                            title: "Nouveau mot de passe",
                            hint: "Nouveau mot de passe",
                            isPassword: true,
                            teController: tePassword,
                          ),
                          SizedBox(height: 16),
                          EntryColumn(
                            title: "Confirmez votre mot de passe",
                            hint: "Confirmez votre mot de passe",
                            isPassword: true,
                            teController: teCPassword,
                          ),
                          Divider(
                            color: COLOR.GRAY.withOpacity(0.2),
                            thickness: 0.5,
                            height: 32,
                          ),
                          Center(
                            child: Container(
                              width: 160,
                              child: SubmitButton(
                                title: "Mettre à jour",
                                callback: () {},
                              ),
                            ),
                          ),
                          Divider(
                            color: COLOR.GRAY.withOpacity(0.2),
                            thickness: 0.5,
                            height: 32,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Pour activer l'authentification à double facteur, modifiez votre nom d'utilisateur ou votre avatar, rendez-vous sur user.stail.eu.",
                              style: TextStyle(color: COLOR.BLUE),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
