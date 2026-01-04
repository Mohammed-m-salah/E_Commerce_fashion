import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'offer_model.dart';

class OfferController extends GetxController {
  final supabase = Supabase.instance.client;

  var offers = <OfferModel>[].obs;

  var isLoading = true.obs;

  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await supabase
          .from('offers')
          .select('*, categories(name)')
          .order('created_at', ascending: false);

      debugPrint('📦 Raw offers from DB: ${response.length}');

      for (var item in response) {
        debugPrint('   - status: ${item['status']}, title: ${item['title']}');
      }

      final List<OfferModel> fetchedOffers =
          (response as List).map((json) => OfferModel.fromJson(json)).toList();

      for (var offer in fetchedOffers) {
        debugPrint('   📋 Offer: ${offer.title}');
        debugPrint('      status: ${offer.status}');
        debugPrint('      startDate: ${offer.startDate}');
        debugPrint('      endDate: ${offer.endDate}');
        debugPrint(
            '      usageLimit: ${offer.usageLimit}, usedCount: ${offer.usedCount}');
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

  List<OfferModel> getOffersForProduct(String productId) {
    return offers
        .where((offer) =>
            offer.isCurrentlyActive &&
            (offer.target == 'all' ||
                (offer.target == 'product' && offer.productId == productId)))
        .toList();
  }

  List<OfferModel> getOffersForCategory(String categoryId) {
    return offers
        .where((offer) =>
            offer.isCurrentlyActive &&
            (offer.target == 'all' ||
                (offer.target == 'category' && offer.categoryId == categoryId)))
        .toList();
  }

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

  double calculateDiscount(double originalPrice, OfferModel offer) {
    double discount;

    if (offer.isPercentage) {
      discount = originalPrice * (offer.discountValue / 100);
    } else {
      discount = offer.discountValue;
    }

    if (offer.maximumDiscount != null && discount > offer.maximumDiscount!) {
      discount = offer.maximumDiscount!;
    }

    return discount;
  }

  double calculateFinalPrice(double originalPrice, OfferModel offer) {
    if (offer.minimumPurchase != null &&
        originalPrice < offer.minimumPurchase!) {
      return originalPrice;
    }

    final discount = calculateDiscount(originalPrice, offer);
    return (originalPrice - discount).clamp(0, originalPrice);
  }

  Future<void> refreshOffers() async {
    await fetchOffers();
  }
}
