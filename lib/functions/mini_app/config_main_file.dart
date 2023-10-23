import 'dart:io';
import 'package:recase/recase.dart';

import '../create/create_single_file.dart';

Future configMainFile(String path, String moduleName) async {
  final import = '''import 'package:core_ui/base/mini_app.dart';
  import 'package:core_ui/core_ui.dart';
  import 'package:core_network/core_network.dart';
  import 'package:flutter/material.dart';
  import 'package:$moduleName/core/di/injection.dart';
  import 'package:$moduleName/$moduleName.dart';
  
  import 'app_router.dart';
  
    ''';

  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();
    lines.removeRange(0, lines.length);

    // add import
    lines.add(import);

    lines.add('''void main() async {
      WidgetsFlutterBinding.ensureInitialized();
    
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
    
      ModuleManagement().init([
        ${moduleName.pascalCase}(),
      ]);
    
      AppLauncherProps props = AppLauncherProps(
        appName: 'Feature name',
        module: ${moduleName.pascalCase}(),
        routerConfig: AppRouter()
            .config(deepLinkBuilder: (_) => const DeepLink.path('/setup')),
      );
    
      runApp(MiniApp(props: props));
    }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
  }
}
