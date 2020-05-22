import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isa_telci/Services/api_service.dart';
import 'package:lottie/lottie.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class ShowCat extends StatefulWidget {
  const ShowCat({Key key, this.id, this.image, this.albumTitle})
      : super(key: key);

  final String albumTitle;
  final int id;
  final String image;

  @override
  _ShowCatState createState() => _ShowCatState();
}

class _ShowCatState extends State<ShowCat> with SingleTickerProviderStateMixin {
  String album;
  String audio;
  AudioCache audioCache;
  String body;
  String cat;
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

  AnimationController controller;
  String downloadProgress;
  double downloadProgressNoPercent;
  double downloadProgressOpacity = 1;
  int index = 0;
  bool isCliced;
  bool isComplated;
  bool isDownloadComplete = false;
  bool isPlay = false;
  int selectedIndex = -1;
  String localFilePath;
  PlayerMode mode;
  bool overlayTime = false;
  String playerState;
  Random random = new Random();
  double scale;
  Animation<double> scalePlay;
  double screenHeight;
  String image;

  String seslendiren;
  String siir;
  String title;
  Animation<double> topPlay;
  String url;

  ApiService _apiService;
  //// AudioPlayer ////

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;

  Duration _duration = new Duration();

  StreamSubscription _durationSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _playerStateSubscription;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  Duration _position = new Duration();
  StreamSubscription _positionSubscription;

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

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    scalePlay = Tween<double>(begin: 1, end: 1.05).animate(controller);
    topPlay = Tween<double>(begin: 600, end: 600).animate(controller);
    _apiService = ApiService();

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
  }

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  openAnimation() {
    isComplated = !isComplated;
    if (isComplated) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  /// Audio Player ///

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
            title: 'Isa Telci App',
            artist: 'By Husamnas.com',
            albumTitle: title,
            imageUrl: 'http://167.71.44.144/admin/_lib/file/img/' + image,
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

  void changeIndex() {
    setState(() => index = random.nextInt(8));
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
          activeColor: Color(0xffFD6465),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1F),
      body: DefaultTabController(
        length: 2,
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) {
            return Stack(
              children: <Widget>[
                NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _stop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                )),
                          ),
                          expandedHeight: 300.0,
                          floating: false,
                          pinned: true,
                          backgroundColor: Colors.black12,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: EdgeInsets.zero,
                            centerTitle: true,
                            title: Container(
                                alignment: Alignment.bottomCenter,
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black54,
                                child: Text(
                                  isPlay ? title : widget.albumTitle,
                                  style: GoogleFonts.parisienne(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                )),
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                image: DecorationImage(
                                  image: NetworkImage(
                                    isPlay
                                        ? 'http://167.71.44.144/admin/_lib/file/img/' +
                                            image
                                        : widget.image,
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
                      future: _apiService.getAlbumById(widget.id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          Map content = snapshot.data;
                          return ListView.builder(
                            itemCount: content['data'][0]['songs'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5),
                                child: Transform.scale(
                                  scale: selectedIndex == index && isPlay
                                      ? scalePlay.value
                                      : 1,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 800),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: selectedIndex == index && isPlay
                                          ? Colors.white54
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                  selectedIndex == index &&
                                                          isPlay
                                                      ? SFSymbols.pause_fill
                                                      : SFSymbols.play_fill,
                                                  color:
                                                      selectedIndex == index &&
                                                              isPlay
                                                          ? Colors.white
                                                          : Color(0xff893EF5)),
                                              onPressed: () {
                                                title = content['data'][0]
                                                    ['songs'][index]['title'];
                                                image = content['data'][0]
                                                    ['songs'][index]['image'];
                                                siir = content['data'][0]
                                                        ['songs'][index]
                                                    ['yazar']['name'];
                                                seslendiren = content['data'][0]
                                                        ['songs'][index]
                                                    ['seslendiren']['name'];
                                                // openAnimation();
                                                setState(() {
                                                  if (isPlay) {
                                                    // when slide is true

                                                    if (selectedIndex !=
                                                        index) {
                                                      // when select another card
                                                      controller.reset();
                                                      _position =
                                                          Duration(seconds: 0);
                                                      selectedIndex = index;
                                                      controller.forward();
                                                      _stop();
                                                      url = content['data'][0]
                                                              ['songs'][index]
                                                          ['url'];
                                                      _play();
                                                    } else {
                                                      // when select exiset card
                                                      controller.reverse();

                                                      selectedIndex = -1;
                                                      isPlay = !isPlay;

                                                      if (_playerState ==
                                                          PlayerState.stopped) {
                                                        _play();
                                                      } else if (_playerState ==
                                                          PlayerState.paused) {
                                                        _play();
                                                      } else if (_playerState ==
                                                          PlayerState.playing) {
                                                        _pause();
                                                      }
                                                    }
                                                  } else {
                                                    // when slide is false
                                                    isPlay = !isPlay;
                                                    selectedIndex = index;
                                                    controller.forward();
                                                    url = content['data'][0]
                                                        ['songs'][index]['url'];
                                                    if (_playerState ==
                                                            PlayerState
                                                                .stopped ||
                                                        _playerState ==
                                                            PlayerState
                                                                .paused) {
                                                      _play();
                                                    } else {
                                                      _pause();
                                                    }
                                                    // _stop();
                                                    // _position =
                                                    //     Duration(seconds: 0);
                                                  }
                                                });
                                                // setState(() {
                                                //   selectedIndex = index;
                                                //   if (selectedIndex == index) {
                                                //     url = content['data'][0]
                                                //         ['songs'][index]['url'];
                                                //     _stop();
                                                //     _position =
                                                //         Duration(seconds: 0);
                                                //   }
                                                //   if (selectedIndex != index) {}
                                                // });
                                                // isPlay = !isPlay;
                                                // if (_playerState ==
                                                //     PlayerState.stopped) {
                                                //   _play();
                                                // } else if (_playerState ==
                                                //     PlayerState.paused) {
                                                //   _play();
                                                // } else if (_playerState ==
                                                //     PlayerState.playing) {
                                                //   _pause();
                                                // }
                                              },
                                            ),
                                            Opacity(
                                              opacity: selectedIndex == index &&
                                                      isPlay
                                                  ? 1
                                                  : 0,
                                              child: IconButton(
                                                  icon: Icon(
                                                    SFSymbols.stop_fill,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    _stop();
                                                    isPlay = !isPlay;
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              content['data'][0]['songs'][index]
                                                  ['title'],
                                              style: TextStyle(
                                                  color: isPlay &&
                                                          selectedIndex == index
                                                      ? Colors.yellow
                                                      : Colors.white),
                                              textAlign: TextAlign.left,
                                            ),
                                            AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                height: isPlay &&
                                                        selectedIndex ==
                                                            index &&
                                                        _position >=
                                                            Duration(seconds: 1)
                                                    ? 20
                                                    : 0,
                                                child: Opacity(
                                                  opacity: isPlay &&
                                                          selectedIndex == index
                                                      ? 1
                                                      : 0,
                                                  child: Text(
                                                      (_duration - _position)
                                                          .toString()
                                                          ?.split('.')
                                                          ?.first
                                                          .substring(2),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        height: 2,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                      )),
                                                ))
                                          ],
                                        ),
                                        IconButton(
                                            icon: Icon(SFSymbols.heart,
                                                color: Colors.white),
                                            onPressed: null)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Lottie.asset('assets/9921-loader.json',
                                  width: 100),
                            ),
                          );
                        }
                      },
                    )),

                AnimatedPositioned(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOutCirc,
                  height: _position == Duration(seconds: 0) && isPlay
                      ? MediaQuery.of(context).size.height
                      : 0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 2000),
                    opacity:
                        _position == Duration(seconds: 0) && isPlay ? 1 : 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white70,
                    ),
                  ),
                ),

                //Sheet Bottom
                AnimatedPositioned(
                  duration: Duration(milliseconds: 400),
                  top: isPlay
                      ? MediaQuery.of(context).size.height - 100
                      : MediaQuery.of(context).size.height,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: _position == Duration(seconds: 0) && isPlay
                              ? Colors.black38
                              : Colors.white30,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: <Widget>[
                            _position > Duration(seconds: 0) && isPlay
                                ? Positioned(
                                    top: 27,
                                    left: 23,
                                    child: Lottie.network(
                                        'https://assets7.lottiefiles.com/packages/lf20_hWydms.json',
                                        width: 50))
                                : Container(),
                            Positioned(
                              top: 22,
                              left: 20,
                              child: IconButton(
                                  icon: Icon(
                                    SFSymbols.stop_circle_fill,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    _stop();
                                    setState(() {
                                      isPlay = !isPlay;
                                    });
                                  }),
                            ),
                            Positioned(
                                top: 10,
                                right: 0,
                                left: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'Şiir: ' + siir,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'Seslendiren: ' + seslendiren,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                )),
                            Positioned(
                              top: 25,
                              left: 56,
                              width: 360,
                              child: slider(),
                            ),
                            Positioned(
                                top: 65,
                                left: 80,
                                width: 320,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _position
                                          ?.toString()
                                          ?.split('.')
                                          ?.first
                                          .substring(2),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      _duration
                                          ?.toString()
                                          ?.split('.')
                                          ?.first
                                          .substring(2),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _position == Duration(seconds: 0) && isPlay
                    ? Center(
                        child: Lottie.network(
                            'https://assets7.lottiefiles.com/packages/lf20_2Zgw6g.json',
                            width: 200),
                      )
                    : Container(
                        height: 0,
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}
