import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_button.dart';
import '../../shared/widgets/in_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _remember = true;
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _userController.text = 'admin';
    _passwordController.text = '123';
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final success = AuthService.login(
      _userController.text.trim(),
      _passwordController.text,
    );
    if (success) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      setState(() { _error = 'Usuario o contraseña incorrectos'; _loading = false; });
    }
  }

  void _quickLogin(String email, String password) {
    setState(() { _loading = true; _error = null; });
    _userController.text = email;
    _passwordController.text = password;
    AuthService.login(email, password);
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xxl,
                      MediaQuery.of(context).size.height * 0.08,
                      AppSpacing.xxl,
                      AppSpacing.huge,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.secondary, Color(0xFF1A3D5A)],
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/logo_indi.png', height: 72),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Control de Combustible',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Grupo INDI',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.huge, AppSpacing.xxl, AppSpacing.xxxl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        InTextField(
                          label: 'Usuario',
                          hint: 'Ingresa tu usuario',
                          controller: _userController,
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
                          textInputAction: TextInputAction.next,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa tu usuario' : null,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        InTextField(
                          label: 'Contraseña',
                          hint: 'Ingresa tu contraseña',
                          controller: _passwordController,
                          obscureText: _obscure,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _login(),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.errorBg,
                              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                                const SizedBox(width: AppSpacing.sm),
                                Text(_error!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _remember,
                                onChanged: (v) => setState(() => _remember = v ?? true),
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                side: const BorderSide(color: AppColors.border),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Recordar sesión', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        SizedBox(
                          height: 52,
                          child: InButton(
                            label: 'Ingresar',
                            onPressed: _loading ? null : _login,
                            icon: Icons.login_rounded,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.borderLight)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                              child: Text('Acceso rápido', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                            ),
                            Expanded(child: Divider(color: AppColors.borderLight)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(child: _RoleButton(icon: Icons.admin_panel_settings_outlined, label: 'Admin', color: AppColors.primary, onTap: () => _quickLogin('admin', '123'))),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: _RoleButton(icon: Icons.description_outlined, label: 'Adminis.', color: AppColors.info, onTap: () => _quickLogin('pedro', '123'))),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: _RoleButton(icon: Icons.person_outline_rounded, label: 'Operador', color: AppColors.success, onTap: () => _quickLogin('carlos', '123'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _RoleButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
