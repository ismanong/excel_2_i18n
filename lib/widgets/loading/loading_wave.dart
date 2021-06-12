import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;
enum SpinKitWaveType { start, end, center }

class SpinKitWave extends StatefulWidget {
  SpinKitWave({
    Key key,
    this.color,
    this.type = SpinKitWaveType.start,
    this.size = 100.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(type != null),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final SpinKitWaveType type;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;

  @override
  _SpinKitWaveState createState() => _SpinKitWaveState();
}

class _SpinKitWaveState extends State<SpinKitWave>
    with SingleTickerProviderStateMixin {
  AnimationController _scaleCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _bars;
    if (widget.type == SpinKitWaveType.start) {
      _bars = [
        _bar(0, -1.2),
        _bar(1, -1.1),
        _bar(2, -1.0),
        _bar(3, -.9),
//        _bar(4, -.8),
      ];
    } else if (widget.type == SpinKitWaveType.end) {
      _bars = [
        _bar(0, -.8),
        _bar(1, -.9),
        _bar(2, -1.0),
        _bar(3, -1.1),
        _bar(4, -1.2),
      ];
    } else if (widget.type == SpinKitWaveType.center) {
      _bars = [
//        _bar(0, -0.75),
//        _bar(1, -0.95),
//        _bar(2, -1.2),
//        _bar(3, -0.95),
//        _bar(4, -0.75),
        _bar(0, -0.75),
        _bar(1, -0.95),
        _bar(2, -0.95),
        _bar(3, -0.75),
      ];
    }
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 0.5, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _bars,
        ),
      ),
    );
  }

  Widget _bar(int index, double delay) {
    final _size = widget.size * 0.25 * 0.5;
    return ScaleYWidget(
      scaleY: DelayTween(
        begin: .4,
        end: 1.0,
        delay: delay,
      ).animate(_scaleCtrl),
      child: SizedBox.fromSize(
        size: Size(_size, widget.size),
        child: _itemBuilder(index),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    String str = '';
    if(index==0){
      str = 'l';
    }else if(index==1){
      str = 'i';
    }else if(index==2){
      str = 'i';
    }else if(index==3){
      str = 'l';
    }
    return widget.itemBuilder != null
        ? widget.itemBuilder(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
            ),
            child: Text('$str',style: TextStyle(fontSize: 50.0,color: Colors.grey)),
          );
  }
}

class ScaleYWidget extends AnimatedWidget {
  const ScaleYWidget({
    Key key,
    @required Animation<double> scaleY,
    @required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key, listenable: scaleY);

  final Widget child;
  final Alignment alignment;

  Animation<double> get scaleY => listenable;

  @override
  Widget build(BuildContext context) {
    final double scaleValue = scaleY.value;
    final Matrix4 transform = Matrix4.identity()..scale(1.0, scaleValue, 1.0);
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}


class DelayTween extends Tween<double> {
  DelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
