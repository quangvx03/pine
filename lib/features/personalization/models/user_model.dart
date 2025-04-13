import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pine_admin_panel/features/personalization/models/address_model.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/formatters/formatter.dart';

/// Model class representing user data
class UserModel {
  late final String? id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrderModel>? orders;
  List<AddressModel>? addresses;  // Add this line

  /// Constructor
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.staff,
    this.createdAt,
    this.updatedAt,
    this.orders,
    this.addresses,  // Add this line to accept addresses
  });

  String get fullName => '$firstName $lastName';
  String get formattedDate => PFormatter.formatDate(createdAt);
  String get formattedUpdatedDate => PFormatter.formatDate(updatedAt);
  String get formattedPhoneNo => PFormatter.formatPhoneNumber(phoneNumber);

  static UserModel empty() => UserModel(email: '');

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': userName,
      'Email': email,
      'PhoneNumber': phoneNumber.trim().replaceAll(' ', ''),
      'ProfilePicture': profilePicture,
      'Role': role.name,
      'CreatedAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'UpdatedAt': FieldValue.serverTimestamp(),
      'Addresses': addresses?.map((address) => address.toJson()).toList(),  // Serialize addresses if they exist
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) return empty();

    return UserModel(
      id: document.id,
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      userName: data['Username'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      role: AppRole.values.firstWhere(
            (r) => r.name == (data['Role'] ?? 'user'),
        orElse: () => AppRole.user,
      ),
      createdAt: data['CreatedAt'] is Timestamp ? (data['CreatedAt'] as Timestamp).toDate() : null,
      updatedAt: data['UpdatedAt'] is Timestamp ? (data['UpdatedAt'] as Timestamp).toDate() : null,
      addresses: (data['Addresses'] as List<dynamic>?)?.map((addressData) {
        return AddressModel.fromMap(addressData as Map<String, dynamic>);
      }).toList(),
    );
  }
}

