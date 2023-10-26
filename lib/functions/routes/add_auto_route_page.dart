import 'dart:convert';

import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../exception_handler/exceptions/cli_exception.dart';
import '../create/create_single_file.dart';
import '../find_file/find_file_by_name.dart';
import '../formatter_dart_file/frommatter_dart_file.dart';

void addAutoRoutePage(String name, String viewDir) {
  var appPagesFile = findFileByName('module_router.dart');
  var lines = <String>[];
  if (appPagesFile.path.isEmpty) {
    throw CliException('The module_router file is found');
  } else {
    var content = formatterDartFile(appPagesFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  var routesOrPath = 'RouteConstant';

  var indexRoutes = lines.indexWhere(
      (element) => element.trim().contains('List<AutoRoute> get routes => ['));
  var index =
      lines.indexWhere((element) => element.contains('];'), indexRoutes);

  var tabEspaces = 2;

  var line = '''${_getTabs(tabEspaces)}CustomRoute(
${_getTabs(tabEspaces + 1)}path: $routesOrPath.${name.camelCase}, 
${_getTabs(tabEspaces + 1)}page: ${name.pascalCase}Route.page, 
${_getTabs(tabEspaces + 1)}transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
${_getTabs(tabEspaces)}),''';

  var import = "import 'package:${PubspecUtils.appName}/";

  lines.insert(index, line);

  lines.insert(0, "$import$viewDir';");

  writeFile(
    appPagesFile.path,
    lines.join('\n'),
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}

/// Create a tab line
/// ```
/// _getTabs(2)   // '    ';
/// ```
String _getTabs(int tabEspaces) {
  return '  ' * tabEspaces;
}

/// count the tabs on the line
int _countTabs(String line) {
  return '  '.allMatches(line).length;
}

/// log invalid format file
void _logInvalidFormart() {
  LogService.info(
      'the app_pages.dart file does not meet the '
      'expected format, fails to create children pages',
      false,
      false);
}
