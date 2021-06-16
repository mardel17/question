import 'package:flutter/material.dart';
import 'package:question/model/question.dart';

typedef void VoidCallback();

class QuestionCard extends StatelessWidget {
  QuestionCard(
      {Key key,
      @required this.question,
      @required this.image,
      this.price,
      this.callback})
      : super(key: key);

  final Question question;
  final String image;
  final String price;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    question.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Image.asset(image)
                ],
              ),
              SizedBox(height: 8),
              Text(question.description),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("images/arrow-return-right.png"),
                  Text(
                    price ?? "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
