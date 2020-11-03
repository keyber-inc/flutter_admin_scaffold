import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admin_scaffold/flutter_admin_scaffold.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_admin_scaffold');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterAdminScaffold.platformVersion, '42');
  });
}
