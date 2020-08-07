import 'package:flutter_publitio/flutter_publitio.dart';

class PublitioProvider {
  static const PUBLITIO_PREFIX = "https://media.publit.io/file";

  static configurePublitio() async {
    await FlutterPublitio.configure('QzWG6xZdAcL9Z9igcGWA', 'SxtaWjneTr6QeN8Bhs1yB7NmMtSZWxsi');
  }

  static getAspectRatio(response) {
    final width = response["width"];
    final height = response["height"];
    final double aspectRatio = width / height;
    return aspectRatio;
  }

  static getCoverUrl(response) {
    final publicId = response["public_id"];
    return "$PUBLITIO_PREFIX/$publicId.jpg";
  }

  static uploadVideo(imagen) async {
    print('starting upload');
    final uploadOptions = {
      "privacy": "1",
      "option_download": "1",
      "option_transform": "1"
    };
    final response =
        await FlutterPublitio.uploadFile( imagen.path, uploadOptions);

    print(response);
    return response["url_preview"];
  }
}