import 'dart:io';

import 'package:get_cli/core/internationalization.dart';
import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/locales.g.dart';
import '../create/create_single_file.dart';

void addDependency(String path, String controllerName, String import) {
  import = '''import 'package:${PubspecUtils.appName}/$import';''';
  var file = File(path);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();
    lines.insert(2, import);
    var index = lines.indexWhere((element) {
      element = element.trim();
      return element.startsWith('void dependencies() {');
    });
    index++;
    lines.insert(index, '''Get.lazyPut<${controllerName.pascalCase}Controller>(
          () => ${controllerName.pascalCase}Controller(),
);''');
    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success(LocaleKeys.sucess_add_controller_in_bindings
        .trArgs([controllerName.pascalCase, path]));
  }
}