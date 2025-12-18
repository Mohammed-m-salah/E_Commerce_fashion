import 'package:flutter/material.dart';

class Homeheader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String avatarAssetPath;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onThemeToggleTap;

  const Homeheader({
    super.key,
    required this.userName,
    this.greeting = "Good Morning",
    required this.avatarAssetPath,
    this.onNotificationTap,
    this.onCartTap,
    this.onThemeToggleTap,
  });

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.amber[300],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: _isNetworkImage(avatarAssetPath)
                  ? Image.network(
                      avatarAssetPath,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/avatar.jpg',
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                    )
                  : Image.asset(
                      avatarAssetPath,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $userName',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                greeting,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onNotificationTap,
            icon: Icon(Icons.notifications_none_outlined,
                size: 28, color: Colors.grey.shade600),
          ),
          IconButton(
            onPressed: onCartTap,
            icon: Icon(Icons.shopping_bag_outlined,
                size: 28, color: Colors.grey.shade600),
          ),
          IconButton(
            onPressed: onThemeToggleTap,
            icon: Icon(Icons.dark_mode, size: 28, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
