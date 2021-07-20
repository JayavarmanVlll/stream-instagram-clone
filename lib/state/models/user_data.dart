import 'dart:convert';

/// Data model for a feed user's extra data.
class UserData {
  /// Data model for a feed user's extra data.
  UserData({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.profilePhoto,
  });

  /// Converts a Map to this.
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      fullName: map['full_name'] as String,
      profilePhoto: map['profile_photo'] as String?,
    );
  }

  /// Converts json to this.
  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  /// User's first name
  final String firstName;

  /// User's last name
  final String lastName;

  /// User's full name
  final String fullName;

  /// URL to user's profile photo.
  final String? profilePhoto;

  /// Convenient method to replace certian fields.
  UserData copyWith({
    String? firstName,
    String? lastName,
    String? fullName,
    String? profilePhoto,
  }) {
    return UserData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  /// Converts this model to a Map.
  Map<String, Object> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'profile_photo': profilePhoto ?? '',
    };
  }

  /// Converts this class to json.
  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      '''UserData(firstName: $firstName, lastName: $lastName, fullName: $fullName, profilePhoto: $profilePhoto)''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.fullName == fullName &&
        other.profilePhoto == profilePhoto;
  }

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      fullName.hashCode ^
      profilePhoto.hashCode;
}
