import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Animations/leftanimations.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Screens/ShowCat.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Catecories extends StatelessWidget {
  const Catecories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: provider.isShow ? 0 : 25),
          child: AnimatedContainer(
            height: provider.isShow ? 0 : provider.heighCatTitle,
            duration: Duration(milliseconds: 100),
            child: LeftAnimation(
              0.9,
              Text(
                'Albumlar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: provider.isShow ? 0 : null,
          child: GridView.builder(
              padding: EdgeInsets.zero,
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
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF8C2381).withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'YENİ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      )),
                                  CircleAvatar(
                                    backgroundColor:
                                        Color(0xFFCED20A).withOpacity(0.8),
                                    radius: 12,
                                    child: Text(
                                      '5',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1C5E91).withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    allList[index]['cat'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
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
