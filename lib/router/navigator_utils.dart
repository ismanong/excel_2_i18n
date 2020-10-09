import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'root_container.dart';

class NavigatorUtils extends NavigatorObserver {
  static final String sName = "NavigatorUtils";

  /*配置routes*/
  static Map<String, WidgetBuilder> configRoutes = {
    '/': (context) => RootContainer(),
  };

  static NavigatorUtils navigatorUtils;
  static NavigatorState currentNavigator;
  BuildContext mContext;
  static List<Route> _mRoutes;

  Route get currentRoute => _mRoutes[_mRoutes.length - 1];

  List<Route> get routes => _mRoutes;
  static StreamController _streamController; //TODO 暂时在此类里无生命周期可消除

  static NavigatorUtils getInstance() {
    if (navigatorUtils == null) {
      navigatorUtils = new NavigatorUtils();
      _streamController = StreamController.broadcast();
    }

    return navigatorUtils;
  }

  StreamController get streamController => _streamController;

  setContext(BuildContext context) {
    mContext = context;
  }

  BuildContext getContext() {
    return mContext;
  }

  // replace 页面
  pushReplacementNamed(BuildContext context, String routeName,
      [WidgetBuilder builder]) {
    if (context != null) mContext = context;
    if (currentNavigator != null) {
      return currentNavigator.pushReplacement(
        CupertinoPageRoute(
          builder: builder ?? configRoutes[routeName],
          settings: RouteSettings(name: routeName),
        ),
      );
    }
  }

  // push 页面
  pushNamed(BuildContext context, String routeName, [WidgetBuilder builder]) {
    if (context != null) mContext = context;
    if (currentNavigator != null) {
      return currentNavigator.push(
        CupertinoPageRoute(
          builder: builder ?? configRoutes[routeName],
          settings: RouteSettings(name: routeName),
        ),
      );
    }
  }

  commPush({BuildContext context, String routeName, WidgetBuilder builder}) {
    if (context != null) mContext = context;
    if (currentNavigator != null) {
      if (routeName != null) {
        return currentNavigator.pushNamed(routeName);
      } else {
        currentNavigator.push(
          CupertinoPageRoute(
            builder: builder,
            // todo
            //settings: RouteSettings(name: routeName),
          ),
        );
      }
    }
  }

  // pop 页面
  pop<T extends Object>(BuildContext context, [T result]) {
    if (context != null) mContext = context;
    Navigator.pop(context, result);
  }

  // pop页面 到routeName为止
  popUntil(BuildContext context, String routeName) {
    if (context != null) mContext = context;
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  // push一个页面， 移除该页面下面所有页面
  pushNamedAndRemoveUntil(BuildContext context, String newRouteName) {
    if (context != null) mContext = context;
    if (currentNavigator != null) {
      return currentNavigator.pushNamedAndRemoveUntil(
          newRouteName, (Route<dynamic> route) => false);
    }
  }

  @override
  void didPush(Route route, Route previousRoute) {
    // 当调用Navigator.push时回调
    super.didPush(route, previousRoute);
    //可通过route.settings获取路由相关内容
    //route.currentResult获取返回内容
    //....等等
    if (_mRoutes == null) {
      _mRoutes = new List<Route>();
    }
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      print('----------------routePush ${route.settings.name}');
      _mRoutes.add(route);
      routeObserver();
    }
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace();
    if (newRoute is CupertinoPageRoute || newRoute is MaterialPageRoute) {
      print('----------------routeReplace ${newRoute.settings.name}');
      _mRoutes.remove(oldRoute);
      _mRoutes.add(newRoute);
      routeObserver();
    }
  }

  ///在弹出路由前
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      print('----------------routePop ${route.settings.name}');
      _mRoutes.remove(route);
      routeObserver();
    }
  }

  @override
  void didRemove(Route removedRoute, Route oldRoute) {
    super.didRemove(removedRoute, oldRoute);
    if (removedRoute is CupertinoPageRoute ||
        removedRoute is MaterialPageRoute) {
      print('----------------routeRemove ${removedRoute.settings.name}');
      _mRoutes.remove(removedRoute);
      routeObserver();
    }
  }

  void routeObserver() {
    print(
        '----------------路由栈 ${_mRoutes.map((Route route) => route.settings.name).toString()}');
    print(
        '----------------当前路由 ${_mRoutes[_mRoutes.length - 1].settings.name}');
    // 当前页面的navigator
    currentNavigator = _mRoutes[_mRoutes.length - 1].navigator;
//    StatusBarUtil.setupStatusBar(_mRoutes[_mRoutes.length - 1]);
    _emitListener();
  }

  _emitListener() {
    streamController.sink.add(_mRoutes);
  }
}
