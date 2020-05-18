import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Animations/scalenimations.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Soz extends StatelessWidget {
  const Soz({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    return FadeAnimation(
        5.0,
        Container(
          height: provider.isShow ? 0 : 140,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: provider.isShow ? 0 : 100,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff465072).withOpacity(0.5),
                    Color(0xff5C6581)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset('assets/16558-heart-break.json', width: 60),
                    Container(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        'HANİ O ARALIKLARLA VERDİĞİN ÖĞÜTLER VARDI YA ÖYLE BİR ZAMANDA ÖYLE BİR GEDİĞİNE OTURUYOR Kİ',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.8)),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 10,
            viewportFraction: 1,
            scale: 0.9,
            autoplay: provider.isShow ? false : true,
            duration: 2000,
            autoplayDelay: 8000,
            scrollDirection: Axis.vertical,
            curve: Curves.easeInOutSine,
          ),
        ));
  }
}
