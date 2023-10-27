import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../create/create_single_file.dart';

Future configMiniAppRouterFile(String path, String module) async {
  final import = '''import 'package:core_ui/core_ui.dart';
  import 'package:${module.snakeCase}/core/router/${module.snakeCase}_router.dart';
  
  part 'app_router.gr.dart';
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
    lines.add('''
    @AutoRouterConfig(modules: [${module.pascalCase}Router])
      class AppRouter extends _\$AppRouter {
        @override
        List<AutoRoute> get routes => [
              ...${module.pascalCase}Router().routes,
            ];
      }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success('app_router.dart file created successfully');
  }
}
