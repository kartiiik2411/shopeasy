import 'package:flutter_test/flutter_test.dart';
import 'package:shopeasy_app/domain/entities/delivery_address.dart';

void main() {
  group('DeliveryAddress', () {
    const address = DeliveryAddress(
      fullName: 'Alex Johnson',
      phone: '+1 555 123 4567',
      addressLine1: '12 Market Street',
      addressLine2: 'Apartment 4',
      city: 'Springfield',
      state: 'IL',
      postalCode: '62701',
      country: 'USA',
      latitude: 39.8,
      longitude: -89.6,
    );

    test('serializes all address fields for Firestore', () {
      expect(address.toFirestore(), {
        'fullName': 'Alex Johnson',
        'phone': '+1 555 123 4567',
        'addressLine1': '12 Market Street',
        'addressLine2': 'Apartment 4',
        'city': 'Springfield',
        'state': 'IL',
        'postalCode': '62701',
        'country': 'USA',
        'latitude': 39.8,
        'longitude': -89.6,
      });
    });

    test('reads Firestore fields and formats the address', () {
      final restored = DeliveryAddress.fromFirestore(address.toFirestore());

      expect(restored.fullName, address.fullName);
      expect(restored.phone, address.phone);
      expect(restored.latitude, address.latitude);
      expect(restored.longitude, address.longitude);
      expect(
        restored.formattedAddress,
        '12 Market Street, Apartment 4, Springfield, IL, 62701, USA',
      );
    });

    test('formats addresses without empty optional lines', () {
      const withoutAddressLine2 = DeliveryAddress(
        fullName: 'Alex Johnson',
        phone: '5551234567',
        addressLine1: '12 Market Street',
        city: 'Springfield',
        state: 'IL',
        postalCode: '62701',
        country: 'USA',
      );

      expect(
        withoutAddressLine2.formattedAddress,
        '12 Market Street, Springfield, IL, 62701, USA',
      );
    });

    test('handles null and unexpected Firestore field values', () {
      final restored = DeliveryAddress.fromFirestore({
        'fullName': null,
        'phone': 12345,
        'addressLine1': '12 Market Street',
        'latitude': 'not-a-coordinate',
      });

      expect(restored.fullName, isEmpty);
      expect(restored.phone, isEmpty);
      expect(restored.addressLine1, '12 Market Street');
      expect(restored.addressLine2, isEmpty);
      expect(restored.latitude, isNull);
      expect(restored.longitude, isNull);
    });
  });
}
