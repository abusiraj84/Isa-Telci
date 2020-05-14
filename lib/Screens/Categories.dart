import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Screens/ShowCat.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Catecories extends StatelessWidget {
  const Catecories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: provider.isShow ? 0 : null,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: allList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return FadeAnimation(
              2 * index / 10,
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowCat(
                        image: allList[index]['image'],
                        cat: allList[index]['cat']),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF616161),
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: AssetImage(
                          allList[index]['image'],
                        ),
                        fit: BoxFit.cover),
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6)
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(0xff8C8B92).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Lottie.asset('assets/21843-creativity-love.json',
                                  width: 50),
                              Text(
                                allList[index]['cat'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

List allList = [
  {
    'id': '1',
    'cat': 'Ask',
    'image': 'assets/images/love.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/Jrubp4LA/01%20Bebegim.mp3'
  },
  {
    'id': '1',
    'cat': 'Ayrilik',
    'image': 'assets/images/ayilik.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/Jrubp4LA/01%20Bebegim.mp3'
  },
  {
    'id': '1',
    'cat': 'Babam',
    'image': 'assets/images/baba.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/Jrubp4LA/01%20Bebegim.mp3'
  },
  {
    'id': '1',
    'cat': 'Annem',
    'image': 'assets/images/mother.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/Jrubp4LA/01%20Bebegim.mp3'
  },
];
