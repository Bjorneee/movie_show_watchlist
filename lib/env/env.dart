// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'API_KEY', obfuscate: true)
    static final String apiKey = _Env.apiKey;

    @EnviedField(varName: 'BASE_URL')
    static const String baseURL = _Env.baseURL;

    @EnviedField(varName: 'MAX_RETRIES')
    static const int maxRetries = _Env.maxRetries;

    @EnviedField(varName: 'DEBUG')
    static const bool debug = _Env.debug;
}

