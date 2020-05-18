import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Screens/Categories.dart';
import 'package:provider/provider.dart';
import 'Soz.dart';
import 'Feature.dart';
import 'PlayList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> showSheetAnimation;
  Animation<double> opacity;
  Animation<double> onTapScale;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    showSheetAnimation = Tween<double>(begin: 900, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);
    opacity = Tween<double>(begin: 1, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);

    onTapScale = Tween<double>(begin: 0.9, end: 1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    //AudioPlayer
  }

  Future<Null> getRefresfh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    final provider = Provider.of<MyProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFF0B0D2B),
      body: RefreshIndicator(
        onRefresh: getRefresfh,
        backgroundColor: Colors.black54,
        color: Colors.yellow,
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) {
            return SingleChildScrollView(
              physics: provider.isShow ? NeverScrollableScrollPhysics() : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Feature(
                    onTapScale: onTapScale,
                    controller: controller,
                  ),
                  Soz(),
                  PlayList(
                      controller: controller,
                      myList: myList,
                      showSheet: showSheetAnimation,
                      opacity: opacity,
                      isShow: provider.isShow),
                  Catecories()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
