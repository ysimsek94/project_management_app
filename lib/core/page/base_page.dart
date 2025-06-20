import 'package:flutter/material.dart';
import '../widgets/app_custom_app_bar.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const BasePage({
    Key? key,
    required this.title,
    required this.child,
    this.showBackButton = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil if needed; otherwise ensure it's called in your root
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop<bool>(true);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: title,
          showBackButton: showBackButton,
          onBack: () => Navigator.of(context).pop<bool>(true),
        ),
        body: child,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
