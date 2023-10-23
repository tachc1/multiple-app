import 'package:flutter/material.dart';
import './newview1.dart';  //★１ 外出ししたファイルのインポート

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('main画面のタイトルバー'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('ボタン'),
          //★２ 画面遷移のボタンイベント
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewView1();
          })),
          //★２追加ここまで
        ),
      ),
    );
  }
}
