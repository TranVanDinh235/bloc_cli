import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../create/create_single_file.dart';

void configModuleFile(String nameModule, String path) {
  final moduleName = PubspecUtils.appName ?? '';
  final import =
      '''import 'package:core_ui/core_ui.dart';
import 'core/router/router_factory.dart';
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
    lines.add('''
    class ${moduleName.pascalCase} extends BaseModule {
    
      @override
  void injectDependency() => configureDependencies();

  @override
  Map<String, FlutterBoostRouteFactory> getRouterMap() =>
      RouteFactory.routerMap;
    }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
  }
}
