import 'package:flutter/material.dart';

class ShowSong extends StatefulWidget {
  ShowSong({Key key, this.title, this.image}) : super(key: key);
  final String title;
  final String image;
  @override
  _ShowSongState createState() => _ShowSongState();
}

class _ShowSongState extends State<ShowSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Hero(
              tag: 'husam_${widget.title}', child: Image.network(widget.image)),
          // Text(widget.title)
        ],
      ),
    );
  }
}
