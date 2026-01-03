/// نموذج العرض/الخصم
class OfferModel {
  final String id;
  final String title;
  final String discountType; // percentage, fixed
  final double discountValue;
  final double? minimumPurchase;
  final double? maximumDiscount;
  final String? code;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? usageLimit;
  final int usedCount;
  final String status; // active, inactive, expired
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? target; // all, product, category
  final String? productId;
  final String? categoryId;
  final String? categoryName; // اسم الفئة (يتم جلبه من جدول categories)

  OfferModel({
    required this.id,
    required this.title,
    required this.discountType,
    required this.discountValue,
    this.minimumPurchase,
    this.maximumDiscount,
    this.code,
    this.startDate,
    this.endDate,
    this.usageLimit,
    this.usedCount = 0,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.target,
    this.productId,
    this.categoryId,
    this.categoryName,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      discountType: json['discount_type']?.toString() ?? 'percentage',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      minimumPurchase: (json['minimum_purchase'] as num?)?.toDouble(),
      maximumDiscount: (json['maximum_discount'] as num?)?.toDouble(),
      code: json['code']?.toString(),
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      usageLimit: json['usage_limit'] as int?,
      usedCount: json['used_count'] as int? ?? 0,
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      target: json['target']?.toString(),
      productId: json['product_id']?.toString(),
      categoryId: json['category_id']?.toString(),
      // جلب اسم الفئة من العلاقة مع جدول categories
      categoryName: json['categories'] != null
          ? json['categories']['name']?.toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'discount_type': discountType,
      'discount_value': discountValue,
      'minimum_purchase': minimumPurchase,
      'maximum_discount': maximumDiscount,
      'code': code,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'usage_limit': usageLimit,
      'used_count': usedCount,
      'status': status,
      'target': target,
      'product_id': productId,
      'category_id': categoryId,
    };
  }

  /// هل العرض نشط حالياً؟
  bool get isCurrentlyActive {
    // التحقق من الحالة (case-insensitive)
    if (status.toLowerCase() != 'active') {
      print('   ⛔ status not active: $status');
      return false;
    }

    final now = DateTime.now();
    // التحقق من تاريخ البداية
    if (startDate != null && now.isBefore(startDate!)) {
      print('   ⛔ startDate in future: $startDate (now: $now)');
      return false;
    }
    // التحقق من تاريخ النهاية
    if (endDate != null && now.isAfter(endDate!)) {
      print('   ⛔ endDate passed: $endDate (now: $now)');
      return false;
    }

    // التحقق من حد الاستخدام
    if (usageLimit != null && usedCount >= usageLimit!) {
      print('   ⛔ usage limit reached: $usedCount / $usageLimit');
      return false;
    }

    return true;
  }

  /// هل هو خصم نسبة مئوية؟
  bool get isPercentage => discountType == 'percentage';

  /// نص الخصم للعرض
  String get discountText {
    if (isPercentage) {
      return '${discountValue.toStringAsFixed(0)}%';
    } else {
      return '\$${discountValue.toStringAsFixed(2)}';
    }
  }

  /// الوقت المتبقي للعرض
  Duration? get remainingTime {
    if (endDate == null) return null;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return Duration.zero;
    return endDate!.difference(now);
  }

  /// هل العرض على وشك الانتهاء (أقل من 24 ساعة)؟
  bool get isEndingSoon {
    final remaining = remainingTime;
    if (remaining == null) return false;
    return remaining.inHours < 24 && remaining.inSeconds > 0;
  }

  @override
  String toString() => 'OfferModel(id: $id, title: $title, discount: $discountText)';
}
