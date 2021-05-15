import 'package:flutter/material.dart';

import 'home/PageHome.dart';
import 'home2/PageHome2.dart';

/// 主页

class AppMainPage extends StatefulWidget {
  AppMainPage({Key? key}) : super(key: key);

  @override
  _AppMainPageState createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  List<List> _pages = [
    [PageHome(), '转json、arb', Icons.home_outlined, Icons.home],
    [PageHome2(), '转excel', Icons.home_outlined, Icons.home],
  ];

  int _currentIndex = 1;
  late PageController _controller;

  void _pageChange(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onTap(int index) {
    _controller.jumpToPage(index);
  }

  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(), //viewPage禁止左右滑动
        onPageChanged: _pageChange,
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (context, index) => _pages[index][0],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        type: BottomNavigationBarType.fixed, // 导航栏项目超过3个 类型会发生变化 会变白 则设置
        currentIndex: _currentIndex,
        // fixedColor: AppTheme.colorPrimary,
        onTap: _onTap,
        items: _listBottomNavigationBarItem(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: _floatingActionButton(),
    );
  }

  List<BottomNavigationBarItem> _listBottomNavigationBarItem() {
    return _pages
        .map((List item) => BottomNavigationBarItem(
              label: item[1],
              icon: Icon(item[2], size: 20.0),
              activeIcon: Icon(item[3], size: 20.0),
            ))
        .toList();
  }

  // Widget _floatingActionButton() {
  //   return _noticeStr == ''
  //       ? SizedBox()
  //       : Container(
  //           color: AppTheme.colorPrimary3,
  //           margin: EdgeInsets.only(bottom: 30),
  //           width: MediaQuery.of(context).size.width,
  //           height: 30.0,
  //           child: Row(
  //             children: <Widget>[
  //               Expanded(
  //                 child: Marquee(
  //                   text: '$_noticeStr',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black,
  //                   ),
  //                   scrollAxis: Axis.horizontal,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   blankSpace: 20.0,
  //                   velocity: 100.0,
  //                   pauseAfterRound: Duration(seconds: 1),
  //                   startPadding: 10.0,
  //                   accelerationDuration: Duration(seconds: 1),
  //                   accelerationCurve: Curves.linear,
  //                   decelerationDuration: Duration(milliseconds: 500),
  //                   decelerationCurve: Curves.easeOut,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 30.0,
  //                 child: IconButton(
  //                   padding: EdgeInsets.all(0),
  //                   icon: Icon(
  //                     Icons.close_outlined,
  //                     color: Colors.grey,
  //                     size: 20.0,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       _noticeStr = '';
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  // }
}
