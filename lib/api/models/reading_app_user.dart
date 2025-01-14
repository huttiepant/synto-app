import 'package:json_annotation/json_annotation.dart';

part 'reading_app_user.g.dart';

@JsonSerializable(createToJson: false)
class ReadingAppUser {
  final int user_id;
  final String access_token;
  final String token_type;
  final String expires_in;
  final String refresh_token;
  final String id;
  final int createdAt;
  final int updatedAt;
  final String firebaseUid;
  final String tunedGlobalExternalId;
  final String countryCode;

  ReadingAppUser(
      this.user_id,
      this.access_token,
      this.token_type,
      this.expires_in,
      this.refresh_token,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.firebaseUid,
      this.tunedGlobalExternalId,
      this.countryCode);

  factory ReadingAppUser.fromJson(Map<String, dynamic> json) {
    return _$ReadingAppUserFromJson(json);
  }
}
