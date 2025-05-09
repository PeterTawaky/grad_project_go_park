import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'cached/cache_helper.dart';
import 'core/utils/keys_manager.dart';

class ImageUploader {
  ImageUploader._();
  // static File? imgFile;
  static uploadImage({required ImageSource imageSource}) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      CachedData.setData(
        key: KeysManager.profilePhoto,
        value: pickedImage.path,
      );
    }
  }
}
