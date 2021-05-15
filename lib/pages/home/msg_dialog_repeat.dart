import 'package:flutter/material.dart';

void msgDialogRepeat(context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0),
        // backgroundColor: Colors.transparent,
        elevation: 0.0, // 阴影
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('警告：'),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                height: 160.0,
                child: Text('$msg', style: TextStyle(fontSize: 14.0)),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}
