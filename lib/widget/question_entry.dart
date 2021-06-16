import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question/provider/home_provider.dart';
import 'package:question/utils/const.dart';
import 'package:question/model/detail.dart';

class QuestionEntry extends StatefulWidget {
  QuestionEntry({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  _QuestionDropdownState createState() => _QuestionDropdownState();
}

class _QuestionDropdownState extends State<QuestionEntry> {
  final teController = TextEditingController();
  bool isVerify = false;

  Color _getColor() {
    String myAnswer = teController.text.trim();
    String existAnswer = widget.item.corrects
        .firstWhere((element) => myAnswer == element, orElse: () => null);

    if (existAnswer == null) {
      return COLOR.RED;
    } else {
      return COLOR.GREEN;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    if (provider.isValidate) {
      setState(() {
        isVerify = true;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: COLOR.GRAY, width: 0.5),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                color: isVerify
                    ? Color.fromRGBO(232, 240, 254, 1.0)
                    : Color.fromRGBO(0, 0, 0, 0.03),
                child: Text(
                  widget.item.question,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(
                color: COLOR.GRAY,
                thickness: 0.5,
                height: 0.5,
              ),
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey)),
                child: TextField(
                  controller: teController,
                  decoration: InputDecoration(
                    hintText: "Votre réponse",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              (widget.item.explanation.isNotEmpty && provider.isValidate)
                  ? Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      color: isVerify ? _getColor() : Colors.grey,
                      child: Text(
                        widget.item.explanation,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
