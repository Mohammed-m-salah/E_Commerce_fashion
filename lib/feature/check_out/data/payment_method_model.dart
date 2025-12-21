/// نموذج طريقة الدفع - يحتوي على معلومات طريقة الدفع
class PaymentMethod {
  final String id; // معرف فريد لطريقة الدفع
  final String type; // نوع الدفع (Credit Card, Debit Card, PayPal, Cash on Delivery)
  final String cardHolderName; // اسم صاحب البطاقة (للبطاقات فقط)
  final String cardNumber; // رقم البطاقة (مخفي جزئياً)
  final String expiryDate; // تاريخ الانتهاء (MM/YY)
  final String cvv; // رمز CVV (لن يتم حفظه للأمان)
  final bool isDefault; // هل هذه طريقة الدفع الافتراضية

  PaymentMethod({
    required this.id,
    required this.type,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    this.cvv = '', // لن نحفظ CVV للأمان
    this.isDefault = false,
  });

  /// تحويل PaymentMethod إلى JSON للحفظ في التخزين
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      // لا نحفظ CVV للأمان
      'isDefault': isDefault,
    };
  }

  /// إنشاء PaymentMethod من JSON عند القراءة من التخزين
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  /// إنشاء نسخة من PaymentMethod مع تعديل بعض الخصائص
  PaymentMethod copyWith({
    String? id,
    String? type,
    String? cardHolderName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// إخفاء رقم البطاقة جزئياً (عرض آخر 4 أرقام فقط)
  String get maskedCardNumber {
    if (cardNumber.length <= 4) return cardNumber;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $lastFour';
  }

  /// الحصول على نص عرض طريقة الدفع
  String get displayText {
    if (type == 'Cash on Delivery') {
      return 'Cash on Delivery';
    } else if (type == 'PayPal') {
      return 'PayPal - $cardHolderName';
    } else {
      return '$type - ${maskedCardNumber}';
    }
  }

  /// الحصول على أيقونة بناءً على نوع البطاقة
  String get cardBrand {
    if (cardNumber.isEmpty) return 'Unknown';

    final firstDigit = cardNumber[0];
    if (firstDigit == '4') return 'Visa';
    if (firstDigit == '5') return 'Mastercard';
    if (firstDigit == '3') return 'American Express';
    if (firstDigit == '6') return 'Discover';

    return 'Unknown';
  }
}
