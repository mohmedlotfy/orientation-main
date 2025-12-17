import 'package:flutter/material.dart';
import '../widgets/project_card.dart';
import 'project_details_screen.dart';
import 'latest_for_us_screen.dart';
import 'projects_list_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const Color brandRed = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(context),
            // Search bar
            _buildSearchBar(),
            // Results
            Expanded(
              child: _buildResults(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 28,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for a project....',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // The latest for us section
          _buildSection(
            context,
            'The latest for us',
            onViewAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LatestForUsScreen(),
                ),
              );
            },
            child: _buildLatestList(context),
          ),
          // Continue watching section
          _buildSection(
            context,
            'Continue watching',
            onViewAll: () {},
            child: _buildContinueWatchingList(),
          ),
          // Projects in Dubai section
          _buildSection(
            context,
            'Projects in Dubai',
            onViewAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectsListScreen(
                    title: 'Projects in Dubai',
                  ),
                ),
              );
            },
            child: _buildDubaiList(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title, {
    required VoidCallback onViewAll,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: brandRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildLatestList(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _SearchProjectCard(
            title: 'Seashore',
            subtitle: 'FULLY FINISHED UNITS',
            imageAsset: 'assets/top10/masaya.png',
            hasPromo: true,
            gradientColors: const [Color(0xFF5a8a9a), Color(0xFF3a6a7a)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          _SearchProjectCard(
            title: 'THE ICON',
            subtitle: 'Gardens',
            imageAsset: 'assets/top10/the_icon.png',
            gradientColors: const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWatchingList() {
    return SizedBox(
      height: 145,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _ContinueWatchingCard(
            title: 'Tawny',
            progress: 0.4,
            imageAsset: 'assets/top10/masaya.png',
          ),
          const SizedBox(width: 12),
          _ContinueWatchingCard(
            title: 'Tawny',
            progress: 0.6,
            imageAsset: 'assets/top10/the_icon.png',
          ),
        ],
      ),
    );
  }

  Widget _buildDubaiList(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ProjectCard(
            title: 'Seashore',
            imageUrl: null,
            gradientColors: const [Color(0xFF5a8a9a), Color(0xFF3a6a7a)],
            width: 150,
            height: 150,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          ProjectCard(
            title: 'THE ICON',
            imageUrl: null,
            gradientColors: const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
            width: 150,
            height: 150,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SearchProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageAsset;
  final List<Color> gradientColors;
  final bool hasPromo;
  final VoidCallback? onTap;

  const _SearchProjectCard({
    required this.title,
    required this.subtitle,
    this.imageAsset,
    required this.gradientColors,
    this.hasPromo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (imageAsset != null)
                Image.asset(
                  imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: gradientColors,
                        ),
                      ),
                    );
                  },
                )
              else
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ),
                  ),
                ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              // Title at top
              Positioned(
                top: 16,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Promo badges at bottom
              if (hasPromo)
                Positioned(
                  bottom: 14,
                  left: 12,
                  child: Row(
                    children: [
                      _PromoBadge(text: '5%'),
                      const SizedBox(width: 8),
                      _PromoBadge(text: '8'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBadge extends StatelessWidget {
  final String text;

  const _PromoBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ContinueWatchingCard extends StatelessWidget {
  final String title;
  final double progress;
  final String? imageAsset;

  const _ContinueWatchingCard({
    required this.title,
    required this.progress,
    this.imageAsset,
  });

  static const Color brandRed = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                if (imageAsset != null)
                  Image.asset(
                    imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFd4c4b0), Color(0xFFc4b4a0)],
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFd4c4b0), Color(0xFFc4b4a0)],
                      ),
                    ),
                  ),
                // Title overlay
                Center(
                  child: Text(
                    'TAWNY',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                // Progress bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.black.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 40),
            Text(
              '01:45 H',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

