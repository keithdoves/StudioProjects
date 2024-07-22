/*
"daegu" "chungnam" "incheon" "daejeon" "gyeongbuk" "sejong" "gwangju" "jeonbuk"
"gangwon" "ulsan" "jeonnam" "seoul" "busan" "jeju" "chungbuk" "gyeongnam" "gyeonggi"
"itemCode": "PM10",
"dataTime": "2024-05-09 15:00",
"dataGubun": "1",
*/

import 'package:isar/isar.dart';
part 'stat_model.g.dart'; //코드 제너레이터로 코드 생성하기

enum Region {
  daegu,
  chungnam,
  incheon,
  daejeon,
  gyeongbuk,
  sejong,
  gwangju,
  jeonbuk,
  gangwon,
  ulsan,
  jeonnam,
  seoul,
  busan,
  jeju,
  chungbuk,
  gyeongnam,
  gyeonggi;

  String get krName {
    switch (this) {
      case Region.daegu:
        return '대구';
      case Region.chungnam:
        return '충남';
      case Region.incheon:
        return '인천';
      case Region.daejeon:
        return '대전';
      case Region.gyeongbuk:
        return '경북';
      case Region.sejong:
        return '세종';
      case Region.gwangju:
        return '광주';
      case Region.jeonbuk:
        return '전북';
      case Region.gangwon:
        return '강원';
      case Region.ulsan:
        return '울산';
      case Region.jeonnam:
        return '전남';
      case Region.seoul:
        return '서울';
      case Region.busan:
        return '부산';
      case Region.jeju:
        return '제주';
      case Region.chungbuk:
        return '충북';
      case Region.gyeongnam:
        return '경남';
      case Region.gyeonggi:
        return '경기';
      default:
        throw Exception('존재하지 않는 지역 이름입니다.');
    } // end of switch
  } // end of get
}

enum ItemCode{
  SO2,
  CO,
  O3,
  NO2,
  PM10,
  PM25;

  String get krName {
    switch(this){
      case ItemCode.SO2:
        return '이황산가스';
      case ItemCode.CO:
        return  '일산화탄소';
      case ItemCode.O3:
        return '오존';
      case ItemCode.NO2:
        return '이산화질소';
      case ItemCode.PM10:
        return '미세먼지';
      case ItemCode.PM25:
        return '초미세먼지';
    }

  }
}

@collection //Isar는 model에 collection 어노테이션 필요
class StatModel {
  //모든 collection은 id가 필요함
  Id id = Isar.autoIncrement;
  //데이터를 넣을 때 마다 자동으로 id가 1씩 증가

  //지역
  @enumerated //enum은 enumerated 어노테이션 필요
  @Index(unique: true, composite: [ //composite를 추가하면 복합 유니크키가 됨
    CompositeIndex('dateTime'),
    CompositeIndex('itemCode'),
  ]) //유니크키 구현
  late Region region;

  //통계 값
  late double stat;
  late DateTime dateTime;

  // 미세먼지 / 초미세먼지
  @enumerated
  late ItemCode itemCode;

}
