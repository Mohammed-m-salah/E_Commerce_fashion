import 'package:e_commerce_fullapp/feature/cart/data/cart_item_model.dart';

/// نموذج الطلب - يحتوي على كل معلومات الطلب
class Order {
  final String id; // معرف الطلب الفريد
  final List<CartItem> items; // المنتجات المطلوبة
  final double subtotal; // المجموع الفرعي
  final double shipping; // تكلفة الشحن
  final double tax; // الضريبة
  final double total; // المجموع الكلي
  final String status; // حالة الطلب (Active, Completed, Cancelled)
  final DateTime orderDate; // تاريخ الطلب
  final String shippingAddress; // عنوان الشحن
  final String paymentMethod; // طريقة الدفع

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.status,
    required this.orderDate,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  /// تحويل Order إلى JSON للحفظ في التخزين
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  /// إنشاء Order من JSON عند القراءة من التخزين
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      shipping: json['shipping'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      status: json['status'],
      orderDate: DateTime.parse(json['orderDate']),
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
    );
  }

  /// إنشاء نسخة من Order مع تعديل بعض الخصائص
  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? subtotal,
    double? shipping,
    double? tax,
    double? total,
    String? status,
    DateTime? orderDate,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shipping: shipping ?? this.shipping,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  /// حساب عدد المنتجات في الطلب
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
