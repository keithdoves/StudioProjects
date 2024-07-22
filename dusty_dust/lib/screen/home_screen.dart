import 'package:dusty_dust/component/category_stat.dart';
import 'package:dusty_dust/component/hourly_stat.dart';
import 'package:dusty_dust/component/main_stat.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:dusty_dust/utils/status_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import '../model/stat_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Region region = Region.seoul;
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    StatRepository.fetchData();
    scrollController.addListener(() {
      //kToolbarHeight 기본 앱바 높이
      bool isExpanded = scrollController.offset < (500 - kToolbarHeight);

      if(isExpanded != this.isExpanded){
        setState(() {
          this.isExpanded = isExpanded;
        });
      }

    });


    //getCount();
  }
/*
  getCount() async {
    print('HomeScreen : ${await GetIt.I<Isar>().statModels.count()}');
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatModel?>(
        future: GetIt.I<Isar>()
            .statModels
            .filter()
            .regionEqualTo(region)
            .itemCodeEqualTo(ItemCode.PM10)
            .sortByDateTimeDesc()
            .findFirst(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final statModel = snapshot.data!;
          final statusModel =
              StatusUtils.getStatusModelFromStat(statModel: statModel);

          return Scaffold(
            drawer: Drawer(
              backgroundColor: statusModel.darkColor,
              child: ListView(
                //listTile - 새로로 한 칸씩 차지하도록 함
                //누를 수 있도록 할 수 있음
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.zero,
                    child: Text(
                      '지역 선택',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  ...Region.values
                      .map(
                        (e) => ListTile(
                          selected: e == region,
                          tileColor: Colors.white,
                          selectedTileColor: statusModel.lightColor,
                          selectedColor: Colors.black,
                          onTap: () {
                            setState(() {
                              region = e; //누른게 들어감
                            });
                          },
                          title: Text(
                            e.krName,
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            /*appBar: AppBar(
              backgroundColor: statusModel.primaryColor,
              surfaceTintColor: statusModel.primaryColor, //스크롤하면 앱바 색이 변하기 때문에
            ),*/
            backgroundColor: statusModel.primaryColor,
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                MainStat(region: region,
                primaryColor: statusModel.primaryColor,
                isExpanded: isExpanded,),
                SliverToBoxAdapter( //sliver 안에 위젯을 넣으려면 박스로 감싸야함
                  child: Column(
                    children: [

                      CategoryStat(
                        region: region,
                        darkColor: statusModel.darkColor,
                        lightColor: statusModel.lightColor,
                      ),
                      HourlyStat(
                        darkColor: statusModel.darkColor,
                        lightColor: statusModel.lightColor,
                        region: region,
                      ),
                    ],
                  ),
                )
              ],
            ),

            /*FutureBuilder<List<StatModel>>(
                  future: StatRepository.fetchDataByItemCode(
                      itemCode: ItemCode.PM10),
                  builder: (context, snapshot) {} return*/
            //print(snapshot.error);
            //print(snapshot.stackTrace);
            //print(snapshot.data);
          );
        });
  }
}
