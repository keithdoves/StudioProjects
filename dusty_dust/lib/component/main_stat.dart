import 'package:dusty_dust/const/color.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../const/status_level.dart';
import '../model/stat_model.dart';
import '../utils/date_utils.dart';
import '../utils/status_utils.dart';

class MainStat extends StatelessWidget {
  final Color primaryColor;
  final Region region;
  final bool isExpanded;

  final ts = TextStyle(
    color: Colors.white,
    fontSize: 40.0,

  );

  MainStat({
    required this.primaryColor,
    required this.region,
    required this.isExpanded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: primaryColor,
      expandedHeight: 500,
      pinned: true,
      title: isExpanded ? null : Text('${region.krName}'),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          //컬럼을 가운데 정렬 시키기 위해 sizedbox로 감싼후 너비를 최대로 잡음
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<StatModel?>(
                future: GetIt
                    .I<Isar>()
                    .statModels
                    .filter()
                    .regionEqualTo(region)
                    .itemCodeEqualTo(ItemCode.PM10)
                    .sortByDateTimeDesc()
                    .findFirst(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('데이터가 없습니다',),
                    );
                  }
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final statModel = snapshot.data!;

                  final status = StatusUtils.getStatusModelFromStat(
                    statModel: statModel,
                  );



                  return Column(
                    children: [
                      const SizedBox(
                        height: kToolbarHeight,
                      ),
                      Text(
                        statModel.region.krName,
                        style: ts.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateUtils.dateTimeToString(dateTime: statModel.dateTime),
                        style: ts.copyWith(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Image.asset(
                        status.imagePath,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        status.label,
                        style: ts.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        status.comment,
                        style: ts.copyWith(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                }
            ),
          ),
        ),
      )
    );
  }
}
