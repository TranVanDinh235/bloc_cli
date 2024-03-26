import 'dart:convert';

import 'package:recase/recase.dart';

import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../exception_handler/exceptions/cli_exception.dart';
import '../create/create_single_file.dart';
import '../find_file/find_file_by_name.dart';
import '../formatter_dart_file/frommatter_dart_file.dart';

void addDependency(String name, String repoDir, String cubitDir) {
  var appPagesFile = findFileByName('dependencies.dart');
  var lines = <String>[];
  if (appPagesFile.path.isEmpty) {
    throw CliException('The injection.dart file is found');
  } else {
    var content = formatterDartFile(appPagesFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }
  var tabEspaces = 2;

  var indexRepository =
      lines.indexWhere((element) => element.trim().contains('/// repository'));
  var lineRepository =
      '''${_getTabs(tabEspaces)}getIt.registerLazySingleton<${name.pascalCase}Repository>(() => ${name.pascalCase}Repository());''';
  lines.insert(indexRepository + 1, lineRepository);

  var indexCubit =
      lines.indexWhere((element) => element.trim().contains('/// bloc'));
  var lineCubit =
      '''${_getTabs(tabEspaces)}getIt.registerFactory<${name.pascalCase}Cubit>(() => ${name.pascalCase}Cubit(repository: getIt()));''';
  lines.insert(indexCubit + 1, lineCubit);

  var import = "import 'package:${PubspecUtils.appName}/";

  lines.insert(
    0,
    '''
    $import$repoDir';
    $import$cubitDir';
   ''',
  );

  writeFile(
    appPagesFile.path,
    lines.join('\n'),
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}

String _getTabs(int tabEspaces) {
  return '  ' * tabEspaces;
}
