import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_auth.dart';
import 'admin_login_page.dart';
import 'glossary_admin_page.dart';

/// Auth gate: unauthenticated → login; authenticated non-admin → message; admin → CMS.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin'),
              leading: BackButton(
                onPressed: () => _goHome(context),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Authentication error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return const AdminLoginPage();
        }
        return FutureBuilder<bool>(
          key: ValueKey<String>(user.uid),
          future: userIsAdmin(user.uid),
          builder: (context, adminSnap) {
            if (adminSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (adminSnap.hasError) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Admin'),
                  leading: BackButton(
                    onPressed: () => _goHome(context),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Could not verify access: ${adminSnap.error}'),
                  ),
                ),
              );
            }
            if (adminSnap.data != true) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Admin'),
                  leading: BackButton(
                    onPressed: () => _goHome(context),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Not authorized',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This account does not have glossary editor access.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => FirebaseAuth.instance.signOut(),
                          child: const Text('Sign out'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const GlossaryAdminPage();
          },
        );
      },
    );
  }

  static void _goHome(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
    }
  }
}
