import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class RepositorySample extends Sample {
  final String _fileName;

  RepositorySample(String path, this._fileName,
      {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => state;

  String get state => '''class ${_fileName.pascalCase}Repository {
  const ${_fileName.pascalCase}Repository();
}
''';
}
