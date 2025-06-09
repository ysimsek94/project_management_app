import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/constants/app_assets.dart';
import 'package:project_management_app/core/widgets/app_alerts.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_button.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';



/// Kullanıcının e-posta ve şifre girdiği giriş sayfası.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Key to handle form validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  late final TextEditingController _tcController;
  late final TextEditingController _passwordController;

  // Controls whether the password is obscured
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _tcController = TextEditingController();
    _passwordController = TextEditingController();

    // Load saved credentials
    final savedTc = AppPreferences.tcKimlikNo ?? '';
    final savedPassword = AppPreferences.password ?? '';
    if (savedTc.isNotEmpty && savedPassword.isNotEmpty) {
      _tcController.text = savedTc;
      _passwordController.text = savedPassword;
      _rememberMe = true;
    }
  }

  @override
  void dispose() {
    _tcController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// TC Kimlik No alanı doğrulama
  String? _validateTcKimlikNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'TC Kimlik No boş bırakılamaz';
    }
    if (value.length != 11) {
      return 'TC Kimlik No 11 haneli olmalıdır';
    }
    return null;
  }

  /// Şifre alanı doğrulama
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş bırakılamaz';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }
    return null;
  }

  /// Validate inputs and trigger login event
  void _onLoginPressed() {
    if (_formKey.currentState?.validate() != true) return;
    // Trim TC Kimlik No and use exact password text
    context.read<LoginCubit>().login(
          _tcController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // Tek ton, çok açık gri arka plan
          color: const Color(0xFFF9FAFB),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      AppAssets.bigatekLogo,
                      height: 60,
                    ),
                    const SizedBox(height: 32),

                    // Başlık metni
                    Text(
                      'Hoşgeldiniz',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Alt metin
                    Text(
                      'Hesabınıza giriş yapın',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // TC Kimlik No alanı
                    AppTextField(
                      hint: 'TC Kimlik No',
                      textEditingController: _tcController,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      validator: _validateTcKimlikNo,
                    ),
                    const SizedBox(height: 16),

                    // Şifre alanı
                    AppTextField(
                      hint: 'Şifre',
                      textEditingController: _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 12),

                    // Beni Hatırla seçeneği
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (val) => setState(() => _rememberMe = val ?? false),
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Beni Hatırla',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Giriş Yap butonu
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginNavigate) {
                          if (_rememberMe) {
                            AppPreferences.setTcKimlikNo(_tcController.text.trim());
                            AppPreferences.setPassword(_passwordController.text);
                          } else {
                            AppPreferences.removeCredentials();
                          }
                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                        } else if (state is LoginFailure) {
                          AppAlerts.showError(context, state.message);
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          width: double.infinity,
                          title: state is LoginLoading ? '' : 'Giriş Yap',
                          onClick: _onLoginPressed,
                          isLoading: state is LoginLoading,
                        );
                      },
                    ),
                    const SizedBox(height: 40),

                    // Alt bilgi
                    Text(
                      'Copyright © 2025 BIGATEK',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}