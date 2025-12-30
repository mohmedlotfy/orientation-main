import 'package:flutter/material.dart';
import '../widgets/orientation_logo.dart';
import '../widgets/auth_header.dart';
import '../screens/login_screen.dart';
import '../screens/latest_for_us_screen.dart';
import '../screens/continue_watching_screen.dart';
import '../screens/top_10_screen.dart';
import '../screens/projects_list_screen.dart';
import '../screens/developers_screen.dart';
import '../screens/areas_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const Color brandRed = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          children: [
            // Header with geometric background from AuthHeader and logo
            const DrawerHeader(),
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  DrawerMenuItem(
                    title: 'The latest for us',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LatestForUsScreen(),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Continue watching',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContinueWatchingScreen(),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Top 10',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Top10Screen(),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Projects in Northcoast',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectsListScreen(
                            title: 'Projects in Northcoast',
                          ),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Projects in Dubai',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectsListScreen(
                            title: 'Projects in Dubai',
                          ),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Projects in Oman',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectsListScreen(
                            title: 'Projects in Oman',
                          ),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Upcoming events',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Courses',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Developers',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DevelopersScreen(),
                        ),
                      );
                    },
                  ),
                  DrawerMenuItem(
                    title: 'Areas',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AreasScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Logout button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image (replace with your image path)
          Image.asset(
            'assets/menu_header.png', // ضع اسم الصورة هنا
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to geometric background if image not found
              return const GeometricBackground();
            },
          ),
          // Logo
          const Positioned(
            left: 24,
            bottom: 24,
            child: OrientationLogo(),
          ),
        ],
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const DrawerMenuItem({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.5),
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 2,
      ),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }
}

