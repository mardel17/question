import 'package:flutter/material.dart';
import 'package:question/utils/const.dart';

typedef void VoidCallback();

class SubmitBorder extends StatelessWidget {
  SubmitBorder(
      {Key key,
      @required this.title,
      this.textColor,
      this.backgroundColor,
      this.borderColor,
      this.callback})
      : super(key: key);

  final String title;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
            )),
        child: Text(title,
            style: TextStyle(fontSize: 18, color: textColor ?? Colors.white)),
      ),
    );
  }
}
