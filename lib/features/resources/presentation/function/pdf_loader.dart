import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Copies a Flutter asset PDF to a temporary file and returns its path.
/// Required because [flutter_pdfview] needs a real file path, not an asset path.
Future<String> loadPdfAsset(String assetPath) async {
  print('Loading PDF asset: $assetPath');
  final byteData = await rootBundle.load(assetPath);
  print('PDF loaded, size: ${byteData.lengthInBytes} bytes');
  final tempDir = await getApplicationDocumentsDirectory();
  print('Temp directory: ${tempDir.path}');

  // Use the filename from the asset path as temp filename
  final fileName = assetPath.split('/').last;
  final file = File('${tempDir.path}/$fileName');
  print('Temp file path: ${file.path}');

  await file.writeAsBytes(
    byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ),
  );
  print('PDF written to temp file successfully');

  // Verify file was written correctly
  final fileSize = await file.length();
  print('Written file size: $fileSize bytes');
  if (fileSize == 0) {
    throw Exception('PDF file was not written correctly');
  }

  return file.path;
}