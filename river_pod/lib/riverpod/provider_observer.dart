import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    //모든 Provider들이 업데이트 될 때 이 함수가 불림.
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print(
      '[Provider Updated] provider : $provider / pv: $previousValue / nv: $newValue',
    );
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
     //Provider가 추가될 때 이 함수가 불림
    print(
      '[Provider Added] provider : $provider / value : $value',
    );
  }
  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    //Provider가 삭제될 때
    print(
      '[Provider Disposed] provider : $provider',
    );



  }
}
