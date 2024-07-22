import 'package:dusty_dust/model/stat_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../utils/status_utils.dart';

class HourlyStat extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final Region region;

  HourlyStat(
      {required this.region,
      required this.darkColor,
      required this.lightColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ItemCode.values
          .map((itemCode) => FutureBuilder<List<StatModel>>(
              future: GetIt.I<Isar>()
                  .statModels
                  .filter()
                  .regionEqualTo(region)
                  .itemCodeEqualTo(itemCode)
                  .sortByDateTimeDesc()
                  .limit(24) //24개 제한
                  .findAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }
                final stats = snapshot.data!;

                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: lightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.0),
                                topLeft: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '시간별 ${itemCode.krName}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          //map이 아니면 list에 ...을 통해 리스트를 풀어줘야 함
                          ...stats.map(
                            (stat) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 4.0,
                              ),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    '${stat.dateTime.hour.toString().padLeft(2, '0')}시',
                                  ),
                                ),
                                Expanded(
                                  child: Image.asset(
                                    StatusUtils.getStatusModelFromStat(
                                            statModel: stat)
                                        .imagePath,
                                    height: 20.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    StatusUtils.getStatusModelFromStat(
                                            statModel: stat)
                                        .label,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }))
          .toList(),
    );
  }
}
