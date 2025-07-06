// lib/utils/logging_http_overrides.dart

import 'dart:async';
import 'dart:io';

/// Image.network나 http.get 등에서 내부적으로 HttpClient.open/openUrl/getUrl 등을 호출할 때
/// 이 래퍼가 가로채서 "콘솔에 로그를 찍고" 실제 요청은 _inner로 넘겨줍니다.
class LoggingHttpClient implements HttpClient {
  final HttpClient _inner;

  LoggingHttpClient(this._inner);

  /// Image.network나 http.get 내부에서 가장 먼저 사용하는 메서드 중 하나가 open()입니다.
  /// 따라서 반드시 open()도 오버라이드해서 로그 찍고 위임해 주어야 합니다.
  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    final url = Uri(scheme: 'https', host: host, port: port, path: path);
    print('🔔 [HTTP-REQUEST-OPEN] Method: $method, URL: $url');
    return _inner.open(method, host, port, path);
  }

  /// openUrl을 오버라이드하면, openUrl으로 바로 URL을 넘겨주는 경우도 가로챌 수 있습니다.
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    print('🔔 [HTTP-REQUEST-OPENURL] Method: $method, URL: $url');
    return _inner.openUrl(method, url);
  }

  /// getUrl은 GET 요청을 간단히 보낼 때 사용합니다.
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    print('🔔 [HTTP-REQUEST-GETURL] URL: $url');
    return _inner.getUrl(url);
  }

  /// 필요하다면 POST/PUT/DELETE 등도 추가로 오버라이드해서 로그 찍을 수 있습니다.
  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    print('🔔 [HTTP-REQUEST-POSTURL] URL: $url');
    return _inner.postUrl(url);
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    print('🔔 [HTTP-REQUEST-PUTURL] URL: $url');
    return _inner.putUrl(url);
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    print('🔔 [HTTP-REQUEST-DELETEURL] URL: $url');
    return _inner.deleteUrl(url);
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    print('🔔 [HTTP-REQUEST-PATCHURL] URL: $url');
    return _inner.patchUrl(url);
  }

  // ───────────────────────────────────────────────────────────────────
  // 나머지 메서드/프로퍼티는 기본 _inner로 위임(delegate)만 해 줍니다.
  // 이 방식 대신, 모든 메서드를 일일이 오버라이드해도 되지만,
  // 일반적으로는 noSuchMethod로 한 번에 위임하는 편이 코드가 짧아집니다.
  // ───────────────────────────────────────────────────────────────────

  @override
  noSuchMethod(Invocation invocation) {
    // invocation.memberName 등을 디버그용으로 찍고 싶다면 여기서 처리할 수도 있습니다.
    return Function.apply(
      _inner.noSuchMethod,
      [invocation],
      invocation.namedArguments,
    );
  }
}

/// HttpOverrides를 걸어서, 전역으로 생성되는 HttpClient를 LoggingHttpClient로 교체합니다.
class LoggingHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // 기존 HttpClient를 가져와서 LoggingHttpClient로 래핑
    return LoggingHttpClient(super.createHttpClient(context));
  }
}