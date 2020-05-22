import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Animations/leftanimations.dart';
import 'package:isa_telci/DB/database_helper.dart';
import 'package:isa_telci/Screens/ShowSong.dart';
import 'package:isa_telci/Services/api_service.dart';
import 'package:lottie/lottie.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key key}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();

  void screenUpdate() {}
}

class _AllSongsState extends State<AllSongs> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  ApiService _apiService;
  int songsCount = 0;

  @override
  void initState() {
    super.initState();

    _apiService = ApiService();
    _apiService.getSongs().then((data) {
      setState(() {
        songsCount = data['total'] == null ? 0 : data['total'];
      });
    });
  }

  Future<Null> getRefresfh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1F),
      appBar: AppBar(
        backgroundColor: Color(0xFF4D4D4D),
        leading: IconButton(
            icon: Icon(
              SFSymbols.house_fill,
              color: Color(0xFFFFFFFF),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Büttün Şiir (${songsCount})',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _apiService.getSongs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;

            return RefreshIndicator(
              onRefresh: getRefresfh,
              backgroundColor: Colors.white24,
              color: Color(0xff7B42F6),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: content['data'].length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeAnimation(
                    0.2 * index / 10,
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 800),
                          pageBuilder: (_, animation, __) => FadeTransition(
                            opacity: animation,
                            child: ShowSong(
                              title: content['data'][index]['title'],
                              image:
                                  'http://167.71.44.144/admin/_lib/file/img/' +
                                      content['data'][index]['image'],
                            ),
                          ),
                        ));
                      },
                      child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFF616161),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.45),
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ],
                            image: DecorationImage(
                                image: NetworkImage(
                                  'http://167.71.44.144/admin/_lib/file/img/' +
                                      content['data'][index]['image'],
                                ),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black12, Colors.black45],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: LeftAnimation(
                                0.2 * index / 10,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(.15),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.15),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 20,
                                                    offset: Offset(0, 10),
                                                    color: Color(0xFF000102)
                                                        .withOpacity(0.25))
                                              ]),
                                          child: Text(
                                            content['data'][index]['albums']
                                                ['title'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          content['data'][index]['title'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            width: 150,
                                            height: 10,
                                            color: Colors.white30,
                                            child: Row(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Container(
                                                    width: 4 * index.toDouble(),
                                                    height: 7,
                                                    color:
                                                        Colors.deepPurple[800],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 2.2 : 3),
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Lottie.asset('assets/935-loading.json', width: 200),
              ),
            );
          }
        },
      ),
    );
  }
}
