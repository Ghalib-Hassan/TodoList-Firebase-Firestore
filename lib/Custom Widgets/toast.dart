import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_firestore/Utils/colors.dart';

class ToastPopUp {
  void toast(message, bgColor, txtColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: txtColor,
      fontSize: 18.0,
    );
  }
}

class ToastPopUpTwo {
  toast(message, bgColor) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: white,
      fontSize: 18.0,
    );
  }
}
