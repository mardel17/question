import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question/model/question.dart';
import 'package:question/provider/home_provider.dart';
import 'package:question/utils/const.dart';
import 'package:question/widget/question_card.dart';

class QCMView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return FutureBuilder(
      future: provider.getMCQFromServer(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Question> mcqList = snapshot.data;
          return ListView.separated(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                Question question = mcqList[index];
                return QuestionCard(
                  question: question,
                  image: "images/award.png",
                  price: question.completion,
                  callback: () => Navigator.of(context)
                      .pushNamed(ROUTE.DETAIL, arguments: question.id),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 8),
              itemCount: mcqList.length);
        } else if (snapshot.hasError) {
          return snapshot.error;
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
