import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/constants/app_assets.dart';
import 'package:project_management_app/core/constants/app_sizes.dart';
import 'package:project_management_app/core/utils/app_styles.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_button.dart';
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
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // Controls whether the password is obscured
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// E-posta alanı doğrulama
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta boş bırakılamaz';
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
    // Trim email and use exact password text
    context.read<LoginCubit>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Giriş ekranı için gradyan arka plan
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.blueGrey.shade50,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      AppAssets.bigatekLogo,
                      height: 70,
                    ),
                    AppSizes.gapH40,

                    // Başlık metni
                    Text(
                      'Hoşgeldiniz',
                      style: AppTypography.bold24().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSizes.gapH12,
                    Text(
                      'Lütfen giriş yapın',
                      style: AppTypography.medium12().copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    AppSizes.gapH32,

                    // E-posta alanı ve doğrulama
                    AppTextField(
                      hint: 'E-mail',
                      textEditingController: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      borderRadius: 12,
                      // E-posta alanı için doğrulama metodu
                      validator: _validateEmail,
                    ),
                    AppSizes.gapH16,

                    // Şifre alanı ve görünürlük değiştirme
                    AppTextField(
                      hint: 'Şifre',
                      textEditingController: _passwordController,
                      obscureText: _obscurePassword,
                      borderRadius: 12,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      // Şifre alanı için doğrulama metodu
                      validator: _validatePassword,
                    ),
                    AppSizes.gapH12,

                    // Şifremi Unuttum bağlantısı
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Handle forgot password
                        },
                        child: Text(
                          'Şifremi Unuttum?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    AppSizes.gapH16,

                    // Yükleme durumlu Giriş Yap butonu
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginNavigate) {
                          // Başarılı login sonrası ana sayfaya yönlendir
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        } else if (state is LoginFailure) {
                          // Hata mesajını göster
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          width: double.infinity,
                          title: 'Giriş Yap',
                          onClick: _onLoginPressed,
                          isLoading: state is LoginLoading,
                        );
                      },
                    ),
                    AppSizes.gapH40,

                    // Alt bilgi
                    const Text(
                      'Copyright © 2025 BIGATEK',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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