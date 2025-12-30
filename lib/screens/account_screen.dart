import 'package:flutter/material.dart';
import '../widgets/orientation_logo.dart';
import '../services/api/auth_api.dart';
import '../utils/auth_helper.dart';
import 'account_info_screen.dart';
import 'join_us_screen.dart';
import 'login_screen.dart';
import 'add_reel_screen.dart';
import 'change_inventory_screen.dart';
import 'about_us_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'admin_dashboard_screen.dart';

enum UserRole { user, developer, admin }

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static const Color brandRed = Color(0xFFE50914);
  final AuthApi _authApi = AuthApi();
  
  String _userName = 'User';
  String _userEmail = '';
  String _userRole = 'user';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userInfo = await _authApi.getStoredUserInfo();
    if (mounted) {
      setState(() {
        _userName = userInfo['username'] ?? 'User';
        _userEmail = userInfo['email'] ?? '';
        _userRole = userInfo['role'] ?? 'user';
        _isLoading = false;
      });
    }
  }

  UserRole _getUserRole() {
    switch (_userRole.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'developer':
        return UserRole.developer;
      default:
        return UserRole.user;
    }
  }

  Future<void> _handleLogout() async {
    await _authApi.logout();
    if (!mounted) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

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
          _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          const SizedBox(height: 4),
          // Role
          Text(
            _getUserRole() == UserRole.admin
                ? 'Admin'
                : _getUserRole() == UserRole.developer
                    ? 'Developer'
                    : 'User',
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
    final userRole = _getUserRole();
    final menuItems = <_MenuItem>[];
    
    // All users can see these
    menuItems.add(
      _MenuItem(title: 'Account', subtitle: 'Information', onTap: () async {
        final isAuth = await AuthHelper.requireAuth(context);
        if (!isAuth) return;
        
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountInfoScreen(),
          ),
        );
        // Reload user data if profile was updated
        if (result == true) {
          _loadUserData();
        }
      }),
    );

    // Admin only: Dashboard
    if (userRole == UserRole.admin) {
      menuItems.add(
        _MenuItem(title: 'Admin', subtitle: 'Dashboard', onTap: () async {
          final isAuth = await AuthHelper.requireAuth(context);
          if (!isAuth) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboardScreen(),
            ),
          );
        }),
      );
    }

    // Users can apply to become developers
    if (userRole == UserRole.user) {
      menuItems.add(
        _MenuItem(title: 'Join', subtitle: 'Us', onTap: () async {
          final isAuth = await AuthHelper.requireAuth(context);
          if (!isAuth) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JoinUsScreen(),
            ),
          );
        }),
      );
    }

    // Developers can add reels and change inventory
    if (userRole == UserRole.developer || userRole == UserRole.admin) {
      menuItems.add(
        _MenuItem(title: 'Add', subtitle: 'Reel', onTap: () async {
          final isAuth = await AuthHelper.requireAuth(context);
          if (!isAuth) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddReelScreen(),
            ),
          );
        }),
      );
      menuItems.add(
        _MenuItem(title: 'Change', subtitle: 'Inventory', onTap: () async {
          final isAuth = await AuthHelper.requireAuth(context);
          if (!isAuth) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangeInventoryScreen(),
            ),
          );
        }),
      );
    }

    // All users can see these
    menuItems.addAll([
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
    ]);

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
          onPressed: _handleLogout,
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

