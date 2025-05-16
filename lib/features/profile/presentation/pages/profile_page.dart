import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/widgets/app_text_field.dart';
import 'package:project_management_app/core/widgets/app_custom_app_bar.dart';
import 'package:project_management_app/core/widgets/app_dialog.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../domain/entities/profile.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final userId = AppPreferences.adSoyad;
    if (userId != null) {
      context.read<ProfileCubit>().getProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profilim',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
            onPressed: () async {
              final confirmed = await AppDialog.showCustomDialog<bool>(
                context: context,
                title: 'Çıkış Yap',
                icon: Icons.logout,
                content: const Text('Çıkmak istediğinize emin misiniz?'),
                actions: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Hayır'),
                    ),
                  ),
                  AppSizes.gapW16,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Evet'),
                    ),
                  ),
                ],
              );
              if (confirmed == true) {
                AppPreferences.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (r) => false);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          if (state is ProfileLoaded) {
            final Profile profile = state.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 56,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.person,
                        size: 56, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 24),
                  // Name
                  Text(
                    '${profile.firstName} ${profile.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'T.C. Kimlik No: ${profile.tckn}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 32),
                  // Details form
                  AppTextField(
                    hint: 'Ad',
                    initialValue: profile.firstName,
                    readOnly: true,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hint: 'Soyad',
                    initialValue: profile.lastName,
                    readOnly: true,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hint: 'TCKN',
                    initialValue: profile.tckn,
                    readOnly: true,
                    prefixIcon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
