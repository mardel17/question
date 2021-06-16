import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/globals.dart' as Globals;
import 'package:question/view/profile_page.dart';

typedef void VoidCallback();

class AppHeader extends StatelessWidget {
  AppHeader({Key key, @required this.needHome, this.callback})
      : super(key: key);

  final bool needHome;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/wave.png",
          color: COLOR.BLUE,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              needHome
                  ? InkWell(
                      onTap: () {
                        if (callback != null) {
                          callback();
                        }
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        "images/house.png",
                        color: COLOR.YELLOW,
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          ProfilePage(),
                    ),
                  );
                },
                child: (Globals.currentUser != null &&
                        Globals.currentUser.avatar.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: Globals.currentUser.avatar,
                        imageBuilder: (context, imageProvider) => Container(
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
