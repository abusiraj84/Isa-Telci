import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:isa_telci/Animations/fadeanimations.dart';
import 'package:isa_telci/Animations/leftanimations.dart';
import 'package:isa_telci/DB/database_helper.dart';
import 'package:isa_telci/DB/favorite_model.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key key}) : super(key: key);

  @override
  _BookmarkState createState() => _BookmarkState();

  void screenUpdate() {}
}

class _BookmarkState extends State<Bookmark> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // void navigateToDetail(Note note, String title) async {
  //   bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
  // 	  return NoteDetail(note, title);
  //   }));

  //   if (result == true) {
  //   	updateListView();
  //   }
  // }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
    }

    return Scaffold(
        backgroundColor: Color(0xFF040513),
        appBar: AppBar(
          backgroundColor: Color(0xFF13131F),
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  SFSymbols.house_fill,
                  color: Color(0xFFFFFFFF),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            Spacer(),
          ],
        ),
        body: GridView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: count,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int position) {
              return FadeAnimation(
                1 * position / 10,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF616161),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: AssetImage(
                            myList[position]['image'],
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
                      child: LeftAnimation(
                        1 * position / 10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  SFSymbols.heart_fill,
                                  color: Colors.red,
                                ),
                                onPressed: null),
                            Text(
                              this.noteList[position].title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
