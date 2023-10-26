import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class StateSample extends Sample {
  final String _fileName;

  StateSample(String path, this._fileName,
      {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => state;

  String get state => '''part of '${_fileName.snakeCase}_cubit.dart';
  
class ${_fileName.pascalCase}State extends Equatable {
  const ${_fileName.pascalCase}State({
    this.isLoading = false,
  });

  final bool isLoading;

  ${_fileName.pascalCase}State copyWith({
    bool isLoading = false,
  }) {
    return ${_fileName.pascalCase}State(
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  @override
  List<Object?> get props => [];
}
''';
}
