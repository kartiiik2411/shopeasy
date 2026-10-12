class DeliveryAddress {
  const DeliveryAddress({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
  });

  final String fullName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;

  String get formattedAddress => [
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
  ].where((part) => part.trim().isNotEmpty).join(', ');

  Map<String, Object?> toFirestore() => {
    'fullName': fullName,
    'phone': phone,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory DeliveryAddress.fromFirestore(Map<String, dynamic> data) {
    String stringField(String key) {
      final value = data[key];
      return value is String ? value : '';
    }

    double? coordinateField(String key) {
      final value = data[key];
      return value is num ? value.toDouble() : null;
    }

    return DeliveryAddress(
      fullName: stringField('fullName'),
      phone: stringField('phone'),
      addressLine1: stringField('addressLine1'),
      addressLine2: stringField('addressLine2'),
      city: stringField('city'),
      state: stringField('state'),
      postalCode: stringField('postalCode'),
      country: stringField('country'),
      latitude: coordinateField('latitude'),
      longitude: coordinateField('longitude'),
    );
  }
}
