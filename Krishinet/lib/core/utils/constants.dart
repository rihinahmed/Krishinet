import 'package:flutter/material.dart';
import 'environment.dart';

class AppConstants {
  static const String appName = 'Krishinet';
  static const String apiBaseUrl = 'https://api.krishinet.com/v1';

  static bool get isTesting => isTestingEnv;

  // Helper widget to safely build network images without throwing HTTP 400 exceptions during widget testing
  static Widget buildNetworkImage({
    required BuildContext context,
    required String url,
    required BoxFit fit,
    required Widget Function(BuildContext, Object, StackTrace?) errorBuilder,
    double? width,
    double? height,
  }) {
    if (isTesting) {
      return errorBuilder(context, Exception('Testing env placeholder'), null);
    }
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }

  // Helper method to safely return an ImageProvider for tests
  static ImageProvider buildImageProvider(String url) {
    if (isTesting) {
      return const AssetImage('assets/images/avatar.jpg');
    }
    return NetworkImage(url);
  }
}
