import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get firebaseKey => _get('FIREBASE_KEY');

  static String _get(String name) => DotEnv().env[name] ?? '';
  // static int _getInt(String name) => int.parse(DotEnv().env[name]!);
}
