import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utilities/logout_user.dart';
import '../utilities/session_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool expirationAlerts = false;
  bool recipeReminders = false;
  bool shoppingListReminders = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userProvider, Widget? child) {
          // Loading state
          if (userProvider.isLoading && userProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (userProvider.error != null && userProvider.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  const Text('Failed to load profile'),
                  const SizedBox(height: 8),
                  Text(
                    userProvider.error!,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userProvider.loadProfile(), // Direct retry
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success state
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Profile Header
                  _buildProfileHeader(theme, userProvider.user),
                  
                  const SizedBox(height: 32),
                  
                  // Profile Section
                  _buildSection(
                    title: 'Profile',
                    children: <Widget>[
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Change Username',
                        onTap: () => _showChangeUsernameDialog(context, userProvider),
                      ),
                      const Divider(height: 1),
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        onTap: () => _showChangePasswordDialog(context, userProvider),
                      ),
                      const Divider(height: 1),
                      _buildSettingsTile(
                        icon: Icons.shelves,
                        title: 'Custom Products',
                        showChevron: true,
                        onTap: () {
                          // Navigate to custom products page
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notifications Section
                  _buildSection(
                    title: 'Notifications',
                    children: <Widget>[
                      _buildSwitchTile(
                        title: 'Expiration Alerts',
                        value: expirationAlerts,
                        onChanged: (bool val) => setState(() => expirationAlerts = val),
                      ),
                      _buildSwitchTile(
                        title: 'Recipe Reminders',
                        value: recipeReminders,
                        onChanged: (bool val) => setState(() => recipeReminders = val),
                      ),
                      _buildSwitchTile(
                        title: 'Shopping List Reminders',
                        value: shoppingListReminders,
                        onChanged: (bool val) => setState(() => shoppingListReminders = val),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Theme Section
                  _buildSection(
                    title: 'Appearance',
                    children: <Widget>[
                      _buildSettingsTile(
                        icon: Icons.palette_outlined,
                        title: 'Theme',
                        subtitle: 'Light',
                        showChevron: true,
                        onTap: () {
                          // Show theme picker
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Danger Zone
                  _buildDangerZone(theme, userProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Profile header with avatar and username
  Widget _buildProfileHeader(ThemeData theme, User? user) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 40,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user?.username ?? 'Guest',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section with title and children
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // Settings tile
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool showChevron = false,
    required VoidCallback onTap,
  }) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.textTheme.bodyLarge),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  // Switch tile
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: theme.textTheme.bodyLarge),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // Danger zone
  Widget _buildDangerZone(ThemeData theme, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Account Actions',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
          ),
          child: Column(
            children: <Widget>[
              _buildDangerTile(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () => _showLogoutDialog(context),
              ),
              Divider(height: 1, color: theme.colorScheme.error.withOpacity(0.2)),
              _buildDangerTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                onTap: () => _showDeleteAccountDialog(context, userProvider),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDangerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.error),
            const SizedBox(width: 16),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Change Username Dialog
  //
  // USERNAME VALIDATION FLOW:
  // 1. FIELD VALIDATOR - Immediate feedback
  //    • "Username cannot be empty"
  //    • "Username too long" (>30 chars)
  //
  // 2. USER PROVIDER - Business logic
  //    • "New username must be different" (checks current user)
  //    • "Network connection failed" (timeout/connection errors)
  //
  // 3. BACKEND API - Final enforcement
  //    • "Username cannot be empty" (redundant safety)
  //    • "Username must be 30 characters or less"
  //    • "Invalid characters" (regex: /^[\p{L}\p{N} ._'’-]+$/u)
  //.   • "Failed to update username" (database error)
  //
  // UI shows only one error at a time (prioritizes earlier layers)
  void _showChangeUsernameDialog(BuildContext context, UserProvider userProvider) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        Future<void> submit(UserProvider provider) async {
          if (!formKey.currentState!.validate()) return;
          
          final String? token = SessionController().token;
          if (token == null) return;

          final bool success = await provider.updateUsername(
            token,
            controller.text,
          );

          if (success && dialogContext.mounted) {
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(content: Text('Username updated successfully')),
            );
          }
        }

        return AlertDialog(
          title: const Text('Change Username'),
          content: Consumer<UserProvider>(
            builder: (_, UserProvider provider, __) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Username field
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'New Username',
                        border: const OutlineInputBorder(),
                        errorText: provider.error, // Show backend errors
                        errorStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      autofocus: true,
                      validator: (String? val) {
                        if (val == null || val.trim().isEmpty) return 'Username cannot be empty';
                        if (val.length > 30) return 'Too long';
                        return null;
                      },
                      onFieldSubmitted: (_) => submit(provider),
                      textInputAction: TextInputAction.done
                    ),
                  ],
                ),
              );
            },
          ),

          actions: [
            TextButton(
              onPressed: () {
                userProvider.clearError();
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            Consumer<UserProvider>(
              builder: (_, UserProvider provider, __) {
                return FilledButton(
                  onPressed: provider.isLoading ? null : () => submit(provider),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Change Password Dialog
  //
  // PASSWORD CHANGE VALIDATION FLOW:
  // 1. FIELD VALIDATOR - Immediate feedback
  //    • "Required" (empty field)
  //    • "Password must be at least 6 characters long"
  //
  // 2. USER PROVIDER - Business logic
  //    • "New password must be different from the old password"
  //    • "Network connection failed" (timeout/connection errors)
  //
  // 3. BACKEND API - Final enforcement & verification
  //    • "Current and new password are required"
  //    • "New password must be different from the old password" 
  //    • Password complexity validation
  //      - currently just < 6 characters check
  //    • "Current password is incorrect" (bcrypt comparison)
  //    • "Failed to update password" (database error)
  //
  // UI shows only one error at a time (prioritizes earlier layers).
  void _showChangePasswordDialog(BuildContext context, UserProvider userProvider) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final FocusNode currentPasswordFocusNode = FocusNode();
        final FocusNode newPasswordFocusNode = FocusNode();

        Future<void> submit(UserProvider provider) async {
          if (!formKey.currentState!.validate()) return;
          
          final String? token = SessionController().token;
          if (token == null) return;

          final bool success = await provider.changePassword(
            token,
            currentPasswordController.text,
            newPasswordController.text,
          );

          if (success && dialogContext.mounted) {
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')),
            );
          }
        }

        return AlertDialog(
          title: const Text('Change Password'),
          content: Consumer<UserProvider>(
            builder: (_, UserProvider provider, _) {
              return SizedBox(
                width: 320,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      // Current password field
                      TextFormField(
                        controller: currentPasswordController,
                        focusNode: currentPasswordFocusNode,
                        autofocus: true,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Current Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? val) => val == null || val.isEmpty ? 'Required' : null,
                        onChanged: (_) => provider.clearError(),
                        onFieldSubmitted: (_) => newPasswordFocusNode.requestFocus(),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // New password field
                      TextFormField(
                        controller: newPasswordController,
                        focusNode: newPasswordFocusNode,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? val) {
                          if (val == null || val.isEmpty) return 'Required';
                          if (val.length < 6) return 'Password must be 6+ characters long';
                          return null;
                        },
                        onChanged: (_) => provider.clearError(),
                        onFieldSubmitted: (_) => submit(provider),
                        textInputAction: TextInputAction.done,
                      ),
                      if (provider.error != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            provider.error!,
                            style: TextStyle(
                              color: Theme.of(dialogContext).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                userProvider.clearError();
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            Consumer<UserProvider>(
              builder: (_, provider, __) {
                return FilledButton(
                  onPressed: provider.isLoading ? null : () => submit(provider),
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Change'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog: Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              logoutUser(context);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  // Delete Account
  void _showDeleteAccountDialog(BuildContext context, UserProvider userProvider) {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final FocusNode passwordFocusNode = FocusNode();

      Future<void> submit(UserProvider provider) async {
        if (!formKey.currentState!.validate()) return;

        final String? token = SessionController().token;
        if (token == null) return;

        final bool success = await provider.deleteAccount(
          token,
          passwordController.text,
        );

        if (success && dialogContext.mounted) {
          Navigator.pop(dialogContext);
          logoutUser(dialogContext);
        }
      }

      return AlertDialog(
        title: const Text('Delete Account'),
        content: Consumer<UserProvider>(
          builder: (_, provider, __) {
            return SizedBox(
              width: 320, // Consistent width
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Warning message
                    const Text(
                      'This action cannot be undone. All your data will be permanently deleted.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Password field with validation
                    TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      autofocus: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        errorText: provider.error,
                      ),
                      validator: (String? val) {
                        if (val == null || val.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onChanged: (_) => provider.clearError(),
                      onFieldSubmitted: (_) => submit(provider),
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              userProvider.clearError();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          Consumer<UserProvider>(
            builder: (_, provider, __) {
              return FilledButton(
                onPressed: provider.isLoading ? null : () => submit(provider),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(dialogContext).colorScheme.error,
                  foregroundColor: Theme.of(dialogContext).colorScheme.onError,
                ),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Delete Account'),
              );
            },
          ),
        ],
      );
    },
  );
}
}