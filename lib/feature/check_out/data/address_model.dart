class Address {
  final String id;
  final String label;
  final String fullName;
  final String phoneNumber;
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.isDefault = false,
  });

  /// تحويل Address إلى JSON للحفظ في التخزين
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  /// إنشاء Address من JSON عند القراءة من التخزين
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['label'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      streetAddress: json['streetAddress'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  /// إنشاء نسخة من Address مع تعديل بعض الخصائص
  Address copyWith({
    String? id,
    String? label,
    String? fullName,
    String? phoneNumber,
    String? streetAddress,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// الحصول على العنوان الكامل كنص واحد
  String get fullAddress {
    return '$streetAddress, $city, $state, $country - $postalCode';
  }

  /// الحصول على العنوان المختصر
  String get shortAddress {
    return '$city, $country';
  }
}
