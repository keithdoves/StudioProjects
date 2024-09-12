import 'package:codefactory_lvl2_flutter/common/const/colors.dart';
import 'package:codefactory_lvl2_flutter/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        //키보드를 켜면 화면을 덮어버린다.
        //해결책 - 화면이 스크롤 될 수 있도록 SingleChildScrollView로 감싸서
        //        화면이 스크롤되어 키보드 위로 갈 수 있도록 함.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        //onDrag : 드래그 하는 순간 키보드가 사라짐
        //manual : 키보드에서 done을 눌러야 키보드가 내려감.
        //드래그 한다는 것은 사실 UX에서 키보드를 내린다는 것이기 때문에 onDrag로 옵션을 주어 구현
        //cmd+shift+K로 키보드 켜서 Test 해보기
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {},
                  obscureText: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
