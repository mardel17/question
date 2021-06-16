import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String BASE_URL = "Your server url";

class KEY {
  static const String SAVED_USER_NAME = "saved_user_name";
  static const String SAVED_USER_PASSWORD = "saved_user_password";
}

class API {
  static const String RESULT = "result";
  static const String DATA = "data";
  static const String MESSAGE = "message";

  static const String USER_LOGIN = "user/login";
  static const String USER_REGISTER = "user/register";
  static const String USER_FCM = "user/fcm";
  static const String USER_PROFILE = "user/me";
  static const String USER_CUSTOMER = "user/customer";

  static const String UPLOAD = "upload";

  static const String MCQ_PAYMENT = "mcq/payment-request";
  static const String MCQ_REQUEST = "mcq/request";
  static const String MCQ_TYPE = "mcq?type=";
  static const String MCQ_DETAIL = "mcq/";
}

class ROUTE {
  static const String LOGIN = "/login";
  static const String SIGNUP = "/signup";
  static const String HOME = "/home";
  static const String CREATE = "/create";
  static const String BILLING = "/billing";
  static const String PAYMENT = "/payment";
  static const String DETAIL = "/detail";
}

class COLOR {
  static const Color BLUE = Color(0xff007BFF);
  static const Color CYAN = Color(0xff17a2b8);
  static const Color ORANGE = Color(0xfffd7e14);
  static const Color YELLOW = Color(0xffffc107);
  static const Color GRAY = Color(0xff6c757d);
  static const Color GRAY_DARK = Color(0xff343a40);
  static const Color PINK = Color(0xffe83e8c);
  static const Color RED = Color(0xffdc3545);
  static const Color GREEN = Color(0xff28a745);
  static const Color TEAL = Color(0xff20C997);
  static const Color GREEN_DARK = Color(0xff26896f);
  static const Color CLOUD_DARK = Color(0xffdae0e5);
  static const Color CLOUD_LIGHT = Color(0xfff8f9fa);
}

bool isValidEmail(String email) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  return emailValid;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

showAlertDialog(BuildContext context, String title, String description) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showToast(BuildContext context, String message) {
  FlutterToast flutterToast = FlutterToast(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white70,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Flexible(child: Text(message)),
      ],
    ),
  );

  flutterToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}
