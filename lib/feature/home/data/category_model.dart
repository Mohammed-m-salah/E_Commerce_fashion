class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  /// تحويل JSON إلى Category object
  /// يُستخدم عند استلام البيانات من Supabase
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  /// تحويل Category object إلى JSON
  /// يُستخدم عند إرسال البيانات إلى Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// فئة "الكل" الافتراضية
  static Category get allCategory => Category(
        id: 'all',
        name: 'All',
      );

  @override
  String toString() => 'Category(id: $id, name: $name)';
}
