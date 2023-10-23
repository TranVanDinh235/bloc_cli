import 'dart:io';
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

void configRouterFile(String path) {
  final import = '''import 'package:core_ui/core_ui.dart';
  import 'package:flutter/material.dart';
  import 'route_constants.dart';

  part 'module_router.gm.dart';''';

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
      class ModuleRouter extends _\$ModuleRouter {
        List<AutoRoute> get routes => [
              /// add route here
            ];
      }''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success('Router file created successfully');
  }
}
