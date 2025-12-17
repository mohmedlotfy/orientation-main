import 'package:flutter/material.dart';
import '../widgets/orientation_logo.dart';
import 'account_info_screen.dart';
import 'join_us_screen.dart';
import 'login_screen.dart';
import 'add_reel_screen.dart';
import 'change_inventory_screen.dart';
import 'about_us_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';

enum UserRole { sales, developer }

class AccountScreen extends StatelessWidget {
  final UserRole userRole;

  const AccountScreen({
    super.key,
    this.userRole = UserRole.developer,
  });

  static const Color brandRed = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header with profile
          _buildHeader(),
          // Menu items
          Expanded(
            child: _buildMenuList(context),
          ),
          // Logout button
          _buildLogoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF150000),
      ),
      child: Column(
        children: [
          // Logo
          const OrientationLogo(),
          const SizedBox(height: 24),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1a1a1a),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 45,
            ),
          ),
          const SizedBox(height: 16),
          // Name
          const Text(
            'Abdelrahman Zahran',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          // Role
          Text(
            userRole == UserRole.developer ? 'Developer' : 'Sales',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final menuItems = userRole == UserRole.developer
        ? [
            _MenuItem(title: 'Account', subtitle: 'Information', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountInfoScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Join', subtitle: 'Us', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinUsScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Add', subtitle: 'Reel', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddReelScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Change', subtitle: 'Inventory', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeInventoryScreen(),
                ),
              );
            }),
            _MenuItem(title: 'About', subtitle: 'Us', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Privacy', subtitle: 'Policy', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Terms and', subtitle: 'Conditions', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsScreen(),
                ),
              );
            }),
          ]
        : [
            _MenuItem(title: 'Account', subtitle: 'Information', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountInfoScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Join', subtitle: 'Us', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinUsScreen(),
                ),
              );
            }),
            _MenuItem(title: 'About', subtitle: 'Us', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Privacy', subtitle: 'Policy', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            }),
            _MenuItem(title: 'Terms and', subtitle: 'Conditions', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsConditionsScreen(),
                ),
              );
            }),
          ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: menuItems.length,
      itemBuilder: (context, index) => menuItems[index],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: SizedBox(
        width: double.infinity,
        height: 48,
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
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color brandRed = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                color: brandRed,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' $subtitle',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.5),
        size: 24,
      ),
    );
  }
}

