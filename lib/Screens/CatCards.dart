import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:isa_telci/Provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class CatCards extends StatefulWidget {
  CatCards({Key key, this.albumTitle, this.albumList, this.albumIndex})
      : super(key: key);

  final String albumTitle;
  final List albumList;
  final int albumIndex;

  @override
  _CatCardsState createState() => _CatCardsState();
}

class _CatCardsState extends State<CatCards> {
  PlayerMode mode;

  bool isSlide = false;
  String mySongCatName = '';
  int indexxx = 0;
  int selectedIndex = -1;
  int selectedCatIndex = -1;
  bool isDownloadComplete = false;
  bool isPlay = false;

  String image;

  String seslendiren;
  String siir;
  String title;
  String url;
  String album;
  String audio;
  AudioCache audioCache;
  String body;
  String cat;

  @override
  void initState() {
    super.initState();
    title = '';
    image = 'assets/images/1.jpg';
    body = '';
    cat = '';
    url = '';
    seslendiren = '';
    siir = '';
    album = '';
//// AudioPlayer ////

    _initAudioPlayer();
  }

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

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

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
    _audioPlayer = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
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
        // overlayTime = false;
      });
    });
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      // print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
        //  overlayTime = false;
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
    final provider = Provider.of<MyProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.albumTitle,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Consumer<MyProvider>(
            builder: (BuildContext context, MyProvider value, Widget child) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: indexxx == provider.selectedIndex &&
                        provider.selectedCatIndex == widget.albumIndex
                    ? 240
                    : 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.albumList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          title = widget.albumList[index]['title'];
                          image = widget.albumList[index]['image'];
                          cat =
                              widget.albumList[index]['category']['name'] ?? '';
                          body = widget.albumList[index]['body'];
                          url = widget.albumList[index]['url'];
                          siir = widget.albumList[index]['yazar']['name'];
                          seslendiren =
                              widget.albumList[index]['seslendiren']['name'];
                          if (provider.isSlide) {
                            // when select another card
                            if (provider.selectedIndex != index &&
                                provider.selectedCatIndex ==
                                    widget.albumIndex) {
                              provider.setselectedIndex = index;
                              indexxx = index;
                              provider.setselectedCatIndex = widget.albumIndex;
                              if (_playerState == PlayerState.stopped) {
                                _play();
                              } else if (_playerState == PlayerState.paused) {
                                _play();
                              } else if (_playerState == PlayerState.playing) {
                                _pause();
                              }
                            } // when select exiset card
                            else {
                              if (provider.isSlide &&
                                  provider.selectedCatIndex ==
                                      widget.albumIndex) {
                                provider.setselectedIndex = -1;
                                provider.setisSlide = !provider.isSlide;
                              } else {
                                provider.setselectedIndex = index;
                                indexxx = index;
                                provider.setisSlide = !provider.isSlide;
                              }

                              provider.setselectedCatIndex = widget.albumIndex;

                              provider.setisSlide = !provider.isSlide;
                            }
                          } // when slide is false
                          else {
                            provider.setisSlide = !provider.isSlide;
                            provider.setselectedIndex = index;
                            indexxx = index;
                            provider.setselectedCatIndex = widget.albumIndex;
                            _play();
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Stack(
                            children: <Widget>[
                              AnimatedPositioned(
                                curve: Curves.easeOutSine,
                                duration: Duration(milliseconds: 100),
                                top: index == provider.selectedIndex &&
                                        provider.selectedCatIndex ==
                                            widget.albumIndex
                                    ? 48
                                    : 0,
                                left: 20,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  height: 150,
                                  width: 160,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 5))
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFFFFFFF)
                                                .withOpacity(0.9),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Lottie.asset(
                                                  'assets/8249-music-spectrum.json',
                                                  width: 25),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 20, right: 20),
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF161616),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          width: 200,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "http://167.71.44.144/admin/_lib/file/img/${widget.albumList[index]['image']}",
                                          placeholder: (context, url) => Center(
                                              child: Lottie.asset(
                                                  'assets/2530-recognizemusicfail.json',
                                                  width: 50)),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 200,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.6),
                                                  Colors.black,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Text(
                                            widget.albumList[index]['title'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ))
                                    ],
                                  )),
                            ],
                          ),
                        ));
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
