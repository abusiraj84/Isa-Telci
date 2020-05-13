import 'package:flutter/material.dart';

class MyProvider with ChangeNotifier {
  bool _isShow = false;
  bool get isShow => _isShow;

  set setIsShow(bool val) {
    _isShow = val;
    notifyListeners();
  }

  bool _isShow2 = false;
  bool get isShow2 => _isShow2;

  set setIsShow2(bool val) {
    _isShow2 = val;
    notifyListeners();
  }
}

List myList = [
  {
    'title': 'Bebeğim',
    'cat': 'Şiir',
    'image': 'assets/images/1.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/Jrubp4LA/01%20Bebegim.mp3'
  },
  {
    'title': 'Gitsen Benden',
    'cat': 'Şiir',
    'image': 'assets/images/2.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/eDu6rj15/02%20Gitsen%20Benden.mp3'
  },
  {
    'title': 'Zaman',
    'cat': 'Şiir',
    'image': 'assets/images/3.jpg',
    'body': '',
    'url': 'https://p27.f0.n0.cdn.getcloudapp.com/items/rRu9gGlx/03%20Zaman.mp3'
  },
  {
    'title': 'Bu Şehir',
    'cat': 'Şiir',
    'image': 'assets/images/4.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/kpuLAn49/04%20Bu%20Sehir.mp3'
  },
  {
    'title': 'Babaya Özlem',
    'cat': 'Şiir',
    'image': 'assets/images/5.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/jkulRenq/12%20babaya%20ozlem.mp3'
  },
  {
    'title': 'Sevgiye Son',
    'cat': 'Şiir',
    'image': 'assets/images/6.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/04uPvNXZ/05%20sevgiye%20son.mp3'
  },
  {
    'title': 'Hoşçakal',
    'cat': 'Şiir',
    'image': 'assets/images/7.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/p9u7Zrq2/06%20Hoscakal.mp3'
  },
  {
    'title': 'Sana Değil',
    'cat': 'Şiir',
    'image': 'assets/images/8.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/jkulRY5e/07%20Sana%20degil.mp3'
  },
  {
    'title': 'Artı Eksi',
    'cat': 'Şiir',
    'image': 'assets/images/9.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/nOu8LDGX/08%20arti%20eksi.mp3'
  },
  {
    'title': 'Yine Yalnızım',
    'cat': 'Şiir',
    'image': 'assets/images/10.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/rRu9z04n/09%20yine%20yalnizlik.mp3'
  },
  {
    'title': 'Tut ki',
    'cat': 'Şiir',
    'image': 'assets/images/11.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/4guyXO6N/10%20tut%20ki.mp3'
  },
  {
    'title': 'Desem ki',
    'cat': 'Şiir',
    'image': 'assets/images/12.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/04uPvN7J/11%20desem%20ki.mp3'
  },
];

List myList2 = [
  {
    'title': 'Bebeğim2',
    'cat': 'Şiir',
    'image': 'assets/images/12.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/Jrubp4LA/01%20Bebegim.mp3'
  },
  {
    'title': 'Gitsen Benden2',
    'cat': 'Şiir',
    'image': 'assets/images/11.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/eDu6rj15/02%20Gitsen%20Benden.mp3'
  },
  {
    'title': 'Zaman2',
    'cat': 'Şiir',
    'image': 'assets/images/10.jpg',
    'body': '',
    'url': 'https://p27.f0.n0.cdn.getcloudapp.com/items/rRu9gGlx/03%20Zaman.mp3'
  },
  {
    'title': 'Bu Şehir',
    'cat': 'Şiir',
    'image': 'assets/images/9.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/kpuLAn49/04%20Bu%20Sehir.mp3'
  },
  {
    'title': 'Babaya Özlem',
    'cat': 'Şiir',
    'image': 'assets/images/8.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/jkulRenq/12%20babaya%20ozlem.mp3'
  },
  {
    'title': 'Sevgiye Son',
    'cat': 'Şiir',
    'image': 'assets/images/7.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/04uPvNXZ/05%20sevgiye%20son.mp3'
  },
  {
    'title': 'Hoşçakal',
    'cat': 'Şiir',
    'image': 'assets/images/6.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/p9u7Zrq2/06%20Hoscakal.mp3'
  },
  {
    'title': 'Sana Değil',
    'cat': 'Şiir',
    'image': 'assets/images/5.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/jkulRY5e/07%20Sana%20degil.mp3'
  },
  {
    'title': 'Artı Eksi',
    'cat': 'Şiir',
    'image': 'assets/images/4.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/nOu8LDGX/08%20arti%20eksi.mp3'
  },
  {
    'title': 'Yine Yalnızım',
    'cat': 'Şiir',
    'image': 'assets/images/3.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/rRu9z04n/09%20yine%20yalnizlik.mp3'
  },
  {
    'title': 'Tut ki',
    'cat': 'Şiir',
    'image': 'assets/images/2.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/4guyXO6N/10%20tut%20ki.mp3'
  },
  {
    'title': 'Desem ki',
    'cat': 'Şiir',
    'image': 'assets/images/1.jpg',
    'body': '',
    'url':
        'https://p27.f0.n0.cdn.getcloudapp.com/items/04uPvN7J/11%20desem%20ki.mp3'
  },
];
