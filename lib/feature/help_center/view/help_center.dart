import 'package:e_commerce_fullapp/core/utils/app_textstile.dart';
import 'package:e_commerce_fullapp/feature/help_center/view/widget/header_helpcenter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> gridItems = [
      {'icon': Icons.help_outline, 'text': 'FAQ'},
      {'icon': Icons.payment_outlined, 'text': 'Payment'},
      {'icon': Icons.local_shipping_outlined, 'text': 'Shipping'},
      {'icon': Icons.person_outline, 'text': 'Profile'},
    ];

    final List<Map<String, dynamic>> popularQuestions = [
      {'icon': Icons.local_shipping_outlined, 'text': 'How to track my order?'},
      {'icon': Icons.replay_outlined, 'text': 'How to return item?'},
      {'icon': Icons.payment_outlined, 'text': 'Payment methods available?'},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 24.0 : 16.0;
    final maxContentWidth = 800.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderHelpCenter(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),

                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                              const Gap(12),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search for help...',
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade500,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(24),

                        // Popular Questions Section
                        Text(
                          'Popular Questions',
                          style: AppTextStyle.h4.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const Gap(12),

                        // Popular Questions List
                        ...popularQuestions.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildQuestionCard(
                                context: context,
                                icon: item['icon'],
                                text: item['text'],
                                isDark: isDark,
                                theme: theme,
                              ),
                            )),

                        const Gap(20),

                        // Help Categories Section
                        Text(
                          'Help Categories',
                          style: AppTextStyle.h4.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const Gap(12),

                        // Grid of Categories - Responsive
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final gridWidth = constraints.maxWidth;
                            final crossAxisCount = gridWidth > 600
                                ? 4
                                : gridWidth > 400
                                    ? 3
                                    : 2;
                            final itemWidth =
                                (gridWidth - (crossAxisCount - 1) * 12) /
                                    crossAxisCount;
                            final itemHeight = itemWidth * 0.85;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: gridItems.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: itemWidth / itemHeight,
                              ),
                              itemBuilder: (context, index) {
                                final item = gridItems[index];
                                return _buildCategoryCard(
                                  context: context,
                                  icon: item['icon'],
                                  text: item['text'],
                                  isDark: isDark,
                                  theme: theme,
                                );
                              },
                            );
                          },
                        ),

                        const Gap(24),

                        // Contact Support Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      Colors.orange.shade900.withOpacity(0.4),
                                      Colors.deepOrange.shade900.withOpacity(0.4)
                                    ]
                                  : [Colors.orange.shade50, Colors.amber.shade50],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.orange.shade800.withOpacity(0.3)
                                  : Colors.orange.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFff5722).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.headset_mic_outlined,
                                  size: 32,
                                  color: Color(0xFFff5722),
                                ),
                              ),
                              const Gap(12),
                              Text(
                                'Still need help?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const Gap(16),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 12,
                                runSpacing: 10,
                                children: [
                                  _buildContactButton(
                                    icon: Icons.chat_bubble_outline,
                                    label: 'Chat',
                                    isDark: isDark,
                                    onTap: () {},
                                  ),
                                  _buildContactButton(
                                    icon: Icons.email_outlined,
                                    label: 'Email',
                                    isDark: isDark,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Material(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFff5722).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFff5722),
                  size: 24,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required IconData icon,
    required String text,
    required bool isDark,
    required ThemeData theme,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final iconSize = (cardWidth * 0.22).clamp(20.0, 32.0);
        final iconPadding = (cardWidth * 0.08).clamp(8.0, 14.0);
        final fontSize = (cardWidth * 0.12).clamp(12.0, 16.0);

        return Material(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(cardWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(iconPadding),
                      decoration: BoxDecoration(
                        color: const Color(0xFFff5722).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: const Color(0xFFff5722),
                      ),
                    ),
                  ),
                  SizedBox(height: cardWidth * 0.06),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFff5722),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const Gap(4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
