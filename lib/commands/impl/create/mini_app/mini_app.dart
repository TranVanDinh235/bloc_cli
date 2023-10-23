import 'dart:io';

import 'package:get_cli/functions/module/config_router.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/module/config_injection.dart';
import '../../../interface/command.dart';

class CreateMiniAppCommand extends Command {
  @override
  String get commandName => 'mini_app';

  @override
  Future<void> execute() async {
    LogService.info('Creating mini_app $name` …');
    // final menu = Menu([
    //   'Flutter Project',
    //   'Get Server',
    // ], title: 'Select which type of project you want to create ?');
    // final result = menu.choose();
    String? nameApp = name;
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
    await ShellUtils.flutterCreateMiniApp(nameApp);

    final module = Directory.current.parent;
    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameApp.snakeCase);
    Directory.current = path;

    // remove inessential folders
    await ShellUtils.removeFolder('android');
    await ShellUtils.removeFolder('ios');
    await ShellUtils.removeFolder('linux');
    await ShellUtils.removeFolder('macos');
    await ShellUtils.removeFolder('windows');
    await ShellUtils.removeFolder('test');

    // add dependencies
    await PubspecUtils.addPathDependencies('$module', path: '../');

    // config main file
    final pathFileMain = Structure.replaceAsExpected(
        path:
        '${Directory.current.path}${p.separator}lib${p.separator}main.dart');
    // configMainFile(pathFileMain);

    final pathFileRouter = Structure.replaceAsExpected(
        path:
        '${Directory.current.path}${p.separator}lib${p.separator}core${p.separator}router${p.separator}module_router.dart');
    configRouterFile(pathFileRouter);
    await ShellUtils.flutterGen();

    // switch (linterResult.index) {
    //   case 0:
    //     if (PubspecUtils.isServerProject) {
    //       await PubspecUtils.addDependencies('lints',
    //           isDev: true, runPubGet: true);
    //       AnalysisOptionsSample(
    //           include: 'include: package:lints/recommended.yaml')
    //           .create();
    //     } else {
    //       await PubspecUtils.addDependencies('flutter_lints',
    //           isDev: true, runPubGet: true);
    //       AnalysisOptionsSample(
    //           include: 'include: package:flutter_lints/flutter.yaml'
    //           .create();
    //     }
    //     break;
    //
    //   default:
    //     AnalysisOptionsSample().create();
    // }
    // await InitCommand().execute();
    // } else {
    //   await InitGetServer().execute();
    // }
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
