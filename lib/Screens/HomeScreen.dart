import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Screens/Albumlar.dart';
import 'package:isa_telci/Services/api_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'CatCards.dart';
import 'OneAlbum.dart';
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
      backgroundColor: Color(0xFF1D1D1D),
      body: RefreshIndicator(
        onRefresh: getRefresfh,
        backgroundColor: Colors.black38,
        color: Color(0xff7B42F6),
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
                  Abulmlar(),
                  PlayList(
                      controller: controller,
                      myList: myList,
                      showSheet: showSheetAnimation,
                      opacity: opacity,
                      isShow: provider.isShow),
                  provider.isShow
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                        )
                      : FutureBuilder(
                          future: ApiService().getAlbums(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              Map content = snapshot.data;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: content['data'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  // return OneAlbum(
                                  //   controller: controller,
                                  //   myList: myList,
                                  //   showSheet: showSheetAnimation,
                                  //   opacity: opacity,
                                  //   isShow: provider.isShow,
                                  //   albumTitle: content['data'][index]['title'],
                                  //   albumList: content['data'][index]['songs'],
                                  // );

                                  return CatCards(
                                      albumTitle: content['data'][index]
                                          ['title'],
                                      albumList: content['data'][index]
                                          ['songs'],
                                      albumIndex: index);
                                },
                              );
                            } else {
                              return Center(
                                  child: Container(
                                width: 50,
                                height: 50,
                                child: Column(
                                  children: <Widget>[
                                    Lottie.asset(
                                      'assets/8406-loading-flip.json',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ));
                            }
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
