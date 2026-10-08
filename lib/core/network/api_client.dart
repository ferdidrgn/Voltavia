import 'package:dio/dio.dart';

/// Ortak HTTP istemcisi. Bağlantı kopunca aynı isteği en fazla iki kez yineler.
class ApiClient {
  ApiClient({Dio? client}) : dio = client ?? Dio(_options) {
    if (client == null) {
      dio.interceptors.add(_RetryInterceptor(dio));
    }
  }

  final Dio dio;

  static final BaseOptions _options = BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 40),
    headers: const {'User-Agent': 'Voltavia/1.0 (ev charging map)'},
  );
}

class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra['retry'] as int?) ?? 0;
    final transient = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout;
    if (!transient || attempt >= 2) {
      handler.next(err);
      return;
    }
    err.requestOptions.extra['retry'] = attempt + 1;
    await Future<void>.delayed(Duration(milliseconds: 350 * (attempt + 1)));
    try {
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (next) {
      handler.next(next);
    }
  }
}
