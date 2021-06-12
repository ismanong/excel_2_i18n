import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class PagePingDomain extends StatefulWidget {
  @override
  _PagePingDomainState createState() => _PagePingDomainState();
}

class _PagePingDomainState extends State<PagePingDomain> {
  String str = '';
  String resStr = '';

  _ping() {
    setState(() {
      str = '';
      resStr = '';
    });
    Process.start('ping', [
      '-c 10',
      "-i 0.2",
      "-s 1024",
      'api.xxx.com',
    ]).then((Process process) {
      process.stdout.transform(utf8.decoder).listen((data) {
        if (!mounted) return;
        setState(() {
          str += '\n$data';
        });
      });
      process.stderr.transform(utf8.decoder).listen((data) {
        if (!mounted) return;
        setState(() {
          str += '\n$data';
        });
      });
      process.exitCode.then((exitCode) {
        if (!mounted) return;
        setState(() {
          str += 'exit code: $exitCode';
        });
        _result();
      });
    });
  }

  _result() {
    RegExp reg = new RegExp("(received,[^\s]*%)");
    Iterable<Match> matches = reg.allMatches(str);
    for (Match m in matches) {
      String result = m.group(1);
      setState(() {
        resStr += "$result";
      });
    }
  }

  @override
  initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 1), _ping);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('网络诊断', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Text('发起10次网络传输', style: TextStyle(fontSize: 20.0)),
          Text('$str', style: TextStyle(fontSize: 12.0, color: Colors.grey)),
          Text('\n收到：$resStr', style: TextStyle(fontSize: 18.0)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ping(),
        tooltip: '发起10次网络传输',
        child: Icon(Icons.replay_10),
      ),
    );
  }
}
