import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Animations/leftanimations.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Screens/ShowCat.dart';
import 'package:isa_telci/Services/api_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Abulmlar extends StatefulWidget {
  const Abulmlar({Key key}) : super(key: key);

  @override
  _AbulmlarState createState() => _AbulmlarState();
}

class _AbulmlarState extends State<Abulmlar> {
  ApiService _apiService;
  int songsCount = 0;
  int albumsCount = 0;
  @override
  void initState() {
    _apiService = ApiService();
    _apiService.getSongs().then((data) {
      setState(() {
        songsCount = data['total'] == null ? 0 : data['total'];
      });
    });
    _apiService.getAlbums().then((data) {
      setState(() {
        albumsCount = data['total'] == null ? 0 : data['total'];
      });
    });

    super.initState();
  }

//// Color /////
  ///

  List colors = [
    Color(0xff6800FF),
    Color(0xff0198FF),
    Color(0xffFFBB00),
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber,
  ];
  Random random = new Random();

  int index = 0;

  void changeIndex() {
    setState(() => index = random.nextInt(albumsCount));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Albümler',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xff893EF5),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: Offset(0, 2.5))
                            ],
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            "Şiir sayısı: " + songsCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFD6465),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: Offset(0, 2.5))
                            ],
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            "Albüm sayısı: " + albumsCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: provider.isShow ? 0 : null,
            child: FutureBuilder(
              future: _apiService.getAlbums(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Map content = snapshot.data;

                  return Container(
                    height: 170,
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: content['data'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return FadeAnimation(
                            2 * index / 10,
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShowCat(
                                    id: content['data'][index]['id'],
                                    albumTitle: content['data'][index]['title'],
                                    image:
                                        'http://167.71.44.144/admin/_lib/file/img/' +
                                            content['data'][index]['image'],
                                  ),
                                ));
                              },
                              child: Container(
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          height: 100,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          // padding: EdgeInsets.symmetric(vertical: 20),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF616161),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.45),
                                                    blurRadius: 5,
                                                    offset: Offset(0, 2.5))
                                              ],
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    'http://167.71.44.144/admin/_lib/file/img/' +
                                                        content['data'][index]
                                                            ['image'],
                                                  ),
                                                  fit: BoxFit.cover),
                                              gradient: LinearGradient(
                                                  begin: Alignment.center,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withOpacity(0.6)
                                                  ]),
                                              border: Border.all(
                                                  color: colors[index],
                                                  width: 5)),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                          ),
                                        ),
                                        Positioned(
                                          left: 10,
                                          top: 20,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 12,
                                            child: Text(
                                              content['data'][index]['songs']
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color(0xff893EF5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(.15),
                                                  border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.15),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 10,
                                                        offset: Offset(0, 5),
                                                        color: Color(0xFF000102)
                                                            .withOpacity(0.25))
                                                  ]),
                                              child: Text(
                                                content['data'][index]['title'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Container(
                    height: 100,
                    child: Center(
                      child: Lottie.asset('assets/2881-music-fly.json',
                          width: 200),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
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
