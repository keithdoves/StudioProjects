import 'package:flutter/material.dart';

import '../const/colours.dart';

class SingleChildScrollViewRender extends StatelessWidget {
  const SingleChildScrollViewRender({super.key});

  @override
  Widget build(BuildContext context) {
    final numbers = List.generate(100, (index) => index);
    return Scaffold(
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(

          children: <Widget>[
            Transform.translate(
              offset: Offset(0, -50),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  '이 빨간 박스는 위로 50px 튀어나와 있어요',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ...rainbowColors
                .map((e) => Container(
                      color: e,
                      height: 200,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
