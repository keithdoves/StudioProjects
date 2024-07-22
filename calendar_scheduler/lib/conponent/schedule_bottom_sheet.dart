import 'package:calendar_scheduler/conponent/custom_text_field.dart';
import 'package:drift/drift.dart'
    hide Column; //drift에서 Column 클래스를 가져오지 않음(중복에러처리)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../const/colors.dart';
import '../database/drift.dart';
import '../model/schedule.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final int? id;
  final DateTime selectedDay;

  const ScheduleBottomSheet({
                required this.selectedDay,
                this.id,
                Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

   int? selectedColorId;

  @override
  void initState() {
    super.initState();
    initCategory();
  }

  initCategory() async {
    if(widget.id != null){
      final resp = await GetIt.I<AppDatabase>().getScheduleById(widget.id!);

      setState(() {
        selectedColorId = resp.category.id;
      });
    }else{
      final resp = await GetIt.I<AppDatabase>().getCategories();

      setState(() {
        selectedColorId = resp.first.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(selectedColorId==null){
      return Container();
    }

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    //viewInsets : 시스템 UI가 화면을 가린 사이즈(여기서는 키보드)
    return FutureBuilder(
        future: widget.id == null
            ? null
            : GetIt.I<AppDatabase>().getScheduleById(widget.id!),
        builder: (context, snapshot) {
          if (widget.id != null &&
              snapshot.connectionState == ConnectionState.waiting
          &&!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.schedule;
          final hasData = snapshot.hasData;

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode()); //
              //FocusNode() : 실제 텍스트 필드에 연결을 시켜주면 포커스를 거기로 옮길 수 있음
              //지금은 아무 것도 연결이 안되어 있어서 포커스를 잃음 == 키보드가 내려감
              //외 우 기
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 2 + bottomInset,
              color: Colors.white,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 16.0,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            onStartSaved: onStartTimeSaved,
                            onEndSaved: onEndTimeSaved,
                            onStartValidate: onStartTimeValidate,
                            onEndValidate: onEndTimeValidate,
                            startTimeInitValue:
                                hasData ? data!.startTime.toString() : null,
                            endTimeInitValue: data?.endTime.toString(),
                          ),
                          SizedBox(height: 16.0),
                          Expanded(
                            child: _Content(
                              onSaved: onContentSaved,
                              onValidate: onContentValidate,
                              initValue: data?.content,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          _Categories(
                            selectedColor: selectedColorId!,
                            onTap: (int colour) {
                              setState(() {
                                selectedColorId = colour;
                              });
                            }, //"String을 받고 Void를 리턴하는 함수"
                          ),
                          SizedBox(height: 8.0),
                          _SaveButton(
                            onPressed: onSavePressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  //부모에서 정의되는 함수에서 값을 받아올 수 있어야 voidcallback을 사용할 수 있음
  //지금까지는 부모의 함수 안에서 값을 스스로 받아올 수 있었음

  void onStartTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    startTime = int.parse(val);
  }

  String? onStartTimeValidate(String? val) {
    if (val == null) {
      return '시작시간을 입력해주세요';
    }
    if (int.tryParse(val) == null) {
      //tryParse : 숫자로 변환할 수 없는 문자열이면 null을 반환
      return '숫자를 입력해주세요'; //parse : 숫자로 변환할 수 없는 문자열이면 에러를 반환
    }

    final time = int.parse(val);
    if (time < 0 || time > 24) {
      return '0~24 사이의 숫자를 입력해주세요';
    }
    return null;
  }

  void onEndTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    endTime = int.parse(val);
  }

  String? onEndTimeValidate(String? val) {
    if (val == null) {
      return '마감시간을 입력해주세요';
    }
    if (int.tryParse(val) == null) {
      return '숫자를 입력해주세요';
    }

    final time = int.parse(val);
    if (time < 0 || time > 24) {
      return '0~24 사이의 숫자를 입력해주세요';
    }
    return null;
  }

  void onContentSaved(String? val) {
    if (val == null) {
      return;
    }
    content = val;
  }

  String? onContentValidate(String? val) {
    if (val == null) {
      return '내용을 입력해주세요';
    }

    if (val.length < 5) {
      return '5자 이상 입력해주세요';
    }
    return null; //null을 리턴하면 에러가 없다는 뜻
  }

  void onSavePressed() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      final database = GetIt.I<AppDatabase>();
      //main.dart에 정의해놓은 GetIt.I<AppDatabase>를 가져옴
      //데이터를 들고 있다가 위 코드를 작성한 곳에 제공해줌.

      if(widget.id == null){
        await database.createSchedule(ScheduleTableCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedDay),
          colorId: Value(selectedColorId!),
        ));

      }else{
        await database.updateScheduleById(
           widget.id!,
            ScheduleTableCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedDay),
          colorId: Value(selectedColorId!),
        ));


      }



      //객체 생성하여 데이터 담기
      /*ScheduleTable schedule = ScheduleTable(
        id: 999,
        startTime: startTime!,
        endTime: endTime!,
        content: content!,
        date: widget.selectedDay,
        color: selectedColor,
        createdAt: DateTime.now().toUtc(),
      );*/

      Navigator.of(context).pop();
      //pop으로 안넘겨줌. 거기서 바로 database로 불러올 수 있음.
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;
  final String? startTimeInitValue;
  final String? endTimeInitValue;

  const _Time(
      {required this.onStartSaved,
      required this.onEndSaved,
      required this.onStartValidate,
      required this.onEndValidate,
      this.startTimeInitValue,
      this.endTimeInitValue,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: CustomTextField(
              label: '시작시간',
              onSaved: onStartSaved,
              validator: onStartValidate,
              initialValue: startTimeInitValue,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: CustomTextField(
              label: '마감시간',
              onSaved: onEndSaved,
              validator: onEndValidate,
              initialValue: endTimeInitValue,
            ),
          ),
        ]),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidate;
  final String? initValue;

  _Content(
      {required this.onSaved,
      required this.onValidate,
      this.initValue,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: '내용',
      expand: true,
      onSaved: onSaved,
      validator: onValidate,
        initialValue : initValue,
    );
  }
}

typedef OnColorSelected = void Function(int color);
//어떤 색을 클릭했는지 받기위해!
//alias로 OnColorSelected를 만들어서, int color를 받는 함수를 만듦
//"String을 받고 Void를 리턴하는 함수"

class _Categories extends StatelessWidget {
  final int selectedColor;
  final OnColorSelected onTap; //정의를 받아 옴(위에서 정의한 함수)
  //파라미터로 "String을 받고 Void를 리턴하는 함수"가 와야 함.

  const _Categories({
    required this.selectedColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<AppDatabase>().getCategories(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Container();
        }
        return Wrap(
          spacing: 8.0, //좌우 간격
          runSpacing: 7.0, //위아래 간격
          // Wrap은 Row와 달리, 자동 줄바꿈이 된다.
          children: snapshot.data!
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    onTap(e.id);
                  } //파라미터를 받기 때문에 함수 안에 넣음
                  ,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                        'FF${e.color}',
                        radix: 16,
                      )),
                      border: e.id == selectedColor
                          ? Border.all(
                              color: Colors.black,
                              width: 4.0,
                            )
                          : null,
                      shape: BoxShape.circle,
                    ),
                    width: 32.0,
                    height: 32.0,
                  ),
                ),
              )
              .toList(),
        );
      }
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            //버튼이 좌우로 다 차지하기 만드는 법 : Row로 감싼 후,
            // children 요소를 Expanded로 감싸기
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
