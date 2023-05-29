import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class ImagePickerService {
  Uint8List? _imageData;

  Uint8List? get imageData => _imageData;

  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      _imageData = fileBytes;
    }
  }
}
