import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import './widgets/credentials_box_widget.dart';
import './widgets/eco_logo_widget.dart';
import './widgets/login_form_widget.dart';

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  late AnimationController _entranceController;
  late Animation<double> _logoScale;
  late Animation<double> _formSlide;
  late Animation<double> _fadeIn;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _formSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _entranceController.forward();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prefillCredentials(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Replace with real authentication API call
    await Future.delayed(const Duration(milliseconds: 1200));

    const mockEmail = 'omar.hassan@econova.io';
    const mockPassword = 'EcoNova@2026';

    if (_emailController.text.trim() == mockEmail &&
        _passwordController.text == mockPassword) {
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashboardScreen,
          (route) => false,
        );
      }
    } else {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: 'Invalid credentials — use the demo accounts below to sign in',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: AppTheme.statusFull,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Green gradient header background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.42,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF2E7D32),
                    Color(0xFF388E3C),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(13),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(13),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 480 : double.infinity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 0),
                    child: Column(
                      children: [
                        // Logo section
                        SizedBox(height: size.height * 0.06),
                        AnimatedBuilder(
                          animation: _logoScale,
                          builder: (context, child) => Transform.scale(
                            scale: _logoScale.value,
                            child: child,
                          ),
                          child: const EcoLogoWidget(),
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: _fadeIn,
                          builder: (context, child) =>
                              Opacity(opacity: _fadeIn.value, child: child),
                          child: Column(
                            children: [
                              Text(
                                'EcoNova',
                                style: GoogleFonts.dmSans(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Smart Waste Management',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withAlpha(204),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        // Form card
                        AnimatedBuilder(
                          animation: _formSlide,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(0, _formSlide.value),
                            child: Opacity(
                              opacity: _fadeIn.value,
                              child: child,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Sign in to monitor your baskets',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF757575),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  LoginFormWidget(
                                    formKey: _formKey,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    isLoading: _isLoading,
                                    onSubmit: _handleLogin,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Credentials box
                        AnimatedBuilder(
                          animation: _fadeIn,
                          builder: (context, child) =>
                              Opacity(opacity: _fadeIn.value, child: child),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CredentialsBoxWidget(
                              onPrefill: _prefillCredentials,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
