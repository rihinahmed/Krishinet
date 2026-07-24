import 'dart:io';

bool get isTestingEnv {
  try {
    if (Platform.isAndroid || Platform.isIOS) return false;
    return Platform.environment.containsKey('FLUTTER_TEST');
  } catch (_) {
    return false;
  }
}
