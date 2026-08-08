import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

abstract class IImageUploadService {
  Future<String?> pickAndUploadImage({required ImageSource source});
}

class ImageUploadServiceImpl implements IImageUploadService {
  final ImagePicker _picker;
  final CloudinaryPublic _cloudinary;

  ImageUploadServiceImpl({
    ImagePicker? picker,
    CloudinaryPublic? cloudinary,
  })  : _picker = picker ?? ImagePicker(),
        _cloudinary = cloudinary ??
            CloudinaryPublic(
              'dizbwzb7i',
              'dukan_sathi_preset',
              cache: false,
            );

  @override
  Future<String?> pickAndUploadImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );

      if (pickedFile == null) return null;

      final CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'dukan_sathi_uploads',
        ),
      );

      return response.secureUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}

// Riverpod Provider for Image Upload Service
final imageUploadServiceProvider = Provider<IImageUploadService>((ref) {
  return ImageUploadServiceImpl();
});
