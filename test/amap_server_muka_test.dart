import 'package:flutter_test/flutter_test.dart';

class MockAmapServerMukaPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {}
