import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
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
                  color: Color(0xffC6D0EB),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.45),
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset('assets/22349-email-confirmation-icon.json',
                        width: 60),
                    Container(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        'HANİ O ARALIKLARLA VERDİĞİN ÖĞÜTLER VARDI YA ÖYLE BİR ZAMANDA ÖYLE BİR GEDİĞİNE OTURUYOR Kİ',
                        style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                                color: Colors.black,
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
