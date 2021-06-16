import 'package:flutter/material.dart';
import 'package:question/utils/const.dart';

typedef void VoidCallback();

class SubmitButton extends StatelessWidget {
  SubmitButton({Key key, this.title, this.color, this.callback})
      : super(key: key);

  final String title;
  final Color color;
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
          color: color ?? COLOR.BLUE,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
