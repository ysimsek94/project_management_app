import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/utils/app_styles.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_button.dart';

extension StringValidators on String {
  bool isValidEmail() => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(this);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form durumunu yöneten anahtar
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscure = true;

  void _onLoginPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().login(
          emailController.text.trim(),
          passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blueGrey.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.bigatekLogo,
                      height: 70,
                    ),
                    AppSizes.gapH40,
                    Text(
                      "Hoşgeldiniz",
                      style: AppTypography.bold10().copyWith(
                        fontSize: 24,
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
                    AppTextField(
                      hint: "E-mail",
                      textEditingController: emailController,
                      borderRadius: 12,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Email boş olamaz'
                          : null,
                    ),
                    AppSizes.gapH16,
                    AppTextField(
                      hint: "Şifre",
                      textEditingController: passwordController,
                      obscureText: _obscure,
                      borderRadius: 12,
                      suffixIcon: _obscure ? Icons.visibility_off : Icons.visibility,
                      onSuffixIconTap: () => setState(() => _obscure = !_obscure),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Şifre boş olamaz'
                          : val.length < 6
                              ? 'Şifre en az 6 karakter'
                              : null,
                    ),
                    AppSizes.gapH12,
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Şifremi Unuttum?",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  AppSizes.gapH16,
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          AppPreferences.setToken(state.user.token);
                          AppPreferences.setUsername(state.user.username);
                          AppPreferences.setAdSoyad(state.user.adSoyad);
                          Navigator.pushReplacementNamed(context, "/home");
                        } else if (state is LoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          width: double.infinity,
                          title: "Giriş Yap",
                          onClick: () => _onLoginPressed(context),
                          isLoading: state is LoginLoading,
                        );
                      },
                    ),
                    AppSizes.gapH40,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Copyright © 2025 BIGATEK',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
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