import 'dart:io';
import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../common/utils/shell/shel.utils.dart';
import '../../core/structure.dart';
import 'package:path/path.dart' as p;

import 'config_main_file.dart';
import 'config_mini_app_router.dart';

void configMiniApp(String module, String path) async {
  Directory.current = path;

  // remove inessential folders
  await ShellUtils.removeFolder('linux');
  await ShellUtils.removeFolder('macos');
  await ShellUtils.removeFolder('windows');
  await ShellUtils.removeFolder('test');

  // add dependencies
  await PubspecUtils.addPathDependencies(module, path: '../');

  await PubspecUtils.addDependencies('build_runner', isDev: true);
  await PubspecUtils.addDependencies(
    'auto_route_generator',
    version: '7.1.1',
    isDev: true,
    runPubGet: true,
  );

  // config main file
  final pathFileMain = Structure.replaceAsExpected(
      path: '$path${p.separator}lib${p.separator}main.dart');
  await configMainFile(pathFileMain, module);

  final pathFileRouter = Structure.replaceAsExpected(
      path: '$path${p.separator}lib${p.separator}app_router.dart');
  configMiniAppRouterFile(pathFileRouter, module);

  LogService.success('gen code');
  await ShellUtils.flutterGen();
}
