import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/preferences/AppPreferences.dart';
import '../../../../core/widgets/app_custom_app_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
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
      appBar: const CustomAppBar(title: 'Profilim',showBackButton: false,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final Profile profile = state.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${profile.firstName} ${profile.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'T.C. Kimlik No: ${profile.tckn}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AppTextField(
                          hint: 'Ad',
                          initialValue: profile.firstName,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          hint: 'Soyad',
                          initialValue: profile.lastName,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          hint: 'TCKN',
                          initialValue: profile.tckn,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
