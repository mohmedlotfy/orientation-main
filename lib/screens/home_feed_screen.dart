import 'package:flutter/material.dart';
import '../widgets/project_card.dart';
import 'project_details_screen.dart';
import 'latest_for_us_screen.dart';
import 'top_10_screen.dart';
import 'saved_screen.dart';
import 'developers_screen.dart';
import 'areas_screen.dart';
import 'projects_list_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final PageController _featuredController = PageController();
  int _currentFeaturedPage = 0;
  String _selectedFilter = 'Helios';

  final List<String> _filters = ['Helios', 'Commercial', 'Residential', 'Coast'];

  static const Color brandRed = Color(0xFFE50914);

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverToBoxAdapter(
              child: _buildAppBar(),
            ),
            // Filter chips
            SliverToBoxAdapter(
              child: _buildFilterChips(),
            ),
            // Featured carousel
            SliverToBoxAdapter(
              child: _buildFeaturedCarousel(),
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
                child: _buildHorizontalProjectList(),
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
                child: _buildHorizontalProjectList(),
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
                child: _buildHorizontalProjectList(),
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
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
              border: Border.all(
                color: brandRed,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const Text(
                'Abdelrahman',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Action buttons
          IconButton(
            icon: Icon(
              Icons.bookmark_outline,
              color: Colors.white.withOpacity(0.8),
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
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.white.withOpacity(0.8),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? brandRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? brandRed : Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return SizedBox(
      height: 220,
      child: PageView(
        controller: _featuredController,
        onPageChanged: (index) {
          setState(() {
            _currentFeaturedPage = index;
          });
        },
        children: [
          FeaturedProjectCard(
            title: 'LVERS',
            subtitle: 'NORTH COAST',
            label: 'PRESENTED',
            gradientColors: const [Color(0xFF1a3535), Color(0xFF0d1a1a)],
            onWatch: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(),
                ),
              );
            },
          ),
          FeaturedProjectCard(
            title: 'SEASHORE',
            subtitle: 'RAS ELHEKMA',
            gradientColors: const [Color(0xFF2d5a7b), Color(0xFF1a3a52)],
            onWatch: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          return Container(
            width: index == _currentFeaturedPage ? 20 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: index == _currentFeaturedPage
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
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
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ProjectCard(
            title: 'Seashore',
            subtitle: 'FULLY FINISHED',
            gradientColors: const [Color(0xFF2d5a7b), Color(0xFF1a3a52)],
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
            gradientColors: const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
            onTap: () {},
          ),
          const SizedBox(width: 12),
          ProjectCard(
            title: 'masaya',
            gradientColors: const [Color(0xFF4A90A4), Color(0xFF2d6a7a)],
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWatchingList() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildContinueWatchingItem('TAWNY'),
          const SizedBox(width: 12),
          _buildContinueWatchingItem('TAWNY'),
        ],
      ),
    );
  }

  Widget _buildContinueWatchingItem(String title) {
    return Container(
      width: 140,
      height: 90,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4a6741), Color(0xFF3a5731)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTop10List() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RankedProjectCard(
              rank: index + 1,
              title: index % 2 == 0 ? 'masaya' : 'THE ICON',
              gradientColors: index % 2 == 0
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

  Widget _buildUpcomingProjectsList() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildUpcomingItem('THE ICON'),
          const SizedBox(width: 12),
          _buildUpcomingItem('Seashore'),
        ],
      ),
    );
  }

  Widget _buildUpcomingItem(String title) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            color: Colors.white.withOpacity(0.6),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopersList() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildDeveloperItem('THE ICON', 'EGYPT'),
          const SizedBox(width: 12),
          _buildDeveloperItem('Egyptian Developers', ''),
          const SizedBox(width: 12),
          _buildDeveloperItem('PAL', ''),
        ],
      ),
    );
  }

  Widget _buildDeveloperItem(String name, String country) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (country.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              country,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 9,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAreaChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildAreaChip('North Coast'),
          _buildAreaChip('Administrative Capital'),
        ],
      ),
    );
  }

  Widget _buildAreaChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }
}

