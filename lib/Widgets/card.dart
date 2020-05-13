import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class MyCards extends StatefulWidget {
  MyCards({
    Key key,
    this.myList,
    this.scale,
    this.openAnimation,
    this.title,
    this.image,
    this.body,
    this.cat,
    this.url,
    this.showSheet,
    this.isComplated,
    this.context,
    this.index,
  }) : super(key: key);
  bool isComplated;

  List myList;
  double scale;
  Function openAnimation;
  String title;
  String image;
  String cat;
  String url;

  String body;

  int index;

  var showSheet;

  var context;

  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: widget.isComplated ? 0 : 1,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: 230,
            // margin: EdgeInsets.only(top: 100),
            child: ListView.builder(
              itemCount: widget.myList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  // onTapDown: (v) {
                  //   print(myList[index]['id']);

                  //   if (myList[index]['id'] == index) {
                  //     setState(() {
                  //       scale = 0.95;
                  //     });
                  //   }
                  // },
                  // onTapUp: (_) {
                  //   if (myList[index] == index) {
                  //     setState(() {
                  //       scale = 1.0;
                  //     });
                  //   }

                  //   print(index);
                  // },
                  onTap: () {
                    // Future.delayed(
                    //     new Duration(milliseconds: 600), () {

                    // });

                    print('list ' + widget.myList[index]['title']);
                    setState(() {
                      widget.openAnimation();
                      widget.title = widget.myList[index]['title'];
                      widget.image = widget.myList[index]['image'];
                      widget.cat = widget.myList[index]['cat'];
                      widget.body = widget.myList[index]['body'];
                      widget.url = widget.myList[index]['url'];
                      print('11 ' + widget.title);
                    });
                    print(widget.title);
                  },
                  child: Transform.scale(
                    scale: widget.scale,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 200,
                        height: 180,
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey[400],
                          //     blurRadius: 10,
                          //     offset: Offset(0, 10),
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(
                              widget.myList[index]['image'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6)
                                ]),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.myList[index]['cat'],
                                  style: TextStyle(color: Colors.white54),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        width: 54,
                                        height: 50,
                                        child: Icon(
                                          SFSymbols.play_fill,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  widget.myList[index]['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                );
              },
            ),
          ),
        ),
        Opacity(
          opacity: widget.isComplated ? 1 : 0,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ),

        ///////////////
        ///
        ///
        ///
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          top: widget.showSheet.value,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                                onPressed: () {
                                  widget.openAnimation();
                                }),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Isa Telci',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    SFSymbols.gobackward_10,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    width: 85,
                                    height: 80,
                                    child: Icon(
                                      SFSymbols.play_fill,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    SFSymbols.goforward_10,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 160,
                      ),
                      // SliderTheme(
                      //   data: SliderTheme.of(context).copyWith(
                      //     activeTrackColor: Colors.red[700],
                      //     inactiveTrackColor: Colors.red[100],
                      //     trackShape: RectangularSliderTrackShape(),
                      //     trackHeight: 4.0,
                      //     thumbColor: Colors.redAccent,
                      //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      //     overlayColor: Colors.red.withAlpha(32),
                      //     overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                      //   ),
                      //   child: Slider(
                      //     value: masterValue,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         masterValue = value;
                      //       });
                      //        masterValue = value;
                      //     },
                      //     min: 0,
                      //     max: 100,
                      //     activeColor: Colors.yellow,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '00:03',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '07:26',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                                icon: Icon(
                                  SFSymbols.heart,
                                  size: 20,
                                ),
                                onPressed: () {
                                  widget.openAnimation();
                                }),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                                icon: Icon(
                                  SFSymbols.arrow_down_circle,
                                  size: 20,
                                ),
                                onPressed: () {
                                  widget.openAnimation();
                                }),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                                icon: Icon(
                                  SFSymbols.square_arrow_up,
                                  size: 20,
                                ),
                                onPressed: () {
                                  widget.openAnimation();
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
