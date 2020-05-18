import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
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

  List baslik = [
    'Yaratana ve yaratılana saygılı ol ',
    'Başladığın cümleyi bitiremezsen, gelir başkası noktayı koyar',
    'Aşk, iki kişiden tek kişi oluncaya dek, sadece bir kelimeden ibarettir.',
    'Yaratana ve yaratılana saygılı ol ',
    'Başladığın cümleyi bitiremezsen, gelir başkası noktayı koyar',
    'Aşk, iki kişiden tek kişi oluncaya dek, sadece bir kelimeden ibarettir.',
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
        ScaleAnimation(
          0.5,
          Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: provider.isShow ? 0 : 300,
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
                      Color(0xFF0B0D2B).withOpacity(0.6),
                      Color(0xFF0B0D2B)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 45,
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
                bottom: 20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeAnimation(
                    0.9,
                    ScaleAnimation(
                      4.0,
                      Container(
                        alignment: Alignment.center,
                        width: 500,
                        child: FadeAnimatedTextKit(
                            isRepeatingAnimation: true,
                            totalRepeatCount: 100000,
                            duration: Duration(milliseconds: 5000),
                            pause: Duration(milliseconds: 500),
                            onTap: () {
                              print("Tap Event");
                            },
                            text: [
                              "Yaratana ve yaratılana saygılı ol",
                              "Başladığın cümleyi bitiremezsen, gelir başkası noktayı koyar",
                              "Aşk, iki kişiden tek kişi oluncaya dek, sadece bir kelimeden ibarettir.",
                            ],
                            textStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Agne",
                                color: Colors.white),
                            textAlign: TextAlign.center,
                            alignment: AlignmentDirectional
                                .topStart // or Alignment.topLeft
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 30,
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
                top: 30,
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
