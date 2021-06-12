import 'package:flutter/material.dart';
import 'package:gtarcade/generated/l10n.dart';
import 'package:gtarcade/root/theme/AppTheme.dart';

class BasicsDialog {
  static Future<bool> confirm(BuildContext context,
      {Function onPressed, String title, String content}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, //禁止点击遮罩关闭
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 14.0, height: 2),
                  ),
                ),
                SizedBox(height: 25.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(S.current.common_cancel),
                        style: OutlinedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                          ),
                          primary: Theme.of(context).primaryColor,
                          side:
                          BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(S.current.common_ok),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          primary: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: <Widget>[],
        );
      },
    );
  }
}
