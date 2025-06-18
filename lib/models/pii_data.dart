import 'package:json_annotation/json_annotation.dart';

part 'pii_data.g.dart';

@JsonSerializable()
class PiiData {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String socialSecurityNumber;
  final String dateOfBirth;
  final String address;
  final String creditCardNumber;
  final String password;

  PiiData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.socialSecurityNumber,
    required this.dateOfBirth,
    required this.address,
    required this.creditCardNumber,
    required this.password,
  });

  factory PiiData.fromJson(Map<String, dynamic> json) => _$PiiDataFromJson(json);
  Map<String, dynamic> toJson() => _$PiiDataToJson(this);

  @override
  String toString() {
    return 'PiiData(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, ssn: $socialSecurityNumber, dob: $dateOfBirth, address: $address, cc: $creditCardNumber, password: $password)';
  }
} 