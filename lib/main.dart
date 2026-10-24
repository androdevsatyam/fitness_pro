import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/customer/customer_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const FitProApp()),
  );
}

class FitProApp extends StatelessWidget {
  const FitProApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'HOMEFIT | Your space. Your pace.',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme(),
    home: const CustomerShell(),
  );
}
