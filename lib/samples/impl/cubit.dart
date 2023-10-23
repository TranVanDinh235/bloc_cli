import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class CubitSample extends Sample {
  final String _fileName;

  CubitSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => cubit;

  String get cubit => '''import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/${_fileName}_repository.dart';

part '${_fileName}_state.dart';

class ${_fileName.pascalCase}Cubit extends Cubit<${_fileName.pascalCase}State> {
  ${_fileName.pascalCase}Cubit({required this.repository}) : super(const ${_fileName.pascalCase}State());
  
  final ${_fileName.pascalCase}Repository repository;
}
''';
}
