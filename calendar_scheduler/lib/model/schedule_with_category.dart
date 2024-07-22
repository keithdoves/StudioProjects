import 'package:calendar_scheduler/model/schedule.dart';
import '../database/drift.dart';
import 'category.dart';

class ScheduleWithCategory {
  final CategoryTableData category;
  final ScheduleTableData schedule;



  ScheduleWithCategory({
    required this.category,
    required this.schedule,
});



}