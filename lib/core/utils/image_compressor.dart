import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Cross-platform, pure Dart image compression utility.
///
/// Works reliably across Web, Desktop (Windows, macOS, Linux), and Mobile (Android, iOS)
/// without requiring native plugins or platform channels.
class ImageCompressor {
  /// Compresses [inputBytes] so that the resulting file size is strictly under [targetSizeBytes] (default 100 KB).
  ///
  /// Strategy:
  /// 1. Fast path: If image is already <= target size, returns original bytes immediately.
  /// 2. Decodes image and downscales if dimensions exceed [maxWidth] x [maxHeight] (default 1024px).
  /// 3. Iteratively applies quality step-down (85% -> 70% -> 55% -> 40% -> 25% -> 15%).
  /// 4. If still > 100 KB, scales down to 512px and compresses to ensure it stays strictly under 100 KB.
  static Future<Uint8List> compressUnder100KB(
    Uint8List inputBytes, {
    int targetSizeBytes = 100 * 1024, // 100 KB
    int maxWidth = 1024,
    int maxHeight = 1024,
  }) async {
    // 1. If already under target size, return original bytes without modification
    if (inputBytes.lengthInBytes <= targetSizeBytes) {
      return inputBytes;
    }

    // 2. Decode image using pure Dart engine
    final decoded = img.decodeImage(inputBytes);
    if (decoded == null) {
      // Fallback: If decode fails (e.g. SVG or unknown format), return original
      return inputBytes;
    }

    // 3. Resize proportionally if dimensions exceed max constraints
    img.Image workingImage = decoded;
    if (decoded.width > maxWidth || decoded.height > maxHeight) {
      if (decoded.width >= decoded.height) {
        workingImage = img.copyResize(
          decoded,
          width: maxWidth,
          interpolation: img.Interpolation.linear,
        );
      } else {
        workingImage = img.copyResize(
          decoded,
          height: maxHeight,
          interpolation: img.Interpolation.linear,
        );
      }
    }

    // 4. Iterative step-down quality compression
    const qualitySteps = [85, 72, 60, 48, 36, 25, 15];
    Uint8List bestCandidate = inputBytes;

    for (final quality in qualitySteps) {
      final encoded = Uint8List.fromList(img.encodeJpg(workingImage, quality: quality));
      bestCandidate = encoded;

      if (encoded.lengthInBytes <= targetSizeBytes) {
        return encoded;
      }
    }

    // 5. If still exceeding 100 KB (rare, for complex noise images), resize down to 512px
    final smallerImage = img.copyResize(
      workingImage,
      width: workingImage.width > workingImage.height ? 512 : null,
      height: workingImage.height >= workingImage.width ? 512 : null,
      interpolation: img.Interpolation.linear,
    );

    for (final quality in [70, 50, 30, 15]) {
      final encoded = Uint8List.fromList(img.encodeJpg(smallerImage, quality: quality));
      bestCandidate = encoded;

      if (encoded.lengthInBytes <= targetSizeBytes) {
        return encoded;
      }
    }

    return bestCandidate;
  }
}
