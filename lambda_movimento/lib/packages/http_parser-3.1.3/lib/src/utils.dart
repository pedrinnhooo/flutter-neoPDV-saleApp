// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../../source_span-1.5.5/lib/source_span.dart';

/// Runs [body] and wraps any format exceptions it produces.
///
/// [name] should describe the type of thing being parsed, and [value] should be
/// its actual value.
T wrapFormatException<T>(String name, String value, T body()) {
  try {
    return body();
  } on SourceSpanFormatException catch (error) {
    throw new SourceSpanFormatException(
        'Invalid $name: ${error.message}', error.span, error.source);
  } on FormatException catch (error) {
    throw new FormatException(
        'Invalid $name "$value": ${error.message}', error.source, error.offset);
  }
}
