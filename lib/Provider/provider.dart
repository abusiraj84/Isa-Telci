import 'package:flutter/material.dart';
import 'package:isa_telci/Services/api_service.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class MyProvider with ChangeNotifier {
  bool _isShow = false;
  bool get isShow => _isShow;

  set setIsShow(bool val) {
    _isShow = val;
    notifyListeners();
  }

  bool _isSlide = false;
  bool get isSlide => _isSlide;

  set setisSlide(bool val) {
    _isSlide = val;
    notifyListeners();
  }

  bool _isSlideCat = false;
  bool get isSlideCat => _isSlideCat;

  set setisSlideCat(bool val) {
    _isSlideCat = val;
    notifyListeners();
  }

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  set setselectedIndex(int val) {
    _selectedIndex = val;
    notifyListeners();
  }

  int _selectedCatIndex = -1;
  int get selectedCatIndex => _selectedCatIndex;

  set setselectedCatIndex(int val) {
    _selectedCatIndex = val;
    notifyListeners();
  }

  double _heighCat = 200;
  double get heighCat => _heighCat;

  set setheighCat(double val) {
    _heighCat = val;
    notifyListeners();
  }

  double _heighCatTitle = 30;
  double get heighCatTitle => _heighCatTitle;

  set setheighCatTitle(double val) {
    _heighCatTitle = val;
    notifyListeners();
  }

///// Get All Songs Count //////
  ///
  int _allCount = 0;
  int get allCount => _allCount;
  set setAllCount(int val) {
    _allCount = val;
    notifyListeners();
  }

  int songsCount = 0;
  // print('ccc' + songsCount.toString());
  int get index {
    ApiService().getSongs().then((onValue) {
      try {
        songsCount = onValue['total'] == null ? 0 : onValue['total'];
      } catch (e) {
        songsCount = 0;
        print(e.toString());
      }
      notifyListeners();
    });
    return songsCount;
  }
}

List myList = [
  {
    "title": "Bebeğim",
    "cat": "Şiir",
    "image": "assets/images/1.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Güneş Altınde bır Aşk",
    "url": "https://www.dropbox.com/s/0d40d5nk3k7gr3k/01%20Bebegim.mp3?dl=1"
  },
  {
    "title": "Gitsen Benden",
    "cat": "Şiir",
    "image": "assets/images/2.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Ey Aşkım!",
    "url":
        "https://www.dropbox.com/s/hq9uyolsviwckxs/02%20Gitsen%20Benden.mp3?dl=1"
  },
  {
    "title": "Zaman",
    "cat": "Şiir",
    "image": "assets/images/3.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Dedim sana!",
    "url": "https://www.dropbox.com/s/5a06teg9ck3k6zd/03%20Zaman.mp3?dl=1"
  },
  {
    "title": "Bu Şehir",
    "cat": "Şiir",
    "image": "assets/images/4.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Unutma beni",
    "url": "https://www.dropbox.com/s/2nvxcgjnao1952u/04%20Bu%20Sehir.mp3?dl=1"
  },
  {
    "title": "Babaya Özlem",
    "cat": "Şiir",
    "image": "assets/images/5.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Hatıralar",
    "url":
        "https://www.dropbox.com/s/75qmaml3l1pgh10/12%20babaya%20ozlem.mp3?dl=1"
  },
  {
    "title": "Sevgiye Son",
    "cat": "Şiir",
    "image": "assets/images/6.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Işte oldu!",
    "url":
        "https://p27.f0.n0.cdn.getcloudapp.com/items/04uPvNXZ/05%20sevgiye%20son.mp3"
  },
  {
    "title": "Hoşçakal",
    "cat": "Şiir",
    "image": "assets/images/7.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Güneş Altınde bır Aşk",
    "url": "https://www.dropbox.com/s/h9n6rskpg6c7880/06%20Hoscakal.mp3?dl=1"
  },
  {
    "title": "Sana Değil",
    "cat": "Şiir",
    "image": "assets/images/8.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Güneş Altınde bır Aşk",
    "url":
        "https://www.dropbox.com/s/zr26ad8csyzrnvl/07%20Sana%20degil.mp3?dl=1"
  },
  {
    "title": "Artı Eksi",
    "cat": "Şiir",
    "image": "assets/images/9.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Güneş Altınde bır Aşk",
    "url":
        "https://p27.f0.n0.cdn.getcloudapp.com/items/nOu8LDGX/08%20arti%20eksi.mp3"
  },
  {
    "title": "Yine Yalnızlık",
    "cat": "Şiir",
    "image": "assets/images/10.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Güneş Altınde bır Aşk",
    "url":
        "https://p27.f0.n0.cdn.getcloudapp.com/items/rRu9z04n/09%20yine%20yalnizlik.mp3"
  },
  {
    "title": "Tut ki",
    "cat": "Şiir",
    "image": "assets/images/11.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Güneş Altınde bir Aşk",
    "url": "https://www.dropbox.com/s/ijva47k9f4bp4hq/10%20tut%20ki.mp3?dl=1"
  },
  {
    "title": "Desem ki",
    "cat": "Şiir",
    "image": "assets/images/12.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Her şey bitti",
    "url": "https://www.dropbox.com/s/6vsnsnx2co5daar/11%20desem%20ki.mp3?dl=1"
  },
];

List myList2 = [
  {
    "title": "MUTLULUK",
    "cat": "Şiir",
    "image":
        "assets/images/photo-of-yellow-and-blue-balloons-on-sky-1590915.jpg",
    "body": "",
    "seslendiren": "İsa Telci",
    "siir": "İsa Telci",
    "album": "Elveda Sevgilim",
    "url": "https://p27.f0.n0.cdn.getcloudapp.com/items/YEu1zAg8/01%20oyku.mp3"
  },
];
