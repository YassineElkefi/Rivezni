import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/theme_notifier.dart';
import 'package:rivezni/features/authentication/screens/login.dart';
import '../../../core/providers/auth_provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Text('Account Settings', style: textTheme.headlineSmall),
              // User Profile Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProfileRow(
                        context, 
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: authProvider.user?.email ?? "No email",
                      ),
                      const SizedBox(height: 8),
                      _buildProfileRow(
                        context, 
                        icon: Icons.person_outline,
                        label: 'Username',
                        value: authProvider.user?.displayName ?? "No username",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Theme Settings Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, 
                    vertical: 12.0
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            themeNotifier.themeMode == ThemeMode.dark 
                              ? Icons.dark_mode_outlined 
                              : Icons.light_mode_outlined,
                            color: Color.fromRGBO(82, 170, 94, 1.0)
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Dark Mode',
                            style: textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Switch(
                        value: themeNotifier.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeNotifier.toggleTheme(value);
                        },
                        activeColor: Color.fromRGBO(82, 170, 94, 1.0),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24, 
                    vertical: 12
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color.fromRGBO(82, 170, 94, 1.0),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}