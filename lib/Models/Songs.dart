// To parse this JSON data, do
//
//     final songs = songsFromJson(jsonString);

import 'dart:convert';

Songs songsFromJson(String str) => Songs.fromJson(json.decode(str));

String songsToJson(Songs data) => json.encode(data.toJson());

class Songs {
  int id;
  String title;
  Category category;
  String image;
  dynamic body;
  Seslendiren seslendiren;
  Seslendiren yazar;
  Album album;
  String url;

  Songs({
    this.id,
    this.title,
    this.category,
    this.image,
    this.body,
    this.seslendiren,
    this.yazar,
    this.album,
    this.url,
  });

  factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        id: json["id"],
        title: json["title"],
        category: Category.fromJson(json["category"]),
        image: json["image"],
        body: json["body"],
        seslendiren: Seslendiren.fromJson(json["seslendiren"]),
        yazar: Seslendiren.fromJson(json["yazar"]),
        album: Album.fromJson(json["album"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category.toJson(),
        "image": image,
        "body": body,
        "seslendiren": seslendiren.toJson(),
        "yazar": yazar.toJson(),
        "album": album.toJson(),
        "url": url,
      };
}

class Album {
  int id;
  String title;
  String image;

  Album({
    this.id,
    this.title,
    this.image,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"],
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}

class Category {
  int id;
  String name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Seslendiren {
  int id;
  String name;
  dynamic image;

  Seslendiren({
    this.id,
    this.name,
    this.image,
  });

  factory Seslendiren.fromJson(Map<String, dynamic> json) => Seslendiren(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
