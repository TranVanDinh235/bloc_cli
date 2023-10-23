import 'dart:io';

import 'package:get_cli/core/structure.dart';
import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../create/create_single_file.dart';

void configModuleFile(String path) {
  final moduleName = PubspecUtils.appName ?? '';
  final import =
      '''import 'package:auto_route/src/route/auto_route_config.dart';
  import 'package:core_ui/base/base_module.dart';
  import 'package:$moduleName/core/router/module_router.dart';
  import 'core/di/injection.dart';
  ''';
  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();

    // remove Calculator
    var index = 2;
    index = lines.indexWhere((element) {
      element = element.trim();
      return element.startsWith('/// A Calculator');
    });
    lines.removeRange(index, lines.length);

    // add import
    lines.insert(2, import);

    // add module
    lines.add('''late Function(String) setInitRoute;
    class ${moduleName.pascalCase} extends BaseModule {
      ModuleRouter moduleRouter = ModuleRouter();
    
      @override
      void injectDependency() => configureDependencies();
    
      @override
      void onSetInitRoute(Function(String) callback) {
        setInitRoute = callback;
      }
    
      @override
      List<AutoRoute> getListRoute() => moduleRouter.routes;
    }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
  }
}
