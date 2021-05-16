import 'dart:ffi';

import 'package:flutter/material.dart';

class MyDropdownMenuModel {
  String name;
  int value;
  MyDropdownMenuModel({required this.name, required this.value});
}

class MyDropdownMenu extends StatefulWidget {
  final int valueMenu;
  final List<MyDropdownMenuModel> listMenu;
  final Function(MyDropdownMenuModel item) change;
  MyDropdownMenu(
      {Key? key,
      required this.listMenu,
      this.valueMenu = 0,
      required this.change})
      : super(key: key);

  @override
  _MyDropdownMenuState createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  final double indicatorWidth = 24.0;
  final double indicatorHeight = 300.0;
  final double slideHeight = 200.0;
  final double slideWidth = 400.0;

  late OverlayEntry overlayEntry;
  GlobalKey _globalKey = GlobalKey();
  bool _openIcon = false;
  int _groupValue = 0;
  int _initSelect = 0;

  double _getOffsetY(BuildContext buildContext) {
    final RenderBox box = buildContext.findRenderObject() as RenderBox;
    // Offset(107.0, 100.0)
    final topLeftPosition = box.localToGlobal(Offset.zero);
    return topLeftPosition.dy;
  }

  /// 源文件方法 研究使用
  // Offset getIndicatorOffset(Offset dragOffset) {
  //   final double x = (dragOffset.dx - (indicatorWidth / 2.0))
  //       .clamp(0.0, slideWidth - indicatorWidth);
  //   final double y = (slideHeight - indicatorHeight) / 2.0;
  //   return Offset(x, y);
  // }

  bool showLock = false; // OverlayEntry 的锁 防止多层报错
  void showIndicator() {
    if (showLock == true) return;
    showLock = true;
    setState(() {
      _openIcon = true;
    });
    BuildContext buildContext = _globalKey.currentContext!;
    double y = _getOffsetY(buildContext) + buildContext.size!.height;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0,
          left: 0.0,
          right: 0.0,
          bottom: 0,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _menuList(y),
          ),
        );
      },
    );
    Overlay.of(context)?.insert(overlayEntry);
  }

  // 更新OverlayEntry
  void updateIndicator() {
    overlayEntry.markNeedsBuild();
  }

  void hideIndicator() {
    overlayEntry.remove();
    showLock = false;
    setState(() {
      _openIcon = false;
    });
  }

  void _onTap(int index, MyDropdownMenuModel item) {
    setState(() {
      _isUpdate = true;
      _initSelect = index; // 替换显示
    });
    _groupValue = item.value; // 替换选择状态
    updateIndicator();
    Future.delayed(new Duration(milliseconds: 200), () {
      hideIndicator();
      widget.change(item);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSelect = widget.listMenu
        .indexWhere((element) => element.value == widget.valueMenu);
    _groupValue = widget.valueMenu;
    // _listCopy = List.from(widget.listMenu);
  }

  @override
  void dispose() {
    overlayEntry.remove(); // 如果点击返回 父页面销毁 就删除 TODO!!! 最好监听返回键
    super.dispose();
  }

  bool _isUpdate = false;
  // List<MyDropdownMenuModel> _listCopy;

  @override
  Widget build(BuildContext context) {
    /// 出现 更新 数组越界
    // if(widget.listMenu.length < _initSelect){
    //   _initSelect = widget.listMenu
    //       .indexWhere((element) => element.value == widget.valueMenu);
    // }
    // if (_listCopy.length != widget.listMenu.length) {
    //   _isUpdate = false;
    // }
    MyDropdownMenuModel currentItem;
    // if (_isUpdate) {
    // currentItem = widget.listMenu[_initSelect];
    //   _groupValue =_initSelect;
    // } else {
    currentItem = widget.listMenu[widget.valueMenu];
    //   _groupValue = widget.valueMenu;
    // }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showIndicator();
      },
      child: Container(
        key: _globalKey,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentItem.name),
            _openIcon
                ? Icon(Icons.keyboard_arrow_up, size: 14.0, color: Colors.grey)
                : Icon(Icons.keyboard_arrow_down,
                    size: 14.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _menuList(double y) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            hideIndicator();
          },
          child: Container(
            height: y,
            color: Colors.transparent,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          // height: heightLevel,
          color: Colors.white,
          // child: FittedBox(),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: List<Widget>.generate(widget.listMenu.length, (gi) {
                  var item = widget.listMenu[gi];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTap(gi, item),
                    child: Container(
                      height: 50.0,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.name}',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          if (_groupValue == item.value)
                            Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              hideIndicator();
            },
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
        ),
      ],
    );
  }
}

// class MySortMenu extends StatefulWidget {
//   final String name;
//   final int valueSort;
//   final List<int> valueGroup;
//   final Function(int value) change;
//   MySortMenu({Key? key, required this.name, required this.valueSort, this.valueGroup, required this.change})
//       : assert(valueGroup.length == 2, "数组的长度只能等于2"),
//         super(key: key);
//
//   @override
//   _MySortMenuState createState() => _MySortMenuState();
// }
//
// class _MySortMenuState extends State<MySortMenu> {
//   void _onTap() {
//     if (_currentIndex == 0) {
//       _currentIndex = 1;
//     } else {
//       _currentIndex = 0;
//     }
//     setState(() {});
//     widget.change(widget.valueGroup[_currentIndex]);
//   }
//
//   int _currentIndex;
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex =
//         widget.valueGroup.indexWhere((element) => element == widget.valueSort);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: _onTap,
//       child: Container(
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('${widget.name}'),
//             _currentIndex == 0
//                 ? Icon(Icons.arrow_drop_down)
//                 : Icon(Icons.arrow_drop_up),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// https://segmentfault.com/a/1190000019902201
// class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
//   // final TabBar child;
//   final PreferredSize child; // 改造后，为了加TabBar的颜色
//
//   StickyTabBarDelegate({@required this.child});
//
//   /*
//   *
//    SliverPersistentHeader(
//       pinned: true,
//       delegate: StickyTabBarDelegate(
//         child: PreferredSize(
//           preferredSize: Size.fromHeight(40),
//           // child 内容高度不能小于 StickyTabBarDelegate高度 必须一致
//           child: Material(
//             color: Colors.white, // 这里设置tab的背景色
//             // elevation: 3,
//             child: _filterHeader(model),
//           ),
//         ),
//       ),
//     ),
//   * */
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return this.child;
//   }
//
//   /// child高度不能小于 delegate高度 必须一致
//   ///
//   @override
//   double get maxExtent => this.child.preferredSize.height;
//
//   @override
//   double get minExtent => this.child.preferredSize.height;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
