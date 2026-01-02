class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice; // السعر الأصلي قبل الخصم
  final double? discountPercentage; // نسبة الخصم
  final String imageUrl;
  final String category;
  final int stock;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.rating,
  });

  /// هل يوجد خصم على المنتج؟
  bool get hasDiscount {
    if (discountPercentage != null && discountPercentage! > 0) return true;
    if (originalPrice != null && originalPrice! > price) return true;
    return false;
  }

  /// حساب نسبة الخصم
  double get calculatedDiscount {
    if (discountPercentage != null && discountPercentage! > 0) {
      return discountPercentage!;
    }
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice! * 100);
    }
    return 0;
  }

  /// السعر الأصلي للعرض
  double get displayOriginalPrice {
    return originalPrice ?? price;
  }

  /// السعر الفعلي بعد الخصم (يُحسب تلقائياً)
  /// إذا كان هناك original_price و discount_percentage، يتم حساب السعر
  /// وإلا يُستخدم price العادي
  double get effectivePrice {
    // إذا كان هناك سعر أصلي ونسبة خصم، احسب السعر بعد الخصم
    if (originalPrice != null && discountPercentage != null && discountPercentage! > 0) {
      return originalPrice! * (1 - discountPercentage! / 100);
    }
    // إذا كان هناك سعر أصلي أكبر من السعر الحالي، استخدم السعر الحالي
    if (originalPrice != null && originalPrice! > price) {
      return price;
    }
    // وإلا استخدم السعر العادي
    return price;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      discountPercentage: json['discount_percentage'] != null
          ? (json['discount_percentage'] as num).toDouble()
          : null,
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'image_url': imageUrl,
      'category': category,
      'stock': stock,
      'rating': rating,
    };
  }
}
