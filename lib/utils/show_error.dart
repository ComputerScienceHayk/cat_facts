import 'package:cat_facts/res/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showError(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: black.withOpacity(0.7),
    textColor: white,
    webShowClose: true,
    fontSize: 18.0,
  );
}