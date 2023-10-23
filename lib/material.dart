import 'package:flutter/material.dart';

class NewView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('NewView1のタイトルバー'),
      ),
      body: Center(
        child: Text('NewView1'),
      ),
    );
  }
}
