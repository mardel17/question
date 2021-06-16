import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:question/model/detail.dart';
import 'package:question/provider/home_provider.dart';
import 'package:question/widget/app_header.dart';
import 'package:question/widget/audio_play.dart';
import 'package:question/widget/question_dropdown.dart';
import 'package:question/widget/question_entry.dart';
import 'package:question/widget/submit_button.dart';
import 'package:question/widget/question_check.dart';
import 'package:question/widget/question_radio.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key key, @required this.id}) : super(key: key);

  final String id;
  final GlobalKey<AudioPlayState> _playerState = GlobalKey<AudioPlayState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              needHome: true,
              callback: () {
                _playerState.currentState?.stopPlayer();
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: provider.getDetailFromServer(id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Detail detail = snapshot.data;

                    return Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Text(
                            detail.description,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: (detail.type == "asmr")
                                ? (detail.attachment.isEmpty)
                                    ? Container()
                                    : AudioPlay(
                                        key: _playerState,
                                        path: detail.attachment,
                                      )
                                : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              Item item = detail.items[index];
                                              switch (item.type) {
                                                case "checkboxes":
                                                  return QuestionCheck(
                                                      item: item);
                                                  break;
                                                case "radio":
                                                  return QuestionRadio(
                                                      item: item);
                                                  break;
                                                case "select":
                                                  return QuestionDropdown(
                                                      item: item);
                                                  break;

                                                default:
                                                  return QuestionEntry(
                                                      item: item);
                                                  break;
                                              }
                                            },
                                            separatorBuilder: (_, __) =>
                                                SizedBox(height: 24),
                                            itemCount: detail.items.length),
                                        SizedBox(height: 24),
                                        SizedBox(
                                          width: 100,
                                          child: SubmitButton(
                                            title: "Vérifions",
                                            callback: () {
                                              provider.isValidate = true;
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                      ],
                                    ),
                                  ),

                            // SingleChildScrollView(
                            //   child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             QuestionCheck(
                            //               item: detail.items[0],
                            //               status: 0,
                            //               callback: (values) {},
                            //             ),
                            //             SizedBox(height: 24),
                            //             QuestionRadio(
                            //               item: detail.items[1],
                            //               status: 0,
                            //               callback: (value) {},
                            //             ),
                            //             SizedBox(height: 24),
                            //             QuestionDropdown(
                            //                 item: detail.items[2], status: 0),
                            //             SizedBox(height: 24),
                            //             QuestionEntry(
                            //                 item: detail.items[2],
                            //                 status: 0,
                            //                 teController: teAnswer),
                            //             SizedBox(height: 16),
                            //             SizedBox(
                            //               width: 100,
                            //               child: SubmitButton(
                            //                 title: "Vérifions",
                            //                 callback: () {},
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            // ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return snapshot.error;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
