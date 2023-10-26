import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class PageSample extends Sample {
  final String _fileName;

  PageSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => page;

  String get page => '''import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/${_fileName.snakeCase}_cubit.dart';

@RoutePage()
class ${_fileName.pascalCase}Page extends StatelessWidget {
  const ${_fileName.pascalCase}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<${_fileName.pascalCase}Cubit>(
      create: (_) => getIt<${_fileName.pascalCase}Cubit>(),
      child: ${_fileName.pascalCase}Body(),
    );
  }
}

class ${_fileName.pascalCase}Body extends StatefulWidget {
  const ${_fileName.pascalCase}Body({super.key});

  @override
  State<${_fileName.pascalCase}Body> createState() => ${_fileName.pascalCase}BodyState();
}

class ${_fileName.pascalCase}BodyState extends State<${_fileName.pascalCase}Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<${_fileName.pascalCase}Cubit, ${_fileName.pascalCase}State>(
        listener: (_, state) {},
        builder: (_, state) {
          return const Center(
            child: Text('${_fileName.pascalCase} Page'),
          );
        },
      ),
    )
  }
}
''';
}
