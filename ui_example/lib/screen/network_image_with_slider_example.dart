import 'package:flutter/material.dart';

class NetworkImageWithSliderExample extends StatefulWidget {
  const NetworkImageWithSliderExample({Key? key}) : super(key: key);

  @override
  _NetworkImageWithSliderExampleState createState() =>
      _NetworkImageWithSliderExampleState();
}

class _NetworkImageWithSliderExampleState
    extends State<NetworkImageWithSliderExample> {
  // 슬라이더 값을 저장할 상태 변수
  double _sliderVal = 50.0;

  @override
  Widget build(BuildContext context) {
    print('NETWORKIMAGE build()');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Image + Slider 예제'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 네트워크 이미지를 감싸는 위젯
            CustomImageWrapper(
              imageUrl: 'https://picsum.photos/300/200', // 예시 URL
            ),
            const SizedBox(height: 32),
            // 슬라이더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text(
                    '현재 값: ${_sliderVal.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Slider(
                    value: _sliderVal,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _sliderVal.toStringAsFixed(1),
                    onChanged: (newValue) {
                      // 슬라이더를 움직일 때마다 화면만 업데이트
                      setState(() {
                        _sliderVal = newValue;
                      });
                    },
                    onChangeEnd: (finalValue) {
                      // 사용자가 슬라이더 터치를 뗀 시점에 한 번만 호출
                      print('슬라이더 최종 값: $finalValue');
                      // 만약 서버에 보내야 한다면, 이 자리에서 HTTP 요청을 보내면 됩니다.
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 네트워크 이미지를 감싸서, 이미지 요청 시 콘솔에 print를 남겨주는 위젯
class CustomImageWrapper extends StatelessWidget {
  final String imageUrl;

  const CustomImageWrapper({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 이곳에서 print를 하면, build()가 호출될 때마다
    // (즉, 실제로 Image.network를 생성해서 요청을 보낼 때마다) 찍힙니다.
    print('>>> 네트워크 이미지 요청: $imageUrl');

    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // 로딩 중에 진행 상황을 보고 싶다면 loadingBuilder를 추가로 활용할 수도 있습니다.
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            // 이미지 로드 완료 시
            return child;
          }
          // 로딩되는 동안 프로그레스 표시
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // 만약 네트워크 에러가 있으면 오류 아이콘 표시
          return const Center(
              child: Icon(Icons.error, size: 48, color: Colors.red));
        },
      ),
    );
  }
}
