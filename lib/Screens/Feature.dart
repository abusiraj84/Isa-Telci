import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:provider/provider.dart';

class Feature extends StatefulWidget {
  Feature({Key key, this.isShow}) : super(key: key);
  final bool isShow;
  @override
  _FeatureState createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        SizedBox(
          height: provider.isShow ? 0 : 40,
        ),
        FadeAnimation(
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
                  image: AssetImage('assets/images/isanew.jpg'),
                )),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black
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
                    Text(
                      'İsa Telci',
                      style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                              color: Colors.yellow,
                              fontSize: 40,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold)),
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
              )
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
