import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtarcade/constants/ImagePaths.dart';
import 'package:gtarcade/generated/l10n.dart';
import 'package:gtarcade/widget/modules/demo/DemoPageLoad.dart';
import 'package:gtarcade/widget/modules/serviceAgreement_privacyPolicy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../BasicsDialog.dart';

class DemoIndex extends StatefulWidget {
  @override
  _DemoIndexState createState() => _DemoIndexState();
}

class _DemoIndexState extends State<DemoIndex> {
  void _showDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '删除相册',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '此操作将永久删除该相册和相册的图片, 是否继续?',
                  style: TextStyle(fontSize: 14.0, height: 2),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('继续删除'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: Theme.of(context).primaryColor,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('稍后再说'),
              style: OutlinedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                primary: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialogActive() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0),
        backgroundColor: Colors.transparent,
        elevation: 0.0, // 阴影
        content: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            child: ListBody(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset(
                          ImagePaths.logo_logo,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Positioned(
                      right: 10.0,
                      top: 10.0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App全局通用功能'),
        ),
        body: ListView(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DemoPageLoad()),
                );
              },
              child: Text('页面加载'),
            ),
            ElevatedButton(
              // onPressed: () {},
              child: Text('空页面-骨架屏'),
            ),
            ElevatedButton(
              onPressed: () {
                PopupServiceAgreementPrivacyPolicy.isOpened = false; // 重置开关
                PopupServiceAgreementPrivacyPolicy.popup(context);
              },
              child: Text('内容弹窗'),
            ),
            ElevatedButton(
              onPressed: () {
                // showCupertinoModalBottomSheet
                // showBarModalBottomSheet
                showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) => Modal(),
                );
              },
              child: Text('发表回复弹窗'),
            ),
            ElevatedButton(
              onPressed: () {
                showBarModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black38,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  builder: (BuildContext context) => Modal(),
                );
              },
              child: Text('发表回复弹窗2'),
            ),
            ElevatedButton(
              // onPressed: () {},
              child: Text('更多操作弹窗'),
            ),
            ElevatedButton(
              onPressed: () {
                BasicsDialog.confirm(
                  context,
                  title: S.current.common_notice,
                  content: S.current.post_send_edit_save_draft,
                );
              },
              child: Text('提醒弹窗'),
            ),
            ElevatedButton(
              onPressed: () {
                _showDialogActive();
              },
              child: Text('获取积分弹窗'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String label) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        // controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          labelText: label,
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5), // 边框颜色
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        keyboardType: TextInputType.text, //键盘类型
        textInputAction: TextInputAction.next, //为next时，enter键显示的文字内容为 下一步
        textCapitalization: TextCapitalization.words, //none 默认使用小写
        style: TextStyle(fontSize: 16.0), //输入文本的样式
      ),
    );
  }
}

class Modal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: Duration(milliseconds: 250),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'title',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'escribe aquí'),
                  autofocus: true,
                ),
                FlatButton(
                  color: Colors.green,
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  color: Colors.red,
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
