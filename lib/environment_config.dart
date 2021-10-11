import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnvironmentConfig {
  // We just need to pass the api key like "flutter run --dart-define=booksApiKey=THEKEY"
  final booksApiKey = const String.fromEnvironment("booksApiKey");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
