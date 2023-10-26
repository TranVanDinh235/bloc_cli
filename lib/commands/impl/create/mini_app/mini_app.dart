import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/mini_app/config_mini_app.dart';
import '../../../interface/command.dart';

class CreateMiniAppCommand extends Command {
  @override
  String get commandName => 'mini_app';

  @override
  Future<void> execute() async {
    LogService.info('Creating mini_app $name` …');
    String? nameApp = name;
    await ShellUtils.flutterCreateMiniApp(nameApp);

    final module = Directory.current.parent;
    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameApp.snakeCase);
    Directory.current = path;

    configMiniApp(module.path.split('/').last.snakeCase, path);
  }

  @override
  String? get hint => LocaleKeys.hint_create_project.tr;

  @override
  bool validate() {
    return true;
  }

  @override
  String get codeSample => 'get create project';

  @override
  int get maxParameters => 0;
}
