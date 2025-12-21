import 'package:e_commerce_fullapp/feature/check_out/data/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// المتحكم بإدارة العناوين
class AddressController extends GetxController {
  final storage = GetStorage();

  // قائمة العناوين
  var addresses = <Address>[].obs;

  // العنوان المحدد حالياً
  var selectedAddress = Rxn<Address>();

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  /// تحميل العناوين من التخزين المحلي
  void loadAddresses() {
    try {
      final savedAddresses = storage.read('addresses');
      if (savedAddresses != null) {
        addresses.value = (savedAddresses as List)
            .map((addr) => Address.fromJson(addr))
            .toList();

        // تعيين العنوان الافتراضي كعنوان محدد
        final defaultAddr = addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addresses.isNotEmpty ? addresses.first : _getDefaultAddress(),
        );
        selectedAddress.value = defaultAddr;

        print('✅ تم تحميل ${addresses.length} عنوان');
      } else {
        // إضافة عنوان افتراضي إذا لم توجد عناوين
        _addDefaultAddress();
      }
    } catch (e) {
      print('❌ خطأ في تحميل العناوين: $e');
      _addDefaultAddress();
    }
  }

  /// حفظ العناوين في التخزين المحلي
  void saveAddresses() {
    try {
      final addressesJson = addresses.map((addr) => addr.toJson()).toList();
      storage.write('addresses', addressesJson);
      print('✅ تم حفظ ${addresses.length} عنوان');
    } catch (e) {
      print('❌ خطأ في حفظ العناوين: $e');
    }
  }

  /// إضافة عنوان افتراضي
  void _addDefaultAddress() {
    final defaultAddr = _getDefaultAddress();
    addresses.add(defaultAddr);
    selectedAddress.value = defaultAddr;
    saveAddresses();
  }

  /// الحصول على عنوان افتراضي
  Address _getDefaultAddress() {
    return Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: 'Home',
      fullName: 'John Doe',
      phoneNumber: '+970 599 123 456',
      streetAddress: 'Street 10, Building 5',
      city: 'Gaza',
      state: 'Gaza Strip',
      country: 'Palestine',
      postalCode: '00000',
      isDefault: true,
    );
  }

  /// إضافة عنوان جديد
  void addAddress(Address address) {
    // إذا كان العنوان الجديد افتراضي، إلغاء التعيين الافتراضي للعناوين الأخرى
    if (address.isDefault) {
      _clearDefaultAddresses();
    }

    addresses.add(address);
    saveAddresses();

    // تعيين العنوان الجديد كعنوان محدد
    selectedAddress.value = address;

    Get.snackbar(
      'Success',
      'Address added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// تحديث عنوان موجود
  void updateAddress(String addressId, Address updatedAddress) {
    final index = addresses.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      // إذا كان العنوان المحدث افتراضي، إلغاء التعيين الافتراضي للعناوين الأخرى
      if (updatedAddress.isDefault) {
        _clearDefaultAddresses();
      }

      addresses[index] = updatedAddress;
      saveAddresses();

      // تحديث العنوان المحدد إذا كان هو نفس العنوان المحدث
      if (selectedAddress.value?.id == addressId) {
        selectedAddress.value = updatedAddress;
      }

      Get.snackbar(
        'Success',
        'Address updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// حذف عنوان
  void deleteAddress(String addressId) {
    final addressToDelete = addresses.firstWhere((addr) => addr.id == addressId);
    addresses.removeWhere((addr) => addr.id == addressId);
    saveAddresses();

    // إذا تم حذف العنوان المحدد، اختيار عنوان آخر
    if (selectedAddress.value?.id == addressId) {
      if (addresses.isNotEmpty) {
        selectedAddress.value = addresses.first;
      } else {
        selectedAddress.value = null;
        _addDefaultAddress();
      }
    }

    Get.snackbar(
      'Deleted',
      'Address deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// تعيين عنوان كعنوان افتراضي
  void setDefaultAddress(String addressId) {
    _clearDefaultAddresses();

    final index = addresses.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      addresses[index] = addresses[index].copyWith(isDefault: true);
      selectedAddress.value = addresses[index];
      saveAddresses();

      Get.snackbar(
        'Success',
        'Default address updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// اختيار عنوان
  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  /// إلغاء التعيين الافتراضي لجميع العناوين
  void _clearDefaultAddresses() {
    for (int i = 0; i < addresses.length; i++) {
      if (addresses[i].isDefault) {
        addresses[i] = addresses[i].copyWith(isDefault: false);
      }
    }
  }

  /// الحصول على العنوان الافتراضي
  Address? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// التحقق من وجود عناوين
  bool get hasAddresses => addresses.isNotEmpty;

  /// الحصول على عدد العناوين
  int get addressCount => addresses.length;
}
