import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:isa_telci/Services/api_service.dart';

class ShowCat extends StatefulWidget {
  const ShowCat({Key key, this.id, this.image, this.albumTitle})
      : super(key: key);
  final int id;
  final String image;
  final String albumTitle;
  @override
  _ShowCatState createState() => _ShowCatState();
}

class _ShowCatState extends State<ShowCat> {
  ApiService _apiService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF040513),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black26,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  centerTitle: true,
                  title: Container(
                    height: 50,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black54,
                    child: Text(widget.albumTitle,
                        style: GoogleFonts.satisfy(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ))),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      image: DecorationImage(
                        image: AssetImage(
                          widget.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: FutureBuilder(
            future: _apiService.a(widget.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Map content = snapshot.data;
                return ListView.builder(
                  itemCount: content['data'][0]['songs'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(SFSymbols.play_fill,
                                  color: Colors.white),
                              onPressed: null),
                          Text(
                            content['data'][0]['songs'][index]['title'],
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              icon: Icon(SFSymbols.heart, color: Colors.white),
                              onPressed: null)
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
