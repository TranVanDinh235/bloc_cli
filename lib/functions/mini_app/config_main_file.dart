import 'dart:io';
import 'package:recase/recase.dart';

import '../create/create_single_file.dart';

Future configMainFile(String path, String moduleName) async {
  final import = '''import 'package:core/core.dart';
  import 'package:core_network/core_network.dart';
  import 'package:flutter/material.dart';
  import 'package:$moduleName/core/di/injection.dart';
  import 'package:$moduleName/$moduleName.dart';

''';

  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();
    lines.removeRange(0, lines.length);

    // add import
    lines.add(import);

    lines.add('''void main() async {
      CustomFlutterBinding();
    
      NetworkInfo networkInfo = await NetworkInfo.getInstance(
        imei: '',
        accessToken: '',
        sessionId: '',
        publicKey: '',
        privateKey: '',
        appVersion: ''
      );
    
      getIt.registerLazySingleton<NetworkInfo>(() => networkInfo);
      getIt.registerLazySingleton<Environment>(() => Environment.stg);
      
      final moduleManagement = ModuleManagement.getInstance();
      moduleManagement.init([${moduleName.pascalCase}()]);
    
      AppLauncherProps props = AppLauncherProps.getInstance(
        appName: 'Mini App',
        routerMap: moduleManagement.getAllRouteMap(),
        initialRoute: '${moduleName.camelCase}',
        arguments: {},
      );
    
      runApp(MiniApp(props: props));
    }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
  }
}
