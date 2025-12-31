import 'package:e_commerce_fullapp/feature/home/data/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// وحدة التحكم بالبانرات
/// تجلب البانرات من Supabase وتديرها
class BannerController extends GetxController {
  final supabase = Supabase.instance.client;

  /// قائمة البانرات (Observable)
  var banners = <BannerModel>[].obs;

  /// حالة التحميل
  var isLoading = true.obs;

  /// رسالة الخطأ
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  /// جلب البانرات من Supabase
  ///
  /// الخطوات:
  /// 1. جلب البانرات النشطة (status = 'active')
  /// 2. ترتيبها حسب position
  /// 3. فلترة حسب start_date و end_date
  /// 4. في حالة الفشل، استخدام البانرات الافتراضية
  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // جلب البانرات النشطة مرتبة حسب position
      final response = await supabase
          .from('banners')
          .select()
          .eq('status', 'active')
          .order('position', ascending: true);

      // تحويل البيانات إلى قائمة BannerModel
      final List<BannerModel> fetchedBanners = (response as List)
          .map((json) => BannerModel.fromJson(json))
          .where((banner) => banner.isCurrentlyActive) // فلترة حسب التاريخ
          .toList();

      if (fetchedBanners.isNotEmpty) {
        banners.value = fetchedBanners;
        debugPrint('✅ تم تحميل ${fetchedBanners.length} بانر من Supabase');
      } else {
        // استخدام البانرات الافتراضية إذا لم توجد بانرات
        banners.value = BannerModel.defaultBanners;
        debugPrint('ℹ️ لا توجد بانرات نشطة، استخدام البانرات الافتراضية');
      }
    } on PostgrestException catch (e) {
      // خطأ في Supabase
      debugPrint('❌ خطأ Supabase: ${e.message}');
      errorMessage.value = e.message;

      // استخدام البانرات الافتراضية
      banners.value = BannerModel.defaultBanners;
      debugPrint('ℹ️ استخدام البانرات الافتراضية بسبب الخطأ');
    } catch (e) {
      // خطأ عام
      debugPrint('❌ خطأ غير متوقع: $e');
      errorMessage.value = e.toString();

      // استخدام البانرات الافتراضية
      banners.value = BannerModel.defaultBanners;
    } finally {
      isLoading.value = false;
    }
  }

  /// تسجيل نقرة على البانر
  Future<void> recordClick(String bannerId) async {
    try {
      // زيادة عداد النقرات
      await supabase.rpc('increment_banner_clicks', params: {'banner_id': bannerId});
      debugPrint('✅ تم تسجيل نقرة على البانر: $bannerId');
    } catch (e) {
      debugPrint('❌ خطأ في تسجيل النقرة: $e');
    }
  }

  /// تسجيل مشاهدة للبانر
  Future<void> recordView(String bannerId) async {
    try {
      // زيادة عداد المشاهدات
      await supabase.rpc('increment_banner_views', params: {'banner_id': bannerId});
    } catch (e) {
      debugPrint('❌ خطأ في تسجيل المشاهدة: $e');
    }
  }

  /// إعادة تحميل البانرات
  Future<void> refreshBanners() async {
    await fetchBanners();
  }
}
