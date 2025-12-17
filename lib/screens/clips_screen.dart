import 'package:flutter/material.dart';

class ClipsScreen extends StatefulWidget {
  const ClipsScreen({super.key});

  @override
  State<ClipsScreen> createState() => _ClipsScreenState();
}

class _ClipsScreenState extends State<ClipsScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context, index) {
          return const ClipItem();
        },
      ),
    );
  }
}

class ClipItem extends StatelessWidget {
  const ClipItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          'assets/top10/masaya.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),
        ),
        // Right side action buttons
        Positioned(
          right: 16,
          bottom: 120,
          child: Column(
            children: [
              _ActionButton(
                imagePath: 'assets/icons_clips/whatsapp.png',
                label: 'WhatsApp',
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _ActionButton(
                imagePath: 'assets/icons_clips/like.png',
                label: 'Like',
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _ActionButton(
                imagePath: 'assets/icons_clips/save.png',
                label: 'Save',
                onTap: () {},
              ),
              const SizedBox(height: 18),
              _ActionButton(
                imagePath: 'assets/icons_clips/share.png',
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ),
        // Bottom content - SAFE AREA
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: Avatar + Name + Watch button
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/developers/Rectangle.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              color: Colors.grey,
                              size: 18,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Name
                    const Text(
                      'Egyptian Developers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Watch button
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Watch Orientation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                const Padding(
                  padding: EdgeInsets.only(right: 70),
                  child: Text(
                    'This is a Dummy Text to show only the case that we working on .',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 32,
            height: 32,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
