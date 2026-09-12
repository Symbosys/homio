import 'package:flutter/material.dart';

/// Customer address entity
class CustomerAddress {
  final String id;
  final String title; // 'Home', 'Office', 'Project Site', 'Other'
  final String addressLine1;
  final String addressLine2;
  final String locality;
  final String city;
  final String state;
  final String pinCode;
  final String landmark;
  final String contactPerson;
  final String contactPhone;
  bool isDefault;

  CustomerAddress({
    required this.id,
    required this.title,
    required this.addressLine1,
    required this.addressLine2,
    required this.locality,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.landmark,
    required this.contactPerson,
    required this.contactPhone,
    this.isDefault = false,
  });

  String get formattedAddress =>
      '$addressLine1, $addressLine2, $locality, $city, $state - $pinCode';
}

/// Linked project summary in the profile
class LinkedProjectSummary {
  final String id;
  final String name;
  final String status;
  final String role;
  final String completionDate;

  const LinkedProjectSummary({
    required this.id,
    required this.name,
    required this.status,
    required this.role,
    required this.completionDate,
  });
}

/// Customer security & login audit entry
class CustomerSecurityLog {
  final String id;
  final String action;
  final String timestamp;
  final String device;
  final String ipAddress;
  final IconData icon;

  const CustomerSecurityLog({
    required this.id,
    required this.action,
    required this.timestamp,
    required this.device,
    required this.ipAddress,
    required this.icon,
  });
}

/// Active customer profile model
class CustomerProfile {
  String firstName;
  String lastName;
  String email;
  String mobile;
  String alternateMobile;
  bool isPhoneVerified;
  bool isEmailVerified;
  String memberTier;
  String billingName;
  String billingGstin;
  String billingCompany;

  CustomerProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    this.alternateMobile = '+91 94311 88220',
    this.isPhoneVerified = true,
    this.isEmailVerified = true,
    this.memberTier = 'Verified Homeowner - Premium Tier',
    this.billingName = 'Amit Kumar',
    this.billingGstin = '20AAACH7409R1ZZ',
    this.billingCompany = 'Kumar Enterprise & Consultancy',
  });

  String get fullName => '$firstName $lastName';

  String get maskedMobile {
    if (mobile.length < 10) return mobile;
    return '${mobile.substring(0, 7)} •••••';
  }

  String get maskedEmail {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;
    final user = parts[0];
    return '${user[0]}•••••@${parts[1]}';
  }
}

/// Central Repository for Customer Profile
class ProfileRepository {
  ProfileRepository._();
  static final ProfileRepository instance = ProfileRepository._();

  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  final CustomerProfile profile = CustomerProfile(
    firstName: 'Amit',
    lastName: 'Kumar',
    email: 'amit.kumar@gmail.com',
    mobile: '+91 98765 43210',
  );

  final List<CustomerAddress> addresses = [
    CustomerAddress(
      id: 'addr_site',
      title: 'Project Site',
      addressLine1: 'Tower 4, Flat 1202',
      addressLine2: 'Palm Heights Luxury Residences',
      locality: 'Saraidhela',
      city: 'Dhanbad',
      state: 'Jharkhand',
      pinCode: '828127',
      landmark: 'Near Big Bazaar Square',
      contactPerson: 'Amit Kumar',
      contactPhone: '+91 98765 43210',
      isDefault: true,
    ),
    CustomerAddress(
      id: 'addr_home',
      title: 'Current Residence',
      addressLine1: 'House 42, Circular Road',
      addressLine2: 'Lalpur Enclave',
      locality: 'Lalpur',
      city: 'Ranchi',
      state: 'Jharkhand',
      pinCode: '834001',
      landmark: 'Opposite Plaza Cinema',
      contactPerson: 'Amit Kumar',
      contactPhone: '+91 98765 43210',
      isDefault: false,
    ),
    CustomerAddress(
      id: 'addr_office',
      title: 'Office',
      addressLine1: 'Suite 302, Business Bay',
      addressLine2: 'Bank More Commercial Hub',
      locality: 'Bank More',
      city: 'Dhanbad',
      state: 'Jharkhand',
      pinCode: '826001',
      landmark: 'Beside HDFC Bank',
      contactPerson: 'Amit Kumar (Manager)',
      contactPhone: '+91 94311 88220',
      isDefault: false,
    ),
  ];

  final List<LinkedProjectSummary> linkedProjects = const [
    LinkedProjectSummary(
      id: 'proj_3bhk_dhanbad',
      name: '3BHK Luxury Residence',
      status: 'Active (68% Complete)',
      role: 'Primary Owner',
      completionDate: 'Target: Oct 2026',
    ),
    LinkedProjectSummary(
      id: 'proj_2bhk_renov',
      name: '2BHK Apartment Renovation',
      status: 'Completed & Handed Over',
      role: 'Co-Owner',
      completionDate: 'Completed: Jan 2026',
    ),
  ];

  final List<CustomerSecurityLog> securityLogs = const [
    CustomerSecurityLog(
      id: 'sec_01',
      action: 'Profile Details Updated',
      timestamp: 'Today · 12:10 PM',
      device: 'Chrome on Windows 11',
      ipAddress: '103.24.188.42',
      icon: Icons.manage_accounts_rounded,
    ),
    CustomerSecurityLog(
      id: 'sec_02',
      action: 'Email Address Verified',
      timestamp: '10 Sep 2026 · 09:30 AM',
      device: 'Chrome on Windows 11',
      ipAddress: '103.24.188.42',
      icon: Icons.verified_user_rounded,
    ),
    CustomerSecurityLog(
      id: 'sec_03',
      action: 'Password Changed Successfully',
      timestamp: '05 Sep 2026 · 08:45 PM',
      device: 'Mobile Safari on iPhone 15',
      ipAddress: '157.34.201.89',
      icon: Icons.password_rounded,
    ),
  ];

  void updatePersonalDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String alternateMobile,
  }) {
    profile.firstName = firstName;
    profile.lastName = lastName;
    profile.email = email;
    profile.mobile = mobile;
    profile.alternateMobile = alternateMobile;
    changeNotifier.value++;
  }

  void addAddress(CustomerAddress address) {
    if (address.isDefault) {
      for (final a in addresses) {
        a.isDefault = false;
      }
    }
    addresses.add(address);
    changeNotifier.value++;
  }

  void updateAddress(CustomerAddress address) {
    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      if (address.isDefault) {
        for (final a in addresses) {
          a.isDefault = false;
        }
      }
      addresses[index] = address;
      changeNotifier.value++;
    }
  }

  void deleteAddress(String id) {
    addresses.removeWhere((a) => a.id == id);
    if (addresses.isNotEmpty && !addresses.any((a) => a.isDefault)) {
      addresses.first.isDefault = true;
    }
    changeNotifier.value++;
  }

  void setDefaultAddress(String id) {
    for (final a in addresses) {
      a.isDefault = a.id == id;
    }
    changeNotifier.value++;
  }
}
