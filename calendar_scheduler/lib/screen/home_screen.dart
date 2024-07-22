import 'package:calendar_scheduler/conponent/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/conponent/schedule_card.dart';
import 'package:calendar_scheduler/conponent/today_banner.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/model/schedule_with_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../conponent/calendar.dart';
import '../const/colors.dart';
import '../model/schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  /*Map<DateTime, List<ScheduleTable>> schedules = {
    DateTime.utc(2024, 4, 8): [
      ScheduleTable(
        id: 1,
        startTime: 11,
        endTime: 12,
        content: '플러터 공부하기',
        color: categoryColors.first,
        date: DateTime.utc(2024, 3, 8),
        createdAt: DateTime.now().toUtc(),
      ),
      ScheduleTable(
        id: 1,
        startTime: 12,
        endTime: 13,
        content: 'NestJS 공부하기',
        color: categoryColors[3],
        date: DateTime.utc(2024, 3, 8),
        createdAt: DateTime.now().toUtc(),
      ),
    ],
  };*/

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              onDaySelected: onDaySelected,
              selectedDay: selectedDay,
              focusedDay: focusedDay,
            ),
            SizedBox(height: 8.0),
            StreamBuilder(

              //배너에 갯수를 보이게 해야 하는데.. 딱히 받아올 수 있는 곳이 없음
              //위젯을 스트림빌더로 감싼 후 데이터 받아옴.
                stream: GetIt.I<AppDatabase>().streamSchedules(selectedDay),
                builder: (context, snapshot) {
                return TodayBanner(
                  selectedDay: selectedDay,
                  scheduleCount: !snapshot.hasData ? 0 : snapshot.data!.length,
                );
              }
            ),
            SizedBox(height: 8.0),
            Expanded(
              //감싸지 않으면 ListView가 차지할 공간을 몰라서 에러남.
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: StreamBuilder<List<ScheduleWithCategory>>(
                    stream: GetIt.I<AppDatabase>().streamSchedules(selectedDay),
                    //future나 상위 builder가 상태가 바뀌어야 리랜더링됨.
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              '데이터를 불러오는 중에 오류가 발생했습니다. ${snapshot.error.toString()}'),
                        );
                      }
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final schedules = snapshot.data!;
                      /*final selectedSchedules = schedules
                          .where((e) => e.date.isAtSameMomentAs(selectedDay))
                          .toList();*/ //전체를 갖고와서 프론트에서 필터링하는 것은 비효율적임.

                      return ListView.separated(
                          // 리스트뷰는 한번에 모든 아이템을 불러오기 때문에, 데이터가 많을 때는 사용하지 않는 것이 좋음.
                          // 리스트뷰.builder or .seperated는 스크롤을 내릴 때마다 아이템을 불러오기 때문에 효율적임.
                          itemCount: schedules.length,
                          itemBuilder: (BuildContext context, int index) {
                            //선택된 날짜에 해당되는 일정 리스트로 저장
                            /*final selectedSchedules = schedules[selectedDay]!;
                          //itemCount가 0이면 itemBuilder가 실행되지 않음.
                          final scheduleModel = selectedSchedules[index];*/

                            final scheduleWithCategory = schedules[index];
                            final schedule = scheduleWithCategory.schedule;
                            final category = scheduleWithCategory.category;

                            return Dismissible(
                              key: ObjectKey(schedule.id),
                              //Objectkey() : 고유한 키를 생성해줌.
                              direction: DismissDirection.endToStart,
                              /*confirmDismiss: (DismissDirection direction) async {
                                await GetIt.I<AppDatabase>().removeSchedule(schedule.id); //1. 삭제후
                                //setState(() {}); //2. 상태를 변경한 후
                                //()
                                return true; //3 삭제 확인 시그널은 Dismissible에 줌
                              },*/

                              onDismissed: (DismissDirection direction) {
                                GetIt.I<AppDatabase>().removeSchedule(
                                  schedule.id, //Stream은 onDismissed 사용가능
                                  //삭제되자마자 다시 StreamBuilder가 다시 빌드되기 때문
                                );
                              },
                              /*
                                //그냥 이 코드만으로 삭제를 구현하면 에러가 남.
                                //문제1)삭제는 했으나, 상태가 변하지 않아 과거 데이터의 schedule이 남아있음.
                                /Future : 한번만 데이터 반환 -> 데이터가 변할 때 상태변경을 알려줘야 함.
                                /Stream : 데이터가 변할 때마다 데이터를 반환 -> 데이터가 변할 때마다 리랜더링이 필요할 때 사용.
                                //Futurebuilder나 builder의 상태가 변해야 함.



                                setState(() {});
                                //문제2) onDismissed는 이미 사라진 후에 실행되기 때문에
                                //setState가 onDismissed에 있으면 메모리에 없는 위젯의 상태를
                                //업데이트 하려고 시도하기 때문에 에러가 남.

                                //Flutter에서는 위젯이 화면에서 완전히 제거되면 그 위젯의 상태(state)도 메모리에서 해제됩니다.
                                 만약 해제된 상태의 위젯에 대해 setState()를 호출하면,
                                 Flutter는 해당 위젯이 더 이상 유효하지 않다는 것을 감지하고 오류를 발생시킵니다.


                              */
                              child: GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet<ScheduleWithCategory>(
                                    context: context,
                                    isScrollControlled: true,
                                    //bottomsheet 기본값은 화면의 반까지만 차지하는 것이기 때문에, 전체 화면을 차지하도록 설정.
                                    builder: (_) => ScheduleBottomSheet(
                                      selectedDay: selectedDay,
                                      id : schedule.id,
                                    ),
                                  );
                                },
                                child: ScheduleCard(
                                    startTime: schedule.startTime,
                                    endTime: schedule.endTime,
                                    content: schedule.content,
                                    color: Color(int.parse(
                                      'FF${category.color}',
                                      radix: 16,
                                    ))),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 8.0);
                          });
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        //dialog는 가운데 뜨고,
        //cupertinoAlertDialog는 아래에서 위로 올라옴.
        //bottomSheet는 아래에서 위로 올라옴.
        await showModalBottomSheet<ScheduleWithCategory>(
          context: context,
          isScrollControlled: true,
          //bottomsheet 기본값은 화면의 반까지만 차지하는 것이기 때문에, 전체 화면을 차지하도록 설정.
          builder: (_) => ScheduleBottomSheet(
            selectedDay: selectedDay,
          ),
        );

        /* setState(() {
             //bottomsheet 상태가 변경되었음을 알림.
        });*/
        //그러나 StreamBuilder가 있기 때문에 setState를 사용하지 않아도 됨.
        //future와 달리 StreamBuilder는 데이터가 들어올 때마다 자동으로 리랜더링됨.

        /* setState((){
          //방법1
          schedules = {
            ...schedules, //원래 존재하는 스케쥴을 넣음
            schedule.date: [ //bottomsheet로부터 반환받은 스케쥴의 날짜를 키로 잡고, 리스트로 만듦
              if(schedules.containsKey(schedule.date)) //기존에 그 날짜에 값이 있으면 먼저 넣어줌
                 ...schedules[schedule.date]!,
              schedule, //받은 스케쥴을 넣음.
            ]
          };
          //방법2
         */ /* final dateExists = schedules.containsKey(schedule.date!); //선택날에 데이터가 있냐
          final List<Schedule> existingSchedules = dateExists ? schedules[schedule.date!]! : []; //있으면 그 데이터를 넣고, 없으면 빈 리스트를 넣음
          existingSchedules.add(schedule);

          schedules = {
            ...schedules,
            schedule.date!: existingSchedules,
          };
          */ /*
        });*/
      }, //onPressed
      backgroundColor: PRIMARY_COLOR,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(
      () {
        this.selectedDay = selectedDay;
        this.focusedDay = selectedDay;
      },
    );
  }
}
