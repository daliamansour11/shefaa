import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resourses/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/user_entity.dart';
import '../notifiers/auth_notifier.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  UserRole _selectedRole = UserRole.patient;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).register(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      fullName: _nameCtrl.text,
      phone: _phoneCtrl.text,
      role: _selectedRole,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is AuthAuthenticated) {
        context.go('/home');
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Role selector
                _RoleSelector(
                  selected: _selectedRole,
                  onChanged: isLoading
                      ? null
                      : (role) => setState(() => _selectedRole = role),
                ),
                const SizedBox(height: 24),

                AuthTextField(
                  label: AppStrings.fullName,
                  controller: _nameCtrl,
                  validator: Validators.fullName,
                  prefixIcon: const Icon(Icons.person_outline),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),

                AuthTextField(
                  label: AppStrings.email,
                  controller: _emailCtrl,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),

                AuthTextField(
                  label: AppStrings.phone,
                  controller: _phoneCtrl,
                  validator: Validators.phone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),

                AuthTextField(
                  label: AppStrings.password,
                  controller: _passwordCtrl,
                  validator: Validators.password,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),

                AuthTextField(
                  label: AppStrings.confirmPassword,
                  controller: _confirmCtrl,
                  validator: (v) => Validators.confirmPassword(v, _passwordCtrl.text),
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(AppStrings.register),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.haveAccount),
                    TextButton(
                      onPressed: isLoading ? null : () => context.pop(),
                      child: const Text(AppStrings.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole>? onChanged;

  const _RoleSelector({required this.selected, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleCard(
            label: AppStrings.loginAsPatient,
            icon: Icons.person_outline,
            isSelected: selected == UserRole.patient,
            onTap: onChanged == null ? null : () => onChanged!(UserRole.patient),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RoleCard(
            label: AppStrings.loginAsDoctor,
            icon: Icons.medical_services_outlined,
            isSelected: selected == UserRole.doctor,
            onTap: onChanged == null ? null : () => onChanged!(UserRole.doctor),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const _RoleCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? primary.withOpacity(0.08) : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? primary : null, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}