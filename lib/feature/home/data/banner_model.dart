import 'package:flutter/material.dart';

class BannerModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? linkType;
  final String? linkId;
  final int position;
  final String status; // active, inactive, scheduled
  final DateTime? startDate;
  final DateTime? endDate;
  final int views;
  final int clicks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ألوان التدرج (يمكن تخصيصها حسب الـ position أو linkType)
  final Color gradientStart;
  final Color gradientEnd;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.linkType,
    this.linkId,
    this.position = 0,
    this.status = 'active',
    this.startDate,
    this.endDate,
    this.views = 0,
    this.clicks = 0,
    this.createdAt,
    this.updatedAt,
    this.gradientStart = const Color(0xFFFF5722),
    this.gradientEnd = const Color(0xFFFF8A65),
  });

  /// تحويل JSON إلى BannerModel
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final position = json['position'] ?? 0;
    final colors = _getGradientColors(position);

    return BannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      linkType: json['link_type']?.toString(),
      linkId: json['link_id']?.toString(),
      position:
          position is int ? position : int.tryParse(position.toString()) ?? 0,
      status: json['status']?.toString() ?? 'active',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
      views: json['views'] ?? 0,
      clicks: json['clicks'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      gradientStart: colors.$1,
      gradientEnd: colors.$2,
    );
  }

  /// تحويل BannerModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'link_type': linkType,
      'link_id': linkId,
      'position': position,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'views': views,
      'clicks': clicks,
    };
  }

  /// ألوان تدرج متنوعة حسب الموضع
  static (Color, Color) _getGradientColors(int position) {
    final gradients = [
      (const Color(0xFFFF5722), const Color(0xFFFF8A65)), // برتقالي
      (const Color(0xFF2196F3), const Color(0xFF64B5F6)), // أزرق
      (const Color(0xFF9C27B0), const Color(0xFFBA68C8)), // بنفسجي
      (const Color(0xFF4CAF50), const Color(0xFF81C784)), // أخضر
      (const Color(0xFFE91E63), const Color(0xFFF48FB1)), // وردي
      (const Color(0xFF00BCD4), const Color(0xFF4DD0E1)), // سماوي
    ];
    return gradients[position % gradients.length];
  }

  /// التحقق من أن البانر نشط حالياً
  bool get isCurrentlyActive {
    if (status != 'active') return false;

    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;

    return true;
  }

  /// بانرات افتراضية للاستخدام كـ fallback
  static List<BannerModel> get defaultBanners => [
        BannerModel(
          id: '1',
          title: 'New Collection',
          description: 'Discount 50% for first transaction',
          imageUrl: '',
          position: 0,
          gradientStart: const Color(0xFFFF5722),
          gradientEnd: const Color(0xFFFF8A65),
        ),
        BannerModel(
          id: '2',
          title: 'Summer Sale',
          description: 'Up to 70% off on selected items',
          imageUrl: '',
          position: 1,
          gradientStart: const Color(0xFF2196F3),
          gradientEnd: const Color(0xFF64B5F6),
        ),
        BannerModel(
          id: '3',
          title: 'Flash Deals',
          description: 'Limited time offers',
          imageUrl: '',
          position: 2,
          gradientStart: const Color(0xFF9C27B0),
          gradientEnd: const Color(0xFFBA68C8),
        ),
      ];

  @override
  String toString() => 'BannerModel(id: $id, title: $title, status: $status)';
}
