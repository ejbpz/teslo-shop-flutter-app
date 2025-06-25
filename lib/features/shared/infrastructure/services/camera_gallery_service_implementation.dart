import 'package:image_picker/image_picker.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/camera_gallery_service.dart';

class CameraGalleryServiceImplementation extends CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if(image == null) return null;

    return image.path;
  }

  @override
  Future<String?> takeImage() async {
    final XFile? image = await _picker.pickImage(
      preferredCameraDevice: CameraDevice.rear,
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if(image == null) return null;

    return image.path;
  }
}