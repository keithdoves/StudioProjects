import 'dart:convert';

import 'package:codefactory_lvl2_flutter/common/const/data.dart';
import 'package:dio/dio.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  //listPathsUrls에 List<String>을 넣으면 캐스팅 오류남
  //받아온 데이터를 일단 dynamic으로 생각하는듯
  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }

  static DateTime stringToDateTime(String value){
    return DateTime.parse(value);
  }
}
