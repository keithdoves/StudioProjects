import 'package:codefactory_lvl2_flutter/common/const/data.dart';

class DataUtils{

  static String pathToUrl(String value){
    return 'http://$ip$value';
  }
  //listPathsUrls에 List<String>을 넣으면 캐스팅 오류남
  //받아온 데이터를 일단 dynamic으로 생각하는듯
  static List<String> listPathsToUrls(List paths){
    return paths.map((e)=> pathToUrl(e)).toList();
  }
}