import 'dart:io';
import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../create/create_single_file.dart';

void configRouterFile(String nameModule, String path) {
  final import = '''import 'package:core_ui/core_ui.dart';
  import 'package:flutter/material.dart';
  ''';

  var file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();

    // add import
    lines.add(import);

    // add module
    lines.add('''class RouteFactory {
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    /// add route here
  };
}
''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success('Router file created successfully');
  }
}
