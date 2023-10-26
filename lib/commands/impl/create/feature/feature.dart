import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../functions/create/create_single_file.dart';
import '../../../../functions/dependency/add_dependencies.dart';
import '../../../../functions/routes/add_auto_route.dart';
import '../../../../samples/impl/cubit.dart';
import '../../../../samples/impl/page.dart';
import '../../../../samples/impl/repository.dart';
import '../../../../samples/impl/state.dart';
import '../../../interface/command.dart';

/// The command create a Binding and Controller page and view
class CreateFeatureCommand extends Command {
  @override
  String get commandName => 'feature';

  @override
  List<String> get alias => ['feature', '-p', '-m'];

  @override
  Future<void> execute() async {
    var isProject = false;
    if (VTMCli.arguments[0] == 'create' || VTMCli.arguments[0] == '-c') {
      isProject = VTMCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isEmpty || isProject) {
      name = 'home';
    }
    checkForAlreadyExists(name);
  }

  @override
  String? get hint => LocaleKeys.hint_create_page.tr;

  void checkForAlreadyExists(String? name) {
    var newFileModel =
        Structure.model(name, 'feature', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title:
            Translation(LocaleKeys.ask_existing_page.trArgs([name])).toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        // final dialog = CLI_Dialog();
        // dialog.addQuestion(LocaleKeys.ask_new_page_name.tr, 'name');
        // name = dialog.ask()['name'] as String?;
        var name = ask(LocaleKeys.ask_new_page_name.tr);
        checkForAlreadyExists(name.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name!, overwrite: false);
    }
  }

  void _writeFiles(String path, String name, {bool overwrite = false}) {
    var extraFolder = PubspecUtils.extraFolder ?? true;
    var repositoryFile = handleFileCreate(
      name,
      'repository',
      path,
      extraFolder,
      RepositorySample(
        '',
        name,
        overwrite: overwrite,
      ),
      'repository',
    );
    var stateFile = handleFileCreate(
      name,
      'state',
      path,
      extraFolder,
      StateSample(
        '',
        name,
        overwrite: overwrite,
      ),
      'cubit',
    );
    var cubitFile = handleFileCreate(
      name,
      'cubit',
      path,
      extraFolder,
      CubitSample(
        '',
        name,
        overwrite: overwrite,
      ),
      'cubit',
    );
    var pageFile = handleFileCreate(
      name,
      'page',
      path,
      extraFolder,
      PageSample(
        '',
        name,
        overwrite: overwrite,
      ),
      'page',
    );

    addDependency(
      name,
      Structure.pathToDirImport(repositoryFile.path),
      Structure.pathToDirImport(cubitFile.path),
    );
    addAutoRoute(
      name,
      Structure.pathToDirImport(pageFile.path),
    );
    LogService.success(LocaleKeys.sucess_page_create.trArgs([name.pascalCase]));
  }

  @override
  String get codeSample => 'get create page:product';

  @override
  int get maxParameters => 0;
}
