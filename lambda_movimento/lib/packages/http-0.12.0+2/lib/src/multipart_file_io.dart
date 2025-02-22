// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import '../../../async-2.3.0/lib/async.dart';
import '../../../http_parser-3.1.3/lib/http_parser.dart';
//import 'package:path/path.dart' as p;
import '../../../path-1.6.4/lib/path.dart' as p;

import 'byte_stream.dart';
import 'multipart_file.dart';

Future<MultipartFile> multipartFileFromPath(String field, String filePath,
    {String filename, MediaType contentType}) async {
  if (filename == null) filename = p.basename(filePath);
  var file = new File(filePath);
  var length = await file.length();
  var stream = new ByteStream(DelegatingStream.typed(file.openRead()));
  return new MultipartFile(field, stream, length,
      filename: filename, contentType: contentType);
}
