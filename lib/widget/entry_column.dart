import 'package:flutter/material.dart';
import 'package:question/utils/const.dart';

class EntryColumn extends StatelessWidget {
  EntryColumn({
    Key key,
    this.title,
    this.hint,
    this.teController,
    this.isPassword,
  }) : super(key: key);

  final String title, hint;
  final TextEditingController teController;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
          decoration: BoxDecoration(
              color: Color.fromRGBO(232, 240, 254, 1.0),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: COLOR.GRAY, width: 0.5)),
          child: TextField(
            controller: teController,
            obscureText: isPassword ?? false,
            style: TextStyle(
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint ?? "",
              hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.grey.withOpacity(0.6),
              ),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      ],
    );
  }
}
