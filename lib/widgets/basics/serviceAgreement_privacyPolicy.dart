import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gtarcade/generated/l10n.dart';
import 'package:gtarcade/global/Global.dart';
import 'package:gtarcade/root/route/NavigatorUtils.dart';
import 'package:gtarcade/view/webview/common_webview.dart';

class PopupServiceAgreementPrivacyPolicy {
  static bool isOpened = false; // 是否打开过
  static void popup(context) {
    if (isOpened) {
      return;
    } else {
      isOpened = true;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0),
        backgroundColor: Colors.white,
        elevation: 0.0, // 阴影
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(S.current.home_service_privacy, style: TextStyle(fontSize: 18.0)),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                child: RichText(
                  text: TextSpan(
                    text: S.current.home_service_privacy_desc,
                    style: TextStyle(color: Colors.black87, fontSize: 14.0),
                    children: <TextSpan>[
                      TextSpan(text: '\n${S.current.home_you_can_read}'),
                      TextSpan(
                        text: '《${S.current.login_user_agreement}》',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            //这里做点击事件
                            NavigatorUtils.getInstance().commPush(
                              (context) => CommonWebViewPage(
                                url: Global.protocalUrl,
                                title: S.current.login_user_agreement,
                              ),
                            );
                          },
                      ),
                      TextSpan(text: S.current.login_and),
                      TextSpan(
                        text: '《${S.current.login_privacy_policy}》',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            //这里做点击事件
                            NavigatorUtils.getInstance().commPush(
                              (context) => CommonWebViewPage(
                                url: Global.privacyUrl,
                                title: S.current.login_privacy_policy,
                              ),
                            );
                          },
                      ),
                      TextSpan(text: S.current.home_service_privacy_desc2),
                      TextSpan(
                        text: '\n\n${S.current.home_service_privacy_desc3}',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.0, color: Colors.grey[200]),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.grey,
                      child: Text(S.current.home_service_privacy_not_use),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    height: 20.0,
                    color: Colors.grey[200],
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(S.current.home_service_privacy_agree),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
