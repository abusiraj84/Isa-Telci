import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:provider/provider.dart';
import 'Feature.dart';
import 'PlayList.dart';
import 'PlayList2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> showSheetAnimation;
  Animation<double> showSheetAnimation2;
  Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    showSheetAnimation = Tween<double>(begin: 900, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);
    showSheetAnimation2 = Tween<double>(begin: 900, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);
    opacity = Tween<double>(begin: 1, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    //AudioPlayer
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    final provider = Provider.of<MyProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xff020202),
      body: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return SingleChildScrollView(
            physics: provider.isShow ? NeverScrollableScrollPhysics() : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Feature(),
                PlayList(
                    controller: controller,
                    myList: myList,
                    showSheet: showSheetAnimation,
                    opacity: opacity,
                    isShow: provider.isShow),
                PlayList2(
                    controller: controller,
                    myList: myList2,
                    showSheet: showSheetAnimation2,
                    opacity: opacity,
                    isShow: provider.isShow2)
              ],
            ),
          );
        },
      ),
    );
  }
}
