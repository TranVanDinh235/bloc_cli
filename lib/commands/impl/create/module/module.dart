import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/mini_app/config_mini_app.dart';
import '../../../../functions/module/config_injection.dart';
import '../../../../functions/module/config_module.dart';
import '../../../../functions/module/config_router.dart';
import '../../../interface/command.dart';

class CreateModuleCommand extends Command {
  @override
  String get commandName => 'module';

  @override
  Future<void> execute() async {
    LogService.info('Creating module $name` …');
    // final menu = Menu([
    //   'Flutter Project',
    //   'Get Server',
    // ], title: 'Select which type of project you want to create ?');
    // final result = menu.choose();
    String? nameModule = name;
    // if (name == '.') {
    //   // final dialog = CLI_Dialog(questions: [
    //   //   [LocaleKeys.ask_name_to_project.tr, 'name']
    //   // ]);
    //   nameProject = ask(LocaleKeys.ask_name_to_project.tr);
    // }

    // if (result.index == 0) {
    // final dialog = CLI_Dialog(questions: [
    //   [
    //     '${LocaleKeys.ask_company_domain.tr} \x1B[33m '
    //         '${LocaleKeys.example.tr} com.yourcompany \x1B[0m',
    //     'org'
    //   ]
    // ]);

    // var org = ask(
    //   '${LocaleKeys.ask_company_domain.tr} \x1B[33m '
    //       '${LocaleKeys.example.tr} com.yourcompany \x1B[0m',
    // );

    // final iosLangMenu =
    // Menu(['Swift', 'Objective-C'], title: LocaleKeys.ask_ios_lang.tr);
    // final iosResult = iosLangMenu.choose();
    //
    // var iosLang = iosResult.index == 0 ? 'swift' : 'objc';
    //
    // final androidLangMenu =
    // Menu(['Kotlin', 'Java'], title: LocaleKeys.ask_android_lang.tr);
    // final androidResult = androidLangMenu.choose();
    //
    // var androidLang = androidResult.index == 0 ? 'kotlin' : 'java';
    //
    // final linterMenu = Menu([
    //   'yes',
    //   'no',
    // ], title: LocaleKeys.ask_use_linter.tr);
    // final linterResult = linterMenu.choose();
    //
    await ShellUtils.flutterCreateModule(nameModule);

    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameModule.snakeCase);
    Directory.current = path;

    await ShellUtils.removeFolder('android');
    await ShellUtils.removeFolder('ios');
    await ShellUtils.removeFolder('linux');
    await ShellUtils.removeFolder('macos');
    await ShellUtils.removeFolder('windows');
    await ShellUtils.removeFolder('test');

    await PubspecUtils.addPathDependencies('core_ui', path: '../core_ui');
    await PubspecUtils.addPathDependencies('core_network',
        path: '../core_network');
    await PubspecUtils.addDependencies('auto_route_generator', version: '7.1.1', isDev: true);
    await PubspecUtils.addDependencies('build_runner', isDev: true);
    await PubspecUtils.addDependencies('json_serializable',
        isDev: true, runPubGet: true);

    final pathFileModule = Structure.replaceAsExpected(
        path:
            '${Directory.current.path}${p.separator}lib${p.separator}${nameModule.snakeCase}.dart');
    configModuleFile(pathFileModule);
    Directory('${Directory.current.path}${p.separator}lib${p.separator}core')
        .createSync();
    Directory(
            '${Directory.current.path}${p.separator}lib${p.separator}core${p.separator}di')
        .createSync();
    Directory(
            '${Directory.current.path}${p.separator}lib${p.separator}core${p.separator}router')
        .createSync();
    Directory('${Directory.current.path}${p.separator}lib${p.separator}feature')
        .createSync();

    final pathFileInjection = Structure.replaceAsExpected(
        path:
            '${Directory.current.path}${p.separator}lib${p.separator}core${p.separator}di${p.separator}injection.dart');
    configInjectionFile(pathFileInjection);
    final pathFileRouterConstant = Structure.replaceAsExpected(
        path:
            '${Directory.current.path}${p.separator}lib${p.separator}core${p.separator}router${p.separator}route_constants.dart');
    configRouterConstant(pathFileRouterConstant);
    final pathFileRouter = Structure.replaceAsExpected(
        path:
            '${Directory.current.path}${p.separator}lib${p.separator}core${p.separator}router${p.separator}module_router.dart');
    configRouterFile(pathFileRouter);
    await ShellUtils.flutterGen();

    // create mini app
    await ShellUtils.flutterCreateMiniApp('mini_app', workingDirectory: Directory.current.path);

    var pathMiniApp = Structure.replaceAsExpected(
        path: '${Directory.current.path}${p.separator}mini_app');

    configMiniApp(nameModule.snakeCase, pathMiniApp);
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
