import 'package:image_picker/image_picker.dart';
import 'package:thirst_quest/api/models/photo.dart';
import 'package:thirst_quest/api/thirst_quest_api_client.dart';
import 'package:thirst_quest/services/auth_service.dart';

class PhotoService {
  final ThirstQuestApiClient apiClient;
  final AuthService authService;

  PhotoService({required this.apiClient, required this.authService});

  Future<Photo?> uploadProfilePicture(XFile imageFile) async {
    final token = await authService.getToken();
    return apiClient.uploadProfilePicture(token, imageFile);
  }

  Future<Photo?> uploadBubblerPhoto(XFile imageFile, String? bubblerId, int? osmId) async {
    final token = await authService.getToken();
    return apiClient.uploadBubblerPhoto(token, imageFile, bubblerId);
  }
}
