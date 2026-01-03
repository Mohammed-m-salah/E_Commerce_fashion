import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'offer_model.dart';

/// وحدة التحكم بالعروض والخصومات
class OfferController extends GetxController {
  final supabase = Supabase.instance.client;

  /// قائمة العروض
  var offers = <OfferModel>[].obs;

  /// حالة التحميل
  var isLoading = true.obs;

  /// رسالة الخطأ
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  /// جلب العروض من Supabase
  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // جلب جميع العروض مع اسم الفئة من جدول categories
      final response = await supabase
          .from('offers')
          .select('*, categories(name)')
          .order('created_at', ascending: false);

      debugPrint('📦 Raw offers from DB: ${response.length}');

      // طباعة بيانات كل عرض للتشخيص
      for (var item in response) {
        debugPrint('   - status: ${item['status']}, title: ${item['title']}');
      }

      // تحويل البيانات إلى قائمة OfferModel (بدون فلتر مؤقتاً)
      final List<OfferModel> fetchedOffers = (response as List)
          .map((json) => OfferModel.fromJson(json))
          .toList();

      // طباعة تفاصيل كل عرض
      for (var offer in fetchedOffers) {
        debugPrint('   📋 Offer: ${offer.title}');
        debugPrint('      status: ${offer.status}');
        debugPrint('      startDate: ${offer.startDate}');
        debugPrint('      endDate: ${offer.endDate}');
        debugPrint('      usageLimit: ${offer.usageLimit}, usedCount: ${offer.usedCount}');
      }

      offers.value = fetchedOffers;
      debugPrint('✅ تم تحميل ${fetchedOffers.length} عرض من Supabase');
    } on PostgrestException catch (e) {
      debugPrint('❌ خطأ Supabase: ${e.message}');
      errorMessage.value = e.message;
    } catch (e) {
      debugPrint('❌ خطأ غير متوقع: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// جلب العروض حسب المنتج
  List<OfferModel> getOffersForProduct(String productId) {
    return offers
        .where((offer) =>
            offer.isCurrentlyActive &&
            (offer.target == 'all' ||
                (offer.target == 'product' && offer.productId == productId)))
        .toList();
  }

  /// جلب العروض حسب الفئة
  List<OfferModel> getOffersForCategory(String categoryId) {
    return offers
        .where((offer) =>
            offer.isCurrentlyActive &&
            (offer.target == 'all' ||
                (offer.target == 'category' && offer.categoryId == categoryId)))
        .toList();
  }

  /// جلب عرض بواسطة الكود
  OfferModel? getOfferByCode(String code) {
    try {
      return offers.firstWhere(
        (offer) =>
            offer.code?.toLowerCase() == code.toLowerCase() &&
            offer.isCurrentlyActive,
      );
    } catch (e) {
      return null;
    }
  }

  /// التحقق من صلاحية كود الخصم
  Future<OfferModel?> validateCode(String code) async {
    try {
      final response = await supabase
          .from('offers')
          .select()
          .eq('code', code.toUpperCase())
          .eq('status', 'active')
          .maybeSingle();

      if (response == null) return null;

      final offer = OfferModel.fromJson(response);
      if (!offer.isCurrentlyActive) return null;

      return offer;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من الكود: $e');
      return null;
    }
  }

  /// حساب الخصم على السعر
  double calculateDiscount(double originalPrice, OfferModel offer) {
    double discount;

    if (offer.isPercentage) {
      discount = originalPrice * (offer.discountValue / 100);
    } else {
      discount = offer.discountValue;
    }

    // تطبيق الحد الأقصى للخصم
    if (offer.maximumDiscount != null && discount > offer.maximumDiscount!) {
      discount = offer.maximumDiscount!;
    }

    return discount;
  }

  /// حساب السعر بعد الخصم
  double calculateFinalPrice(double originalPrice, OfferModel offer) {
    // التحقق من الحد الأدنى للشراء
    if (offer.minimumPurchase != null &&
        originalPrice < offer.minimumPurchase!) {
      return originalPrice;
    }

    final discount = calculateDiscount(originalPrice, offer);
    return (originalPrice - discount).clamp(0, originalPrice);
  }

  /// إعادة تحميل العروض
  Future<void> refreshOffers() async {
    await fetchOffers();
  }
}
