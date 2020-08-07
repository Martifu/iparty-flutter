import 'dart:convert';

PlaceModel placeModelFromJson(String str) => PlaceModel.fromJson(json.decode(str));

String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class Place {

    List<PlaceModel> items = new List();

    Place();  

    Place.fromJsonList(List<dynamic> jsonList){
      if (jsonList==null) return;

      for (var item in jsonList) {
        final place = new PlaceModel.fromJson(item);
        items.add(place); 
      }
    }

}

class PlaceModel {
    String name;
    String image;
    String info1;
    String info2;
    String infoPlace;
    List<Comment> comments;

    PlaceModel({
        this.name,
        this.image,
        this.info1,
        this.info2,
        this.infoPlace,
        this.comments,
    });

    factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        name: json["name"],
        image: json["image"],
        info1: json["info1"],
        info2: json["info2"],
        infoPlace: json["info_place"],
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "info1": info1,
        "info2": info2,
        "info_place": infoPlace,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    };

    
}

class Comment {
    User user;
    Image image;
    String comment;

    Comment({
        this.user,
        this.image,
        this.comment,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        user: userValues.map[json["user"]],
        image: imageValues.map[json["image"]],
        comment: json["comment"],
    );

    Map<String, dynamic> toJson() => {
        "user": userValues.reverse[user],
        "image": imageValues.reverse[image],
        "comment": comment,
    };
}

enum Image { ASSETS_IMAGES_MARTIN_JPG, ASSETS_IMAGES_MONSERRAT_JPG }

final imageValues = EnumValues({
    "assets/images/martin.jpg": Image.ASSETS_IMAGES_MARTIN_JPG,
    "assets/images/monserrat.jpg": Image.ASSETS_IMAGES_MONSERRAT_JPG
});

enum User { MARTN_ESPARZA, MONSERRAT_LEN }

final userValues = EnumValues({
    "Martín Esparza": User.MARTN_ESPARZA,
    "Monserrat León": User.MONSERRAT_LEN
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
