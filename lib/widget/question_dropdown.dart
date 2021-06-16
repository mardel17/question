import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question/provider/home_provider.dart';
import 'package:question/utils/const.dart';
import 'package:question/model/detail.dart';

class QuestionDropdown extends StatefulWidget {
  QuestionDropdown({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  _QuestionDropdownState createState() => _QuestionDropdownState();
}

class _QuestionDropdownState extends State<QuestionDropdown> {
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
                color: (provider.isValidate)
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
                padding: EdgeInsets.symmetric(horizontal: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton<String>(
                    underline: Container(),
                    value: _selected,
                    isExpanded: true,
                    items: widget.item.answers.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (context) {
                      return widget.item.answers.map((e) {
                        return Row(
                          children: [
                            SizedBox(width: 8),
                            Text(e),
                          ],
                        );
                      }).toList();
                    },
                    onChanged: (value) {
                      setState(() {
                        _selected = value;
                      });
                    }),
              ),
              (widget.item.explanation.isNotEmpty && provider.isValidate)
                  ? Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      color: provider.isValidate ? _getColor() : Colors.grey,
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
