import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final double total;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String image; // يمكن أن يكون URL أو asset path

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade700
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(),
            ),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderId,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text('\$$total',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء الصورة - يدعم كل من asset images و network images
  Widget _buildImage() {
    if (image.isEmpty) {
      return const Icon(
        Icons.shopping_bag_outlined,
        size: 30,
        color: Colors.grey,
      );
    }

    // إذا كانت الصورة URL (تبدأ بـ http أو https)
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.image_not_supported,
          size: 30,
          color: Colors.grey,
        ),
      );
    }

    // إذا كانت الصورة asset
    return Image.asset(
      image,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.image_not_supported,
          size: 30,
          color: Colors.grey,
        );
      },
    );
  }
}
