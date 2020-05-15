import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Animations/scalenimations.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Screens/Bookmark.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Feature extends StatefulWidget {
  Feature({Key key, this.isShow, this.onTapScale, this.controller})
      : super(key: key);
  final bool isShow;
  final Animation<double> onTapScale;
  final AnimationController controller;

  @override
  _FeatureState createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  AudioCache audioCache;
  bool isTabbed = false;
  double tapped = 1;

  tapAnimation() {
    isTabbed = !isTabbed;
    if (isTabbed) {
      setState(() {
        tapped = 0.9;
      });
    } else {
      setState(() {
        tapped = 1;
      });
    }
  }

  List images = [
    'assets/images/isa.jpg',
    'assets/images/isa3.jpg',
    'assets/images/isa3.jpg',
    'assets/images/isanew.jpg',
    'assets/images/isa3.jpg',
    'assets/images/isa3.jpg'
  ];

  List colors = [
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber
  ];
  Random random = new Random();

  int index = 0;

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    changeIndex();
    return Column(
      children: <Widget>[
        SizedBox(
          height: provider.isShow ? 0 : 40,
        ),
        ScaleAnimation(
          0.5,
          Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: provider.isShow ? 0 : 260,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(images[index]),
                )),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Color(0xFF040513).withOpacity(0.6),
                      Color(0xFF040513)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 15,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeAnimation(
                    0.7,
                    ScaleAnimation(
                      3.0,
                      Text(
                        'İsa Telci',
                        style: GoogleFonts.dancingScript(
                            textStyle: TextStyle(
                                color: colors[index],
                                fontSize: 40,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeAnimation(
                    0.9,
                    ScaleAnimation(
                      4.0,
                      Text(
                        'Yaratana ve yaratılana saygılı ol',
                        style: GoogleFonts.dancingScript(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 2,
                        )),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 10,
                  right: 20,
                  child: Transform.scale(
                    scale: tapped,
                    child: FadeAnimation(
                      6,
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xfffffff),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GestureDetector(
                            child: Icon(
                              SFSymbols.heart_fill,
                              size: 25,
                              color: Colors.red,
                            ),
                            onTapDown: (_) {
                              tapAnimation();
                            },
                            onTapUp: (_) {},
                            onTap: () {
                              tapAnimation();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Bookmark()));
                            }),
                      ),
                    ),
                  )),
              Positioned(
                top: 10,
                left: 20,
                child: FadeAnimation(
                  6,
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xfffffff),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Lottie.asset(
                      'assets/11470-loading-lines.json',
                      width: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: provider.isShow ? 0 : 30,
        )
      ],
    );
  }
}
