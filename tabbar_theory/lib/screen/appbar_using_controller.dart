
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../const/tabs.dart';

class AppbarUsingController extends StatefulWidget {
  const AppbarUsingController({super.key});

  @override
  State<AppbarUsingController> createState() => _AppbarUsingControllerState();
}

class _AppbarUsingControllerState extends State<AppbarUsingController>
    with TickerProviderStateMixin {
  //with TickerProviderStateMixin
  //실제 한 프레임 당 틱이 움직이는 것을 효율적으로 해줌.
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: TABS.length,
      vsync: this, //TickerProviderStateMixin를 with로 등록했기 때문에 this 가능
    );
    tabController.addListener((){
      setState(() {

      });
    });
    //addListener : tabController의 상태가 변경 될 때마다 콜백함수 실행
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Using Controller'),
        bottom: TabBar(
          controller: tabController,
          tabs: TABS
              .map(
                (e) => Tab(
                  icon: Icon(e.icon),
                  child: Text(e.label),
                ),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: TABS
            .map(
              (e) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    e.icon,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(tabController.index !=0)
                      ElevatedButton(
                        onPressed: () {
                          tabController.animateTo(
                            //애니메이션을 이용하여 ~로 이동
                            tabController.index - 1, //인덱스값
                          );
                        },
                        child: Text('이전'),
                      ),
                      SizedBox(
                        width: 16.5,
                      ),
                      if(tabController.index != TABS.length -1)
                      ElevatedButton(
                        onPressed: () {
                          tabController.animateTo(
                            //애니메이션을 이용하여 ~로 이동
                            tabController.index + 1, //인덱스값
                          );
                        },
                        child: Text('다음'),
                      ),
                    ],
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
