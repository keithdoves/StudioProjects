import 'package:flutter/material.dart';

import '../const/status_level.dart';
import '../model/stat_model.dart';
import '../model/status_model.dart';

class StatusUtils {

  static StatusModel getStatusModelFromStat({
    required StatModel statModel,
  }) {
    final itemCode = statModel.itemCode;
    final index = statusLevels.indexWhere( //statusLevels의 index를 찾는다.
      (e) {
        switch (itemCode) {
          case ItemCode.PM10:
            return statModel.stat < e.minPM10;
          case ItemCode.PM25:
            return statModel.stat < e.minPM25;
          case ItemCode.CO:
            return statModel.stat < e.minCO;
          case ItemCode.NO2:
            return statModel.stat < e.MinNO2;
          case ItemCode.O3:
            return statModel.stat < e.minO3;
          case ItemCode.SO2:
            return statModel.stat < e.minSO2;
          default:
            throw Exception('존재하지 않는 아이템코드 입니다.');
        }
      },
    );
    if(index < 0) {
      return throw Exception('Index를 찾지 못했습니다!');;
    }
    return statusLevels[index - 1];;
  }
}
