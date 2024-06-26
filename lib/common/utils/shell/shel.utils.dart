import 'dart:io';

import 'package:process_run/shell_run.dart';

import '../../../core/generator.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../logger/log_utils.dart';
import '../pub_dev/pub_dev_api.dart';
import '../pubspec/pubspec_lock.dart';

class ShellUtils {
  static Future<void> pubGet() async {
    LogService.info('Running `flutter pub get` …');
    await run('flutter pub get', verbose: true);
  }

  static Future<void> flutterCreate(
    String path,
    String? org,
    String iosLang,
    String androidLang,
  ) async {
    LogService.info('Running `flutter create $path` …');

    await run(
        'flutter create --no-pub -i $iosLang -a $androidLang --org $org'
        ' "$path"',
        verbose: true);
  }

  static Future<void> flutterGen({String? workingDirectory}) async {
    LogService.info('Running `flutter pub run build_runner build --delete-conflicting-outputs` …');

    await run('flutter pub run build_runner build --delete-conflicting-outputs', verbose: true, workingDirectory: workingDirectory);
  }

  static Future<void> flutterCreateModule(String module) async {
    LogService.info('Running `flutter create $module` …');

    await run('flutter create --template=package $module', verbose: true);
  }

  static Future<void> flutterCreateMiniApp(String nameApp, {String? workingDirectory}) async {
    LogService.info('Running `flutter create mini app` …');

    await run('flutter create $nameApp', verbose: true, workingDirectory: workingDirectory);
  }

  static Future<void> update(
      [bool isGit = false, bool forceUpdate = false]) async {
    isGit = BLOCCli.arguments.contains('--git');
    forceUpdate = BLOCCli.arguments.contains('-f');
    if (!isGit && !forceUpdate) {
      var versionInPubDev =
          await PubDevApi.getLatestVersionFromPackage('get_cli');

      var versionInstalled = await PubspecLock.getVersionCli(disableLog: true);

      if (versionInstalled == versionInPubDev) {
        return LogService.info(
            Translation(LocaleKeys.info_cli_last_version_already_installed.tr)
                .toString());
      }
    }

    LogService.info('Upgrading get_cli …');

    try {
      if (Platform.script.path.contains('flutter')) {
        if (isGit) {
          await run(
              'flutter pub global activate -sgit https://github.com/jonataslaw/get_cli/',
              verbose: true);
        } else {
          await run('flutter pub global activate get_cli', verbose: true);
        }
      } else {
        if (isGit) {
          await run(
              'flutter pub global activate -sgit https://github.com/jonataslaw/get_cli/',
              verbose: true);
        } else {
          await run('flutter pub global activate get_cli', verbose: true);
        }
      }
      return LogService.success(LocaleKeys.sucess_update_cli.tr);
    } on Exception catch (err) {
      LogService.info(err.toString());
      return LogService.error(LocaleKeys.error_update_cli.tr);
    }
  }

  static Future<void> removeFolder(String name) async {
    await run('rm -r $name', verbose: true);
  }
}
