/*
  * 输入
  * */
import 'package:flutter/material.dart';
import 'package:gtarcade/constants/iconfont.dart';
import 'package:gtarcade/root/theme/AppTheme.dart';

Widget input(
    {String label,
    TextEditingController controller,
    TextInputType keyboardType,
    bool password}) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      print(label);
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: TextField(
          controller: controller,
          obscureText: password == null ? false : password, // 隐藏密码
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            labelText: label,
            suffixIcon: controller.text == ''
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (password != null)
                        IconButton(
                          icon: password
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.remove_red_eye_outlined),
                          onPressed: () {
                            setState(() {
                              password = !password;
                            });
                          },
                        ),
                      IconButton(
                        icon: Icon(IconFont.xmark),
                        onPressed: () {
                          setState(() {
                            controller.value = TextEditingValue(text: '');
                          });
                        },
                      ),
                    ],
                  ),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5), // 边框颜色
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.colorPrimary,
              ),
            ),
          ),
          keyboardType: keyboardType ?? TextInputType.text, //键盘类型
          textInputAction: TextInputAction.next, //为next时，enter键显示的文字内容为 下一步
          textCapitalization: TextCapitalization.words, //none 默认使用小写
          style: TextStyle(fontSize: 16.0), //输入文本的样式
          onChanged: (text) {
            setState(() {});
          },
          onSubmitted: (text) {},
        ),
      );
    },
  );
}

Widget submit({Function onPressed, String title}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(title, style: TextStyle(color: AppTheme.colorPrimary2)),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      backgroundColor: AppTheme.colorPrimary,
    ),
  );
}
