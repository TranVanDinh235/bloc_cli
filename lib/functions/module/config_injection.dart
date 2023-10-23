import 'dart:io';
import 'package:get_cli/common/utils/logger/log_utils.dart';

import '../create/create_single_file.dart';

void configInjectionFile(String path) {
  final import = '''import 'package:core_ui/core_ui.dart';''';
  var file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();

    // add import
    lines.add(import);

    // add module
    lines.add('''GetIt getIt = GetIt.instance;
    Future<void> configureDependencies() async {
    /// client
    
    /// repository
    
    /// bloc
    }
    ''');

    writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);
    LogService.success('Injection file created successfully');
  }
}
