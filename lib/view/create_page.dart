import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:question/utils/const.dart';
import 'package:question/utils/util.dart';
import 'package:question/utils/globals.dart' as Globals;
import 'package:question/widget/app_header.dart';
import 'package:question/widget/submit_border.dart';
import 'package:question/widget/submit_button.dart';
import 'package:question/widget/submit_column.dart';

class CreatePage extends StatefulWidget {
  CreatePage({Key key, @required this.isQCM}) : super(key: key);

  final bool isQCM;
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isQCM;
  File _imageFile;
  final picker = ImagePicker();
  List<Map<String, dynamic>> uploads = [];

  @override
  void initState() {
    super.initState();
    isQCM = widget.isQCM;
  }

  Future showImagePicker() async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: 600, maxHeight: 600);

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          savePhoto(_imageFile);
        } else {
          print('No image selected.');
          savePhoto(_imageFile);
        }
      });
    } catch (e) {}

    retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null && response.type == RetrieveType.image) {
      setState(() {
        _imageFile = File(response.file.path);
      });
    }
  }

  void savePhoto(File file) async {
    if (file == null) {
      return;
    }

    final ProgressDialog progress =
        ProgressDialog(context, isDismissible: false);
    progress.style(message: "Veuillez patienter ...");

    await progress.show();
    dynamic result = await Util.uploadFile(file);
    await progress.hide();

    if (result is Map) {
      setState(() {
        uploads.add(result);
        _imageFile = null;
      });
    } else {
      showToast(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(needHome: true),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      "Nouveau",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          child: SubmitColumn(
                            title: "QCM",
                            image: "images/list-check.png",
                            color:
                                (isQCM) ? COLOR.CLOUD_DARK : COLOR.CLOUD_LIGHT,
                            callback: () {
                              setState(() {
                                isQCM = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: SubmitColumn(
                            title: "Dodo studieux",
                            image: "images/soundwave.png",
                            color:
                                (!isQCM) ? COLOR.CLOUD_DARK : COLOR.CLOUD_LIGHT,
                            callback: () {
                              setState(() {
                                isQCM = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    (uploads.length > 0)
                        ? Flexible(
                            child: GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.8,
                              children: uploads
                                  .map((e) => CachedNetworkImage(
                                        imageUrl: e["file"],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            ClipOval(
                                          child: Image.asset(
                                            "images/avatar.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        : SizedBox(height: 16),
                    SubmitBorder(
                      title: "Prendre en photo",
                      textColor: COLOR.YELLOW,
                      borderColor: COLOR.YELLOW,
                      callback: showImagePicker,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 220,
                      child: SubmitButton(
                        title:
                            isQCM ? "Créer un QCM" : "Créer un dodo studieux",
                        callback: () {
                          if (uploads.length > 0) {
                            Map<String, dynamic> data = {
                              "type": isQCM ? "mcq" : "asmr",
                              "uploads": uploads,
                            };
                            if (Globals.currentUser.customer.isEmpty) {
                              Navigator.of(context)
                                  .pushNamed(ROUTE.BILLING, arguments: data);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(ROUTE.PAYMENT, arguments: data);
                            }
                          } else {
                            print("not found pages");
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: COLOR.GRAY.withOpacity(0.2),
              thickness: 0.5,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${uploads.length} Page(s)",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        isQCM ? "QCM" : "Dodo studieux",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    "${uploads.length * 0.99} €",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
