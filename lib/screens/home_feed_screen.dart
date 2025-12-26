import 'package:flutter/material.dart';
import '../widgets/project_card.dart';
import 'project_details_screen.dart';
import 'latest_for_us_screen.dart';
import 'top_10_screen.dart';
import 'saved_screen.dart';
import 'developers_screen.dart';
import 'areas_screen.dart';
import 'projects_list_screen.dart';
import 'search_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final PageController _featuredController = PageController();
  int _currentFeaturedPage = 0;
  String _selectedFilter = 'Medical';

  final List<String> _filters = ['Medical', 'Commercial', 'Residential', 'Hotel'];

  static const Color brandRed = Color(0xFFE50914);

  // Featured projects data
  final List<Map<String, dynamic>> _featuredProjects = [
    {
      'title': 'LVERSAN',
      'subtitle': 'NORTH COAST',
      'label': 'PRESENTS',
      'image': 'assets/images/lversan.png',
      'isAsset': true,
      'gradientColors': [const Color(0xFF1a4a4a), const Color(0xFF0d2525)],
    },
    {
      'title': 'masaya',
      'subtitle': 'SIDI ABDELRAHMAN',
      'label': '',
      'image': 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      'gradientColors': [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
    },
    {
      'title': 'SEASHORE',
      'subtitle': 'RAS ELHEKMA',
      'label': '',
      'image': 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=1200',
      'gradientColors': [const Color(0xFF2d5a7b), const Color(0xFF1a3a52)],
    },
  ];

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Hero section with AppBar, Filters, and Carousel
          SliverToBoxAdapter(
            child: _buildHeroSection(),
          ),
          // Page indicator
          SliverToBoxAdapter(
            child: _buildPageIndicator(),
          ),
          // Sections
          SliverToBoxAdapter(
            child: _buildSection(
              'The latest for us',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LatestForUsScreen(),
                  ),
                );
              },
              child: _buildHorizontalProjectList(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Continue watching',
              onViewAll: () {},
              child: _buildContinueWatchingList(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Top 10',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Top10Screen(),
                  ),
                );
              },
              child: _buildTop10List(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Projects in Northcoast',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectsListScreen(
                      title: 'Projects in Northcoast',
                    ),
                  ),
                );
              },
              child: _buildNorthcoastProjects(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
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
              child: _buildDubaiProjects(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Projects in Oman',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectsListScreen(
                      title: 'Projects in Oman',
                    ),
                  ),
                );
              },
              child: _buildOmanProjects(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Upcoming Projects',
              onViewAll: () {},
              child: _buildUpcomingProjectsList(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Developers',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevelopersScreen(),
                  ),
                );
              },
              child: _buildDevelopersList(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSection(
              'Discover Areas',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AreasScreen(),
                  ),
                );
              },
              child: _buildAreaChips(),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  // Hero section with overlaying AppBar and Filters on Carousel
  Widget _buildHeroSection() {
    return SizedBox(
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Carousel - full width and height
          PageView.builder(
            controller: _featuredController,
            onPageChanged: (index) {
              setState(() {
                _currentFeaturedPage = index;
              });
            },
            itemCount: _featuredProjects.length,
            itemBuilder: (context, index) {
              final project = _featuredProjects[index];
              return _buildFeaturedCard(project);
            },
          ),
          // AppBar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _buildAppBar(),
            ),
          ),
          // Filter chips overlay
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _buildFilterChips(),
            ),
          ),
          // Watch button at bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: _buildWatchButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProjectDetailsScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_filled,
              color: Colors.white.withOpacity(0.9),
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text(
              'Watch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> project) {
    final gradientColors = project['gradientColors'] as List<Color>;
    final bool isAsset = project['isAsset'] ?? false;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        isAsset
            ? Image.asset(
                project['image'],
                fit: BoxFit.cover,
                alignment: Alignment.center,
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
            : Image.network(
                project['image'],
                fit: BoxFit.cover,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: gradientColors,
                      ),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
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
              ),
        // Color tint overlay (light at top)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientColors[0].withOpacity(0.3),
                gradientColors[1].withOpacity(0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.5],
            ),
          ),
        ),
        // Dark gradient at bottom - blends into black section below
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.95),
                Colors.black,
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 0.85, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Menu icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // Profile avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          // Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const Text(
                'AbdelRahman',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Search icon
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          // Bookmark icon
          IconButton(
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: _filters.map((filter) {
            final bool isSelected = _selectedFilter == filter;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                child: Container(
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_featuredProjects.length, (index) {
          final isActive = index == _currentFeaturedPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive ? brandRed : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSection(
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
                  fontSize: 18,
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

  Widget _buildHorizontalProjectList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildLatestCard(
            title: 'masaya',
            subtitle: 'SIDI ABDELRAHMAN',
            imageAsset: 'assets/top10/masaya.png',
            gradientColors: const [Color(0xFF4A90A4), Color(0xFF2d6a7a)],
          ),
          const SizedBox(width: 12),
          _buildLatestCard(
            title: 'THE ICON',
            subtitle: 'Cityscape',
            imageAsset: 'assets/top10/the_icon.png',
            gradientColors: const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
          ),
          const SizedBox(width: 12),
          _buildLatestCard(
            title: 'masaya',
            subtitle: 'FULLY FINISHED',
            imageAsset: 'assets/top10/masaya.png',
            gradientColors: const [Color(0xFF2d5a7b), Color(0xFF1a3a52)],
          ),
        ],
      ),
    );
  }

  Widget _buildLatestCard({
    required String title,
    required String subtitle,
    required String imageAsset,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProjectDetailsScreen(),
          ),
        );
      },
      child: Container(
        width: 160,
        height: 200,
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
              // Background Image from assets
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                    ),
                  );
                },
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
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              // Text content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueWatchingList() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildContinueWatchingItem(
            title: 'TAWNY',
            imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600',
            progress: 0.3,
          ),
          const SizedBox(width: 12),
          _buildContinueWatchingItem(
            title: 'SEASHORE',
            imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
            progress: 0.6,
          ),
          const SizedBox(width: 12),
          _buildContinueWatchingItem(
            title: 'masaya',
            imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600',
            progress: 0.45,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWatchingItem({
    required String title,
    required String imageUrl,
    required double progress,
  }) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: const Color(0xFFD4A574),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD4A574), Color(0xFFC49A6C)],
                    ),
                  ),
                );
              },
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
                ),
              ),
            ),
            // Title
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
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
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop10List() {
    // Alternating between masaya and the_icon like in Top10Screen
    final items = List.generate(10, (index) {
      return index.isEven 
          ? 'assets/top10/masaya.png' 
          : 'assets/top10/the_icon.png';
    });

    return SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RankedProjectCard(
              rank: index + 1,
              title: index.isEven ? 'masaya' : 'THE ICON',
              imageAsset: items[index],
              gradientColors: index.isEven
                  ? const [Color(0xFF4A90A4), Color(0xFF2d6a7a)]
                  : const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Top10Screen(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNorthcoastProjects() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildLargeProjectCard(
            title: 'LVERSAN',
            subtitle: 'NORTH COAST',
            imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
          ),
          const SizedBox(width: 12),
          _buildLargeProjectCard(
            title: 'masaya',
            subtitle: 'SIDI ABDELRAHMAN',
            imageUrl: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
          ),
        ],
      ),
    );
  }

  Widget _buildDubaiProjects() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildLargeProjectCard(
            title: 'Palm Jumeirah',
            subtitle: 'DUBAI',
            imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800',
          ),
          const SizedBox(width: 12),
          _buildLargeProjectCard(
            title: 'Downtown',
            subtitle: 'DUBAI MARINA',
            imageUrl: 'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=800',
          ),
        ],
      ),
    );
  }

  Widget _buildOmanProjects() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildLargeProjectCard(
            title: 'Muscat Hills',
            subtitle: 'OMAN',
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          ),
          const SizedBox(width: 12),
          _buildLargeProjectCard(
            title: 'Al Mouj',
            subtitle: 'MUSCAT',
            imageUrl: 'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?w=800',
          ),
        ],
      ),
    );
  }

  Widget _buildLargeProjectCard({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProjectDetailsScreen(),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 170,
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
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFF2a2a2a),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90A4), Color(0xFF2d6a7a)],
                      ),
                    ),
                  );
                },
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingProjectsList() {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildUpcomingItem(
            title: 'THE ICON',
            subtitle: 'Gardens',
            imageAsset: 'assets/top10/the_icon.png',
            gradientColors: [const Color(0xFF1a1a2e), const Color(0xFF16213e)],
            hasLogo: true,
          ),
          const SizedBox(width: 12),
          _buildUpcomingItem(
            title: 'masaya',
            subtitle: 'SIDI ABDELRAHMAN',
            imageAsset: 'assets/top10/masaya.png',
            gradientColors: [const Color(0xFF4A90A4), const Color(0xFF2d6a7a)],
            hasLogo: false,
          ),
          const SizedBox(width: 12),
          _buildUpcomingItem(
            title: 'THE ICON',
            subtitle: 'FULLY FINISHED UNITS',
            imageAsset: 'assets/top10/the_icon.png',
            gradientColors: [const Color(0xFF0d4f4f), const Color(0xFF1a6b6b)],
            hasLogo: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingItem({
    required String title,
    required String subtitle,
    required String imageAsset,
    required List<Color> gradientColors,
    bool hasLogo = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProjectDetailsScreen(),
          ),
        );
      },
      child: SizedBox(
        width: 180,
        height: 230,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image from assets - fills entire card
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                    ),
                  );
                },
              ),
              // Color gradient overlay on image
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gradientColors[0].withOpacity(0.6),
                        gradientColors[1].withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Dark gradient at bottom for text
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              // Logo in center (for THE ICON)
              if (hasLogo)
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Title and subtitle at bottom
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevelopersList() {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildDeveloperItem(
            name: 'HE',
            subtitle: 'HORIZON',
          ),
          const SizedBox(width: 12),
          _buildDeveloperItem(
            name: 'EGYPTIAN',
            subtitle: 'DEVELOPERS',
            hasIcon: true,
          ),
          const SizedBox(width: 12),
          _buildDeveloperItem(
            name: 'PAL',
            subtitle: '',
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperItem({
    required String name,
    required String subtitle,
    bool hasIcon = false,
  }) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasIcon)
            const Icon(
              Icons.account_balance,
              color: Color(0xFFB8860B),
              size: 20,
            ),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF8B7355),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) ...[
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF8B7355),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAreaChips() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildAreaChip('North Coast'),
          const SizedBox(width: 10),
          _buildAreaChip('Administrative Capital'),
          const SizedBox(width: 10),
          _buildAreaChip('Fifth Settlement'),
          const SizedBox(width: 10),
          _buildAreaChip('New Cairo'),
        ],
      ),
    );
  }

  Widget _buildAreaChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
