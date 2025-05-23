import 'dart:io';

import 'package:dio/dio.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

//final storage = FlutterSecureStorage();

final dio = Dio();
final simulatorIp = '127.0.0.1:3000';
final emulatorIp = '10.0.2.2:3000';
final ip = Platform.isIOS ? simulatorIp : emulatorIp;