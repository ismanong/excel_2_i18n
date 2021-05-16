import 'dart:ui';
import 'package:flutter/material.dart';

class BlurRectWidget extends StatelessWidget {
  final Widget widget;
  final double padding;

  BlurRectWidget(this.widget, {this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),
          child: Container(
            color: Colors.white10,
            padding: EdgeInsets.all(padding),
            child: widget,
          ),
        ),
      ),
    );
  }
}

class BlurOvalWidget extends StatelessWidget {
  final Widget widget;
  final double padding;

  BlurOvalWidget(this.widget, {this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          color: Colors.white10,
          padding: EdgeInsets.all(padding),
          child: widget,
        ),
      ),
    );
  }
}

/*
*
Stack(
  children: <Widget>[
    Image.network(
      'https://photo.tuchong.com/3019649/f/302699092.jpg',
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: 124.0,
    ),
    Positioned.fill(
      child: ClipRect(
        ///如果你不用ClipRect设置他大小的话，BackdropFilter组件将是全屏的
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.transparent, //颜色必须设置 透明
          ),
        ),
      ),
    ),
  ],
),
* */