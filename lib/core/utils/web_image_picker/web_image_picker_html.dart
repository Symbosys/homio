// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

/// Native browser file input picker for Flutter Web.
///
/// Directly invokes HTML file picker without relying on Flutter platform channels,
/// eliminating MissingPluginException completely on the Web.
Future<({Uint8List bytes, String name})?> pickImageWeb() async {
  final completer = Completer<({Uint8List bytes, String name})?>();
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  input.onChange.listen((_) {
    final files = input.files;
    if (files == null || files.isEmpty) {
      if (!completer.isCompleted) completer.complete(null);
      return;
    }

    final file = files.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((_) {
      if (!completer.isCompleted) {
        final result = reader.result;
        if (result is Uint8List) {
          completer.complete((bytes: result, name: file.name));
        } else if (result is ByteBuffer) {
          completer.complete((bytes: result.asUint8List(), name: file.name));
        } else if (result is List<int>) {
          completer.complete((bytes: Uint8List.fromList(result), name: file.name));
        } else {
          completer.complete(null);
        }
      }
    });

    reader.onError.listen((_) {
      if (!completer.isCompleted) completer.complete(null);
    });
  });

  return completer.future;
}
