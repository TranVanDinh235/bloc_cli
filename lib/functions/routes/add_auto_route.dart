import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/shell/shel.utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../../exception_handler/exceptions/cli_exception.dart';
import '../../extensions.dart';
import '../find_file/find_file_by_name.dart';
import 'add_auto_route_page.dart';

/// This command will create the route to the new page
void addAutoRoute(String nameRoute, String viewDir) {
  var routesFile = findFileByName('route_constants.dart');

  if (routesFile.path.isEmpty) {
    throw CliException('The route_constants file is found');
  }

  var declareRoute = 'static const ${nameRoute.camelCase} =';
  var line = "$declareRoute '/${nameRoute.camelCase}';";

  routesFile.appendClassContent('RouteConstant', line);

  addAutoRoutePage(nameRoute, viewDir);

  ShellUtils.flutterGen();

  LogService.success(
      Translation(LocaleKeys.sucess_route_created).trArgs([nameRoute]));
}

/// Create routes from the path
String _pathsToRoute(List<String> pathSplit) {
  var sb = StringBuffer();
  for (var e in pathSplit) {
    sb.write('_Paths.');
    sb.write(e.snakeCase.toUpperCase());
    if (e != pathSplit.last) {
      sb.write(' + ');
    }
  }
  return sb.toString();
}
