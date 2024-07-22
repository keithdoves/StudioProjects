import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool expand;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final String? initialValue;

  const CustomTextField(
      {required this.label,
      required this.onSaved,
      required this.validator,
      this.initialValue,
      this.expand = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (!expand) renderTextFormField(),
        if (expand)
          Expanded(
            child: renderTextFormField(),
          )
      ],
    );
  }

  renderTextFormField() {
    //TextFomrField를 가로로 늘리기
    //Expanded 위젯에 넣고, 위젯 내에서 expands: true로 설정
    //maxLines, minLines를 추가로 설정(미설정 시, 에러남)

    return TextFormField(
      cursorColor: Colors.grey[500],
      //keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: InputBorder.none,
        //labelText: '일정을 입력하세요',
        filled: true,
        fillColor: Colors.grey[300],
      ),
      keyboardType: !expand ? TextInputType.number : TextInputType.multiline,
      inputFormatters: !expand ? [
         FilteringTextInputFormatter.digitsOnly
      ]: []
      ,
      onSaved: onSaved,
      validator: validator,
      //검증할 때 로직
      expands: expand,
      //expand가 true일 때, TextFormField가 확장됨.
      maxLines: expand ? null : 1,
      //최대줄 수 / null은 무한
      minLines: expand ? null : 1,
      initialValue: initialValue,
    );
  }
}
