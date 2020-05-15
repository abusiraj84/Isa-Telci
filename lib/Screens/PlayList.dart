import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Animations/leftanimations.dart';
import 'package:isa_telci/DB/database_helper.dart';
import 'package:isa_telci/DB/favorite_model.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart' as dioo;
import 'package:provider/provider.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayList extends StatefulWidget {
  PlayList(
      {Key key,
      this.myList,
      this.controller,
      this.opacity,
      this.showSheet,
      this.isShow})
      : super(key: key);
  final List myList;
  final bool isShow;
  final AnimationController controller;
  final Animation<double> showSheet;
  final Animation<double> opacity;

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList>
    with SingleTickerProviderStateMixin {
  bool overlayTime = false;
  bool isComplated;
  String title;
  String body;
  String cat;
  String image;
  String url;
  String album;
  String seslendiren;
  String siir;
  double scale;
  double screenHeight;
  bool isCliced;
////// DataBase Helper /////
  DatabaseHelper helper = DatabaseHelper();
  Note note;

//// AudioPlayer ////
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  String localFilePath;

  AudioCache audioCache;
  PlayerMode mode;
  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;

  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;

  bool isPlay = false;
  String audio;
  String downloadProgress;
  double downloadProgressNoPercent;
  bool isDownloadComplete = false;
  double downloadProgressOpacity = 1;
  String playerState;

  @override
  void initState() {
    super.initState();

    isComplated = false;
    title = '';
    image = 'assets/images/1.jpg';
    body = '';
    cat = '';
    url = '';
    seslendiren = '';
    siir = '';
    album = '';
    scale = 1;
    screenHeight = 0;
    isCliced = false;
//// AudioPlayer ////

    downloadProgress = '';
    downloadProgressNoPercent = 0;
    _initAudioPlayer();
    // add it to your class as a static member

    // or as a local variable

    // call this method when desired
    List introAudios = [
      audioCache.play('19moral.mp3'),
      audioCache.play('10tutki.mp3'),
      audioCache.play('26sensizlik.mp3'),
    ];
  }

  @override
  void dispose() {
    super.dispose();

    //AudioPlayer

    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
  }

  openAnimation() {
    isComplated = !isComplated;
    if (isComplated) {
      widget.controller.forward();
    } else {
      widget.controller.reverse();
    }
  }

  /// Audio Player ///
  Future download2(Dio dio, String url, String savePath) async {
    try {
      dioo.Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      setState(() {
        isDownloadComplete = true;
        Timer(Duration(milliseconds: 2000), () {
          setState(() {
            downloadProgressOpacity = 0;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  showDownloadProgress(received, total) {
    if (total != -1) {
      // print((received / total * 100).toStringAsFixed(0) + "%");
      setState(() {
        downloadProgress = (received / total * 100).toStringAsFixed(0) + "%";
        downloadProgressNoPercent = (received / total * 100);
      });
    } else {}
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _initAudioPlayer() {
    _audioPlayer = new AudioPlayer(mode: mode);
    audioCache = new AudioCache(fixedPlayer: _audioPlayer);
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'عالم حسام',
            artist: 'عندما يختزل الزمان',
            albumTitle: title,
            imageUrl: image,
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
        _stop();
        isPlay = false;
        overlayTime = false;
      });
    });
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      // print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
        overlayTime = false;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }

//// Color /////
  ///

  List colors = [
    Colors.red,
    Colors.green[400],
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.amber
  ];
  Random random = new Random();

  int index = 0;

  void changeIndex() {
    setState(() => index = random.nextInt(5));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.isShow ? 0 : 10,
              horizontal: widget.isShow ? 0 : 25),
          child: AnimatedContainer(
            height: widget.isShow ? 0 : provider.heighCatTitle,
            duration: Duration(milliseconds: 100),
            child: LeftAnimation(
              0.9,
              Text(
                'Son Eklenenler',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Container(
          height: widget.isShow
              ? MediaQuery.of(context).size.height - 0
              : provider.heighCat,
          child: Stack(
            children: <Widget>[
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isComplated ? 0 : 1,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 180,
                  // margin: EdgeInsets.only(top: 100),
                  child: ListView.builder(
                    itemCount: widget.myList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return LeftAnimation(
                        0.2 + (index / 10),
                        GestureDetector(
                          onTap: () {
                            provider.setheighCat = 0;
                            provider.setheighCatTitle = 0;
                            // Future.delayed(
                            //     new Duration(milliseconds: 600), () {

                            // });
                            openAnimation();
                            title = widget.myList[index]['title'];
                            image = widget.myList[index]['image'];
                            cat = widget.myList[index]['cat'];
                            body = widget.myList[index]['body'];
                            url = widget.myList[index]['url'];
                            siir = widget.myList[index]['siir'];
                            seslendiren = widget.myList[index]['seslendiren'];
                            album = widget.myList[index]['album'];

                            setState(() {
                              provider.setIsShow = !widget.isShow;
                              _play();
                              changeIndex();
                              isPlay = true;
                              HapticFeedback.mediumImpact();

                              Future.delayed(new Duration(seconds: 5), () {
                                if (widget.isShow && isPlay) {
                                  setState(() {
                                    overlayTime = true;
                                  });
                                }
                              });
                            });
                          },
                          child: Transform.scale(
                            scale: scale,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 400),
                              opacity: widget.opacity.value,
                              child: AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  width: 186,
                                  height: 180,
                                  margin: EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
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
                                      child: LeftAnimation(
                                        1 + (index / 4),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.myList[index]['album'],
                                              style: TextStyle(
                                                  color: Colors.white54),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Stack(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 5, sigmaY: 5),
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
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
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////////////////////

              Opacity(
                opacity: isComplated ? 1 : 0,
                child: Center(child: CircularProgressIndicator()),
              ),
              /////////////////////////////////////////Play Screen/////////////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////////////////////

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
                          image,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                        ),
                        AnimatedPositioned(
                          top: widget.isShow ? 10 : -200,
                          duration: Duration(milliseconds: 800),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: widget.isShow ? 1 : 0,
                            child: Container(
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
                                    provider.setheighCat = 200;
                                    provider.setheighCatTitle = 30;
                                    provider.setIsShow = false;
                                    openAnimation();
                                    setState(() {
                                      isPlay = false;
                                      overlayTime = false;
                                      _playerState = PlayerState.stopped;
                                      HapticFeedback.mediumImpact();
                                    });
                                    _stop();
                                  }),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: GoogleFonts.dancingScript(
                                    textStyle: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 30,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                album,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'Seslendiren',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        seslendiren,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Opacity(
                                    opacity: isPlay ? 1 : 0,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Lottie.asset(
                                        'assets/17935-loading.json',
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'Şiir',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        siir,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 120,
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
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          width: 50,
                                          height: 50,
                                          child: IconButton(
                                              icon: Icon(
                                                SFSymbols.gobackward_10,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                if (_position.inSeconds
                                                            .toInt() -
                                                        10 >=
                                                    0) {
                                                  setState(() {
                                                    seekToSecond(_position
                                                            .inSeconds
                                                            .toInt() -
                                                        10);
                                                  });
                                                } else if (_position.inSeconds
                                                        .toInt() <
                                                    10) {
                                                  _audioPlayer.stop();
                                                  _play();
                                                }
                                              })),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5, sigmaY: 5),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          width: 80,
                                          height: 80,
                                          child: IconButton(
                                              icon: Icon(
                                                isPlay
                                                    ? SFSymbols.pause_fill
                                                    : SFSymbols.play_fill,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                              onPressed: () {
                                                if (_playerState ==
                                                    PlayerState.stopped) {
                                                  _play();
                                                  changeIndex();
                                                  Future.delayed(
                                                      new Duration(seconds: 5),
                                                      () {
                                                    if (_isPlaying &&
                                                        widget.isShow) {
                                                      setState(() {
                                                        overlayTime = true;
                                                      });
                                                    }
                                                  });
                                                  HapticFeedback.mediumImpact();
                                                } else if (_isPaused) {
                                                  _play();
                                                  changeIndex();
                                                  HapticFeedback.mediumImpact();
                                                  Future.delayed(
                                                      new Duration(seconds: 5),
                                                      () {
                                                    if (_isPlaying &&
                                                        widget.isShow) {
                                                      setState(() {
                                                        overlayTime = true;
                                                      });
                                                    }
                                                  });
                                                } else if (_isPlaying &&
                                                    widget.isShow) {
                                                  _audioPlayer.pause();
                                                  _playerState =
                                                      PlayerState.paused;
                                                  HapticFeedback.mediumImpact();
                                                  Future.delayed(
                                                      new Duration(seconds: 5),
                                                      () {
                                                    if (_isPlaying &&
                                                        widget.isShow) {
                                                      setState(() {
                                                        overlayTime = true;
                                                      });
                                                    }
                                                  });
                                                }

                                                setState(() {
                                                  isPlay = !isPlay;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
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
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          width: 50,
                                          height: 50,
                                          child: IconButton(
                                              icon: Icon(
                                                SFSymbols.goforward_10,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                if (_position.inSeconds
                                                            .toInt() +
                                                        10 <=
                                                    _duration.inSeconds
                                                        .toInt()) {
                                                  setState(() {
                                                    seekToSecond(_position
                                                            .inSeconds
                                                            .toInt() +
                                                        10);
                                                  });
                                                } else if (_position.inSeconds
                                                            .toInt() +
                                                        10 >=
                                                    _duration.inSeconds
                                                        .toInt()) {
                                                  _playerState =
                                                      PlayerState.stopped;
                                                }
                                              })),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Lottie.asset('assets/2881-music-fly.json',
                                  width: 160, fit: BoxFit.cover),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            slider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _position?.toString()?.split('.')?.first,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    _duration?.toString()?.split('.')?.first,
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
                                        print('like');
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
                                        print('download');
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
                                        print('share');
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

              ///////////////////////////////////////// Screen Saver ///////////////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////////////////////
              Positioned(
                top: widget.showSheet.value,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 800),
                  opacity: overlayTime ? 1 : 0,
                  child: Transform.scale(
                    scale: 1 + _position.inMicroseconds.toDouble() / 100000000,
                    child: Image.asset(
                      image,
                      height:
                          overlayTime ? MediaQuery.of(context).size.height : 0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              AnimatedOpacity(
                duration: Duration(milliseconds: 800),
                opacity: overlayTime ? 1 : 0,
                child: GestureDetector(
                  onTap: () {
                    overlayTime = false;
                    Future.delayed(new Duration(seconds: 5), () {
                      if (_isPlaying && widget.isShow) {
                        setState(() {
                          overlayTime = true;
                          changeIndex();
                        });
                      }
                    });
                  },
                  child: Container(
                    height:
                        overlayTime ? MediaQuery.of(context).size.height : 0,
                    width: MediaQuery.of(context).size.width,
                    color: colors[index].withOpacity(0.2),
                    child: Center(
                        child: Container(
                      height: 400,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/images/isanew.jpg'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            title,
                            style: GoogleFonts.marckScript(
                                textStyle: TextStyle(
                                    color: colors[index],
                                    fontSize: 40,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text(
                            'Album : ${album}',
                            style: GoogleFonts.grenze(
                                textStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Lottie.asset(
                            'assets/8490-audio-wave-micro-interaction.json',
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            (_duration - _position)
                                .toString()
                                ?.split('.')
                                ?.first,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.red[700],
        inactiveTrackColor: Colors.red[100],
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 2.0,
        thumbColor: Colors.redAccent,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayColor: Colors.red.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      ),
      child: Slider(
          activeColor: colors[index],
          inactiveColor: Colors.white,
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChanged: (double value) {
            setState(() {
              seekToSecond(value.toInt());
              value = value;
            });
          }),
    );
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    _audioPlayer.seek(newDuration);
  }
}
