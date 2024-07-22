import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool choolCheckDone = false;
  GoogleMapController? mapController;

  // latitude 위도 / longitude 경도
  static const LatLng companyLatLng = LatLng(
    37.4979,
    127.0276,
  );
  static const CameraPosition initalPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );
  static const double okDistance = 100;
  static final Circle withinDistanceCircle = Circle(
    circleId: const CircleId('circle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );

  static final Circle notWithinDistanceCircle = Circle(
    circleId: const CircleId('notWithinDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.yellow,
    strokeWidth: 1,
  );

  static final Circle checkDoneCircle = Circle(
    circleId: const CircleId('checkDoneCircle'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.purple,
    strokeWidth: 1,
  );

  static const Marker marker = Marker(
    markerId: MarkerId('company'),
    position: companyLatLng,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        //future를 리턴하는 함수를 넣을 수 있음_ future리턴에 따라 builder가 다시 호출됨
        //checkPermission()의 상태가 변경될 때마다 builder가 다시 호출됨
        //future는 비동기로 처리되기 때문에 빌더가 다시 호출되는 것을 허용함
        //future가 완료되면 snapshot을 받아서 빌더를 다시 호출함
        //snapshot은 future가 완료되면 future의 결과를 가지고 있음
        //snapshot은 future가 완료되지 않았다면 null을 가지고 있음
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //FutureBuilder는 future가 완료되지 않았을 때에도 빌더를 호출함
          //FutureBuilder는 context와 snapshot을 받음
          print('snapshot data : $snapshot.data');
          print('snapshot connectionState : ${snapshot.connectionState}');
          //go to definition을 눌러서 ConnectionState를 확인해보면 여러가지 상태가 있음
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              //상태가 waiting일 때는 로딩중임을 알려주는 위젯을 띄움
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == '위치 권한이 허가되었습니다') {
            return StreamBuilder(
                //stream에서 yield한 값을 받아서 빌더를 호출함
                //위치가 바뀔 때마다 stream이 yield하고, builder가 호출됨
                stream: Geolocator.getPositionStream(),
                //FutureBuilder와 다르게 streamBuilder는 stream을 받음
                // 그 이외에는 같음
                builder: (context, snapshot) {
                  bool isWithinRange = false;
                  if (snapshot.hasData) {
                    final start = snapshot.data!;
                    const end = companyLatLng;
                    final distance = Geolocator.distanceBetween(
                      start.latitude,
                      start.longitude,
                      end.latitude,
                      end.longitude,
                    );
                    if (distance < okDistance) {
                      isWithinRange = true;
                    }
                  }

                  print('snapshot data : ${snapshot.data}');
                  return Column(
                    children: [
                      _CustomGoogleMap(
                        initalPosition: initalPosition,
                        circle: choolCheckDone
                            ? checkDoneCircle
                            : isWithinRange
                                ? withinDistanceCircle
                                : notWithinDistanceCircle,
                        marker: marker,
                        onMapCreated: onMapCreated,
                      ),
                      _ChoolCheckButton(
                        isWithinRange: isWithinRange,
                        choolCheckDone: choolCheckDone,
                        onPressed: onChoolCheckPressed,
                      ),
                    ],
                  );
                });
          }

          return Center(
            child: Text(
              snapshot.data,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  onMapCreated(GoogleMapController controller) {
    //setState를 이용해서 화면 UI를 다시 그릴 필요가 없음
    mapController = controller;
  }

  onChoolCheckPressed() async {
    final result = await showDialog(
        //현재 앱 콘텐츠 위에 다이얼로그 박스 띄움
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //alterDialog 위젯을 반환
            title: const Text('출근하기'), //제목
            content: const Text('출근하시겠습니까?'), //내용
            actions: [
              //버튼을 띄움
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('출근하기'),
              ),
            ],
          );
        });
    if (result) {
      setState(() {
        choolCheckDone = true;
        print('출근 완료');
      });
    }
  }

  Future<String> checkPermission() async {
    //권한 관련은 다 async await로 처리해야함
    //유저의 input을 기다려야 하기 때문
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    //위치 서비스(GPS)가 켜져있는지 확인

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();
    //현재 앱이 갖고 있는 위치서비스에 대한 권한을 갖고옴

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
      //권한이 없다면 권한을 요청하는 다이얼로그를 띄움

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허용해주세요';
        //그래도 권한이 디나이면 위치럼 메시지를 띄움
      }
    }
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 세팅에서 허가해주세요';
    }

    return '위치 권한이 허가되었습니다';
  }

  AppBar renderAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () async {
            if (mapController == null) {
              return;
            }
            //null이 아니면 map이 생성된 것
            final location = await Geolocator.getCurrentPosition();
            mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  location.latitude,
                  location.longitude,
                ),
              ),
            );
          },
          color: Colors.blueAccent,
          icon: const Icon(Icons.my_location),
        )
      ],
      title: const Text(
        '오늘도 출근',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initalPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;

  const _CustomGoogleMap(
      {required this.initalPosition,
      required this.circle,
      required this.marker,
      required this.onMapCreated,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        initialCameraPosition: initalPosition,
        mapType: MapType.normal,
        myLocationEnabled: true,
        //show my location
        myLocationButtonEnabled: false,
        //show an arrow on the map
        circles: {circle},
        markers: {marker},
        onMapCreated: onMapCreated, //컨트롤러를 받을 수 있음
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  final bool isWithinRange;
  final VoidCallback onPressed;
  final bool choolCheckDone;

  const _ChoolCheckButton(
      {required this.isWithinRange,
      required this.choolCheckDone,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.timelapse_outlined,
            size: 50,
            color: choolCheckDone
                ? Colors.green
                : isWithinRange
                    ? Colors.blue
                    : Colors.red,
          ),
          const SizedBox(height: 20),
          if (isWithinRange && !choolCheckDone)
            TextButton(
              onPressed: onPressed,
              child: const Text('출근하기'),
            ),
        ],
      ),
    );
  }
}
