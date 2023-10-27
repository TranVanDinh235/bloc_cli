import 'dart:io';
import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../create/create_single_file.dart';

void configRouterConstant(String path) {
  var file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();

    // add router
    lines.add('''class RouteConstant {
      static const String template = '/template';
    }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success('Router constant created successfully');
  }
}

void configRouterFile(String nameModule, String path) {
  final import = '''import 'package:core_ui/core_ui.dart';
  import 'package:flutter/material.dart';
  import 'route_constants.dart';

  part '${nameModule.snakeCase}_router.gm.dart';''';

  var file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();

    // add import
    lines.add(import);

    // add module
    lines.add('''@AutoRouterConfig.module()
      class ${nameModule.pascalCase}Router extends _\$${nameModule.pascalCase}Router {
        List<AutoRoute> get routes => [
              /// add route here
            ];
      }''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success('Router file created successfully');
  }
}
