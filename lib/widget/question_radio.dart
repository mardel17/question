import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question/provider/home_provider.dart';
import 'package:question/utils/const.dart';
import 'package:question/model/detail.dart';

class QuestionRadio extends StatefulWidget {
  QuestionRadio({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  _QuestionRadioState createState() => _QuestionRadioState();
}

class _QuestionRadioState extends State<QuestionRadio> {
  String _selected;

  Color _getColor() {
    String existAnswer = widget.item.corrects
        .firstWhere((element) => _selected == element, orElse: () => null);

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
                color: provider.isValidate
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
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: widget.item.answers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Theme(
                          data: ThemeData(
                            unselectedWidgetColor: (provider.isValidate)
                                ? _getColor()
                                : COLOR.GRAY,
                          ),
                          child: Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: widget.item.answers[index],
                            groupValue: _selected,
                            onChanged: (value) {
                              setState(() {
                                _selected = value;
                              });
                            },
                            activeColor: (provider.isValidate)
                                ? _getColor()
                                : COLOR.BLUE,
                          )),
                      Text(
                        widget.item.answers[index],
                        style: TextStyle(
                            fontSize: 16,
                            color: (provider.isValidate)
                                ? _getColor()
                                : COLOR.GRAY_DARK),
                      )
                    ],
                  );
                },
              ),
              (widget.item.explanation.isNotEmpty && provider.isValidate)
                  ? Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      color: (provider.isValidate) ? _getColor() : Colors.grey,
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
