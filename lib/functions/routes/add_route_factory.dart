import 'dart:convert';

import 'package:bloc_cli/common/utils/shell/shel.utils.dart';
import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../exception_handler/exceptions/cli_exception.dart';
import '../create/create_single_file.dart';
import '../find_file/find_file_by_name.dart';
import '../formatter_dart_file/frommatter_dart_file.dart';

Future addRouteFactory(String name, String viewDir) async {
  var appPagesFile = findFileByName('app_routes.dart');
  var lines = <String>[];
  if (appPagesFile.path.isEmpty) {
    throw CliException('The route_factory file is not found');
  } else {
    var content = formatterDartFile(appPagesFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  var indexRoutes = lines.indexWhere((element) => element
      .trim()
      .contains('List<AutoRoute> get routes => ['));
  var index =
      lines.indexWhere((element) => element.contains('];'), indexRoutes);


  var line = '''AutoRoute(
          page: ${name.pascalCase}Route.page,
          path: RoutesConstants.main,
        )''';

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

  await ShellUtils.flutterGen();
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
