import 'package:dio/dio.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class StatRepository {

  static Future<void> fetchData()async{
    final isar = GetIt.I<Isar>();
    final now = DateTime.now();
    final compareDateTimeTarget = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
    );

    final count = await isar.statModels.filter()
    .dateTimeEqualTo(compareDateTimeTarget)
    .count();
    print('count: $count');
    if(count>0){
      print('데이터가 이미 존재합니다 : count: $count');
      return;
    }

    for(ItemCode itemCode in ItemCode.values){
      await fetchDataByItemCode(itemCode: itemCode);

    }

  }

  static Future<List<StatModel>> fetchDataByItemCode({
    required ItemCode itemCode,
  }) async {
    //final itemCodeStr = itemCode == ItemCode.PM25 ? 'PM2.5' : itemCode.name;

    final response = await Dio().get(
      'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
      queryParameters: {
        'serviceKey':
            'Y+UdOARJ9z3LQ/KPqm21ZCMyMWcfUwzH2DX6xLhMeiPKb40a4kFB9pH5//X/s/FaFZ6iV7kyCpyswuBmSWxoWA==',
        'returnType': 'json',
        'numOfRows': 100,
        'pageNo': 1,
        'itemCode': itemCode.name,
        'dataGubun': 'HOUR',
        'searchCondition': 'WEEK',
      },
    );
    //print('response.data :: ${response.data}');
    //print(response.data['response']['body']['items']);

    final rawItemsList = response.data['response']['body']['items'];

    List<StatModel> stats = [];

    final List<String> skipKeys = [
      'dataGubun',
      'dataTime',
      'itemCode',
    ];

    for (Map<String, dynamic> item in rawItemsList) {
      final dateTime = DateTime.parse(item['dataTime']);

      for (String key in item.keys) {
        if (skipKeys.contains(key)) {
          continue;
        }

        final regionStr = key;
        final stat = double.parse(item[regionStr]);
        final region = Region.values.firstWhere((e) => e.name == regionStr);

        //값 넣어주기
        final statModel = StatModel()
          ..region = region
          ..stat = stat
          ..dateTime = dateTime
          ..itemCode = itemCode;

        final isar = GetIt.I<Isar>();
        final count = await isar.statModels
            .filter()
            .regionEqualTo(region)
            .dateTimeEqualTo(dateTime)
            .itemCodeEqualTo(itemCode)
            .count();

        //print('----------');
        //print(count);

        if(count > 0){
          continue;
          //중복이 있으면 저장 안 함.
          //다음 뤂 돌림.
        }
        //디비에 write
        await isar.writeTxn(() async {
          await isar.statModels.put(statModel);
        }
        );

        /* stats = [
          ...stats,
          StatModel(
            //Region.value(리스트로 값을 다 가지고 옴)
            //key: daegu ->Region.daegu
            //e = Region.seoul - e.name = 'seoul'
            region: Region.values.firstWhere((e) => e.name == regionStr),
            stat: double.parse(stat), //더블로 변환
            dateTime: DateTime.parse(dateTime),
            itemCode: itemCode,
          ),
        ];*/
        //print('stats::$stats');
      }
    }

    return stats; //.data 를 붙여야 body를 받을 수 있음
  }
}
