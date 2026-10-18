import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const _yellow = Color(0xFFFFD12E);
const _red = Color(0xFFD92332);
const _ink = Color(0xFF242521);
const _muted = Color(0xFF74766F);
const _canvas = Color(0xFFFFF7F4);
const _loginBlue = Color(0xFF347DF1);
const _loginYellow = Color(0xFFFECC2A);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciho Print Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _yellow,
          primary: _red,
          surface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        navigationBarTheme: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return IconThemeData(
              color: states.contains(WidgetState.selected) ? _red : _muted,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              color: states.contains(WidgetState.selected) ? _red : _muted,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w800
                  : FontWeight.w500,
            );
          }),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _yellow,
          foregroundColor: _ink,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const PrintShopHome()),
    );
  }

  Future<void> _showRecoveryDialog() async {
    final recoveryController = TextEditingController(
      text: _emailController.text.trim(),
    );
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Lupa password?'),
        content: TextField(
          controller: recoveryController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email atau nomor HP'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permintaan pemulihan password dicatat.'),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: _red),
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
    recoveryController.dispose();
  }

  void _showSocialNotice(String provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Login dengan $provider belum dikonfigurasi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showRegisterNotice() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Daftar akun'),
        content: const Text(
          'Pendaftaran akun akan tersedia setelah layanan akun diaktifkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _loginYellow,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final headerHeight = (constraints.maxWidth / 2.25).clamp(
            150.0,
            300.0,
          );
          return Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: _loginYellow)),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: headerHeight,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/login_hero_clean.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 20,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xFFFFF9E9,
                                        ).withValues(alpha: 0.3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        child: Stack(
                          children: [
                            const Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      _loginYellow,
                                      Color(0xFFFFF9E9),
                                      Color(0xFFFFF9E9),
                                    ],
                                    stops: [0, 0.14, 1],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: LayoutBuilder(
                                builder: (context, sheetConstraints) => SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(
                                    24,
                                    16,
                                    24,
                                    20 +
                                        MediaQuery.of(
                                          context,
                                        ).viewPadding.bottom,
                                  ),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 480,
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight:
                                              (sheetConstraints.maxHeight -
                                                      36 -
                                                      MediaQuery.of(
                                                        context,
                                                      ).viewPadding.bottom)
                                                  .clamp(0.0, double.infinity)
                                                  .toDouble(),
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Color(0xFF182943),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(height: 14),
                                              const Text(
                                                'E-mail',
                                                style: TextStyle(
                                                  color: Color(0xFF263447),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              TextFormField(
                                                controller: _emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration:
                                                    _loginInputDecoration(
                                                      hint: 'contoh@email.com',
                                                      icon: Icons.mail_outline,
                                                    ),
                                                validator: (value) {
                                                  final input =
                                                      value?.trim() ?? '';
                                                  final isEmail = RegExp(
                                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                                  ).hasMatch(input);
                                                  final isPhone = RegExp(
                                                    r'^\+?[0-9]{8,15}$',
                                                  ).hasMatch(input);
                                                  if (!isEmail && !isPhone) {
                                                    return 'Masukkan email atau nomor HP yang valid';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              const Text(
                                                'Password',
                                                style: TextStyle(
                                                  color: Color(0xFF263447),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              TextFormField(
                                                controller: _passwordController,
                                                obscureText: !_passwordVisible,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onFieldSubmitted: (_) =>
                                                    _login(),
                                                decoration:
                                                    _loginInputDecoration(
                                                      hint: 'Masukkan password',
                                                      icon: Icons.lock_outline,
                                                    ).copyWith(
                                                      suffixIcon: IconButton(
                                                        tooltip:
                                                            _passwordVisible
                                                            ? 'Sembunyikan password'
                                                            : 'Lihat password',
                                                        onPressed: () => setState(
                                                          () => _passwordVisible =
                                                              !_passwordVisible,
                                                        ),
                                                        icon: Icon(
                                                          _passwordVisible
                                                              ? Icons
                                                                    .visibility_off_outlined
                                                              : Icons
                                                                    .visibility_outlined,
                                                          size: 19,
                                                          color: const Color(
                                                            0xFF8A96A5,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                validator: (value) {
                                                  if ((value ?? '').length <
                                                      6) {
                                                    return 'Password minimal 6 karakter';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              SizedBox(
                                                height: 44,
                                                child: FilledButton(
                                                  onPressed: _login,
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor: _loginBlue,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 4,
                                                    shadowColor: _loginBlue
                                                        .withValues(
                                                          alpha: 0.35,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Log In',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      SizedBox(width: 9),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_rounded,
                                                        size: 17,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: TextButton(
                                                  onPressed:
                                                      _showRecoveryDialog,
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF64758B),
                                                    minimumSize: const Size(
                                                      0,
                                                      36,
                                                    ),
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  ),
                                                  child: const Text(
                                                    'Forgot Password',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              const Center(
                                                child: Text(
                                                  'OR',
                                                  style: TextStyle(
                                                    color: Color(0xFF8994A2),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                height: 44,
                                                child: OutlinedButton(
                                                  onPressed: () =>
                                                      _showSocialNotice(
                                                        'Google',
                                                      ),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF263447),
                                                    backgroundColor:
                                                        const Color(0xFFF6F8FC),
                                                    side: BorderSide.none,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'G',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF4285F4,
                                                          ),
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        'Continue With Google',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              SizedBox(
                                                height: 44,
                                                child: OutlinedButton.icon(
                                                  onPressed: () =>
                                                      _showSocialNotice(
                                                        'Apple',
                                                      ),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF263447),
                                                    backgroundColor:
                                                        const Color(0xFFF6F8FC),
                                                    side: BorderSide.none,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.apple,
                                                    size: 20,
                                                  ),
                                                  label: const Text(
                                                    'Continue With Apple',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Don\'t have an account? ',
                                                    style: TextStyle(
                                                      color: Color(0xFF7E8998),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        _showRegisterNotice,
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          _loginBlue,
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: const Size(
                                                        0,
                                                        32,
                                                      ),
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: const Text(
                                                      'Register',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 18),
                                              const Row(
                                                children: [
                                                  Expanded(
                                                    child: _LoginBenefit(
                                                      icon: Icons.print_rounded,
                                                      label:
                                                          'High Quality\nPrinting',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: _LoginBenefit(
                                                      icon: Icons
                                                          .verified_user_rounded,
                                                      label:
                                                          'Trusted\n& Professional',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: _LoginBenefit(
                                                      icon: Icons
                                                          .local_shipping_rounded,
                                                      label: 'Fast\nDelivery',
                                                    ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        12,
                        10,
                        12,
                        12 + MediaQuery.of(context).viewPadding.bottom,
                      ),
                      child: const Text(
                        '© 2026 CIHOPRINTSHOP. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF58728E), fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

InputDecoration _loginInputDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF6F8FC),
    hintStyle: const TextStyle(color: Color(0xFF9AA6B5), fontSize: 12),
    prefixIcon: Icon(icon, size: 18, color: Color(0xFF6D91BA)),
    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
  );
}

class _LoginBenefit extends StatelessWidget {
  const _LoginBenefit({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 420;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF1672DF), size: compact ? 21 : 27),
        SizedBox(width: compact ? 4 : 7),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFF173B70),
              fontSize: compact ? 8 : 10,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrintProduct {
  const _PrintProduct({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String name;
  final String category;
  final String description;
  final int price;
  final String unit;
  final IconData icon;
  final Color color;
}

class _PurchaseOrder {
  const _PurchaseOrder({
    required this.number,
    required this.items,
    required this.itemCount,
    required this.total,
    required this.placedAt,
  });

  final String number;
  final List<String> items;
  final int itemCount;
  final int total;
  final DateTime placedAt;
}

const _products = <_PrintProduct>[
  _PrintProduct(
    name: 'Cetak Dokumen',
    category: 'Dokumen',
    description: 'A4, hitam putih atau warna',
    price: 500,
    unit: '/ lembar',
    icon: Icons.description_outlined,
    color: Color(0xFFE9F1FF),
  ),
  _PrintProduct(
    name: 'Cetak Foto',
    category: 'Foto',
    description: 'Kertas glossy, warna tajam',
    price: 3000,
    unit: '/ lembar',
    icon: Icons.photo_outlined,
    color: Color(0xFFFFE7DF),
  ),
  _PrintProduct(
    name: 'Banner & Spanduk',
    category: 'Promosi',
    description: 'Bahan kuat untuk luar ruang',
    price: 35000,
    unit: '/ m²',
    icon: Icons.campaign_outlined,
    color: Color(0xFFFFF0C2),
  ),
  _PrintProduct(
    name: 'Stiker Custom',
    category: 'Promosi',
    description: 'Potong sesuai bentuk desainmu',
    price: 25000,
    unit: '/ m²',
    icon: Icons.auto_awesome_outlined,
    color: Color(0xFFE5F4E8),
  ),
  _PrintProduct(
    name: 'Kartu Nama',
    category: 'Bisnis',
    description: 'Cetak dua sisi, finishing rapi',
    price: 45000,
    unit: '/ 100 pcs',
    icon: Icons.badge_outlined,
    color: Color(0xFFF0E7FF),
  ),
  _PrintProduct(
    name: 'Brosur & Flyer',
    category: 'Bisnis',
    description: 'Pilihan ukuran dan jenis kertas',
    price: 1500,
    unit: '/ lembar',
    icon: Icons.menu_book_outlined,
    color: Color(0xFFE3F3F2),
  ),
];

const _categories = ['Semua', 'Dokumen', 'Foto', 'Promosi', 'Bisnis'];

class PrintShopHome extends StatefulWidget {
  const PrintShopHome({super.key});

  @override
  State<PrintShopHome> createState() => _PrintShopHomeState();
}

class _PrintShopHomeState extends State<PrintShopHome> {
  int _selectedTab = 0;
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  String _customerName = 'Ahmad';
  String _customerPhone = '';
  bool _notificationsEnabled = true;
  String _appLanguage = 'Bahasa Indonesia';
  bool _showCart = false;
  bool _showStoreInfo = false;
  final Map<String, int> _cart = {};
  final List<_PurchaseOrder> _purchaseHistory = [];

  int get _cartCount => _cart.values.fold(0, (sum, quantity) => sum + quantity);

  String get _customerInitials {
    final nameParts = _customerName.trim().split(RegExp(r'\s+'));
    final initials = nameParts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return initials.isEmpty ? 'AK' : initials;
  }

  List<_PrintProduct> get _visibleProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Semua' || product.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _addToCart(_PrintProduct product) {
    setState(() {
      _cart.update(product.name, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} ditambahkan ke keranjang'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _changeQuantity(_PrintProduct product, int delta) {
    setState(() {
      final quantity = (_cart[product.name] ?? 0) + delta;
      if (quantity <= 0) {
        _cart.remove(product.name);
      } else {
        _cart[product.name] = quantity;
      }
    });
  }

  int _cartTotal() {
    return _products.fold(
      0,
      (total, product) => total + product.price * (_cart[product.name] ?? 0),
    );
  }

  String _rupiah(int amount) {
    final digits = amount.toString();
    final formatted = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted';
  }

  /*
  @override
  Widget build(BuildContext context) {
    final showingOverlay = _showCart || _showStoreInfo;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        leading: showingOverlay
            ? IconButton(
                tooltip: 'Kembali',
                onPressed: () => setState(() {
                  _showCart = false;
                  _showStoreInfo = false;
                }),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: showingOverlay
        ? Text(_showCart ? 'Keranjang' : 'Tentang Toko')
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat datang,',
              style: TextStyle(color: _muted, fontSize: 11, height: 1.1),
            ),
            Text(
              'Halo, $_customerName!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
          ],
        ),
      actions: showingOverlay
        ? null
        : [
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () => _showAccountNotice(
              'Notifikasi',
              'Belum ada notifikasi baru.',
            ),
            icon: const Badge(
              smallSize: 8,
              backgroundColor: _red,
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 2),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _selectedTab = 3),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Text(
                  _customerInitials,
                  style: const TextStyle(
                                  color: _loginBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      body: SafeArea(
        top: false,
        child: _showCart
          ? _buildCart()
          : _showStoreInfo
            ? _buildStoreInfo()
            : IndexedStack(
              index: _selectedTab,
              children: [
                _buildHome(),
                _buildCatalog(showSearch: true),
                _buildPurchaseHistory(),
                _buildProfile(),
              ],
            ),
      bottomNavigationBar: showingOverlay
        ? null
        : NavigationBar(
          selectedIndex: _selectedTab,
          onDestinationSelected: (index) =>
            setState(() => _selectedTab = index),
          backgroundColor: Colors.white,
          indicatorColor: _yellow.withValues(alpha: 0.65),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Produk',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Riwayat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
    );
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return initials.isEmpty ? 'AK' : initials;
  }

  List<_PrintProduct> get _visibleProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Semua' || product.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _addToCart(_PrintProduct product) {
    setState(() {
      _cart.update(product.name, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} ditambahkan ke keranjang'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _changeQuantity(_PrintProduct product, int delta) {
    setState(() {
      final quantity = (_cart[product.name] ?? 0) + delta;
      if (quantity <= 0) {
        _cart.remove(product.name);
      } else {
        _cart[product.name] = quantity;
      }
    });
  }

  int _cartTotal() {
    return _products.fold(
      0,
      (total, product) => total + product.price * (_cart[product.name] ?? 0),
    );
  }

  String _rupiah(int amount) {
    final digits = amount.toString();
    final formatted = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final showingOverlay = _showCart || _showStoreInfo;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        leading: showingOverlay
            ? IconButton(
                tooltip: 'Kembali',
                onPressed: () => setState(() {
                  _showCart = false;
                  _showStoreInfo = false;
                }),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: showingOverlay
            ? Text(_showCart ? 'Keranjang' : 'Tentang toko')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Selamat datang,',
                    style: TextStyle(color: _muted, fontSize: 11, height: 1.1),
                  ),
                  Text(
                    'Halo, $_customerName!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
        actions: showingOverlay
            ? null
            : [
                IconButton(
                  tooltip: 'Notifikasi',
                  onPressed: () => _showAccountNotice(
                    'Notifikasi',
                    'Belum ada notifikasi baru.',
                  ),
                  icon: const Badge(
                    smallSize: 8,
                    backgroundColor: _red,
                    child: Icon(Icons.notifications_none_rounded),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 2),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _selectedTab = 3),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Text(
                        _customerInitials,
                        style: const TextStyle(
                          color: _red,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
      ),
      body: SafeArea(
        top: false,
        child: _showCart
            ? _buildCart()
            : _showStoreInfo
            ? _buildStoreInfo()
            : IndexedStack(
                index: _selectedTab,
                children: [
                  _buildHome(),
                  _buildCatalog(showSearch: true),
                  _buildPurchaseHistory(),
                  _buildProfile(),
                ],
              ),
      ),
      bottomNavigationBar: showingOverlay
          ? null
          : NavigationBar(
              selectedIndex: _selectedTab,
              onDestinationSelected: (index) =>
                  setState(() => _selectedTab = index),
              backgroundColor: Colors.white,
              indicatorColor: _yellow.withValues(alpha: 0.65),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Produk',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Riwayat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profil',
                ),
              ],
            ),
    );
  }

  Widget _buildHome() {
      */

  @override
  Widget build(BuildContext context) {
    final showingOverlay = _showCart || _showStoreInfo;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        leading: showingOverlay
            ? IconButton(
                tooltip: 'Kembali',
                onPressed: () => setState(() {
                  _showCart = false;
                  _showStoreInfo = false;
                }),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: showingOverlay
            ? Text(_showCart ? 'Keranjang' : 'Tentang Toko')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Selamat datang,',
                    style: TextStyle(color: _muted, fontSize: 11, height: 1.1),
                  ),
                  Text(
                    'Halo, $_customerName!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
        actions: showingOverlay
            ? null
            : [
                IconButton(
                  tooltip: 'Notifikasi',
                  onPressed: () => _showAccountNotice(
                    'Notifikasi',
                    'Belum ada notifikasi baru.',
                  ),
                  icon: const Badge(
                    smallSize: 8,
                    backgroundColor: _red,
                    child: Icon(Icons.notifications_none_rounded),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 2),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _selectedTab = 3),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Text(
                        _customerInitials,
                        style: const TextStyle(
                          color: _red,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
      ),
      body: SafeArea(
        top: false,
        child: _showCart
            ? _buildCart()
            : _showStoreInfo
            ? _buildStoreInfo()
            : IndexedStack(
                index: _selectedTab,
                children: [
                  _buildHome(),
                  _buildCatalog(showSearch: true),
                  _buildPurchaseHistory(),
                  _buildProfile(),
                ],
              ),
      ),
      bottomNavigationBar: showingOverlay
          ? null
          : NavigationBar(
              selectedIndex: _selectedTab,
              onDestinationSelected: (index) =>
                  setState(() => _selectedTab = index),
              backgroundColor: Colors.white,
              indicatorColor: _yellow.withValues(alpha: 0.65),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Produk',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Riwayat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profil',
                ),
              ],
            ),
    );
  }

  Widget _buildHome() {
    final featured = _visibleProducts.take(4).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        _buildSearchField(),
        const SizedBox(height: 18),
        _buildPromoBanner(),
        const SizedBox(height: 25),
        _sectionHeading(
          'Mau cetak apa?',
          action: 'Lihat semua',
          onAction: () {
            setState(() => _selectedTab = 1);
          },
        ),
        const SizedBox(height: 12),
        _buildCategoryStrip(),
        const SizedBox(height: 24),
        _sectionHeading(
          'Layanan populer',
          action: 'Lihat semua',
          onAction: () {
            setState(() => _selectedTab = 1);
          },
        ),
        const SizedBox(height: 12),
        _buildProductGrid(featured),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 210,
        color: _red,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: -76,
              right: -40,
              child: Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  color: _yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 78,
              bottom: -96,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CETAK JADI LEBIH MUDAH',
                      style: TextStyle(
                        color: _red,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Ada yang mau\ndicetak hari ini?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Upload desain, pilih bahan, lalu kami kerjakan.',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => setState(() => _selectedTab = 1),
                    style: FilledButton.styleFrom(
                      backgroundColor: _yellow,
                      foregroundColor: _red,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Buat Pesanan'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Cari banner, stiker, brosur...',
        hintStyle: const TextStyle(color: _muted, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: _muted),
        suffixIcon: const Icon(Icons.tune_rounded, color: _red, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryStrip() {
    const categoryData = [
      ('Dokumen', Icons.description_outlined, Color(0xFFE9F1FF)),
      ('Foto', Icons.photo_outlined, Color(0xFFFFE7DF)),
      ('Promosi', Icons.campaign_outlined, Color(0xFFFFF0C2)),
      ('Bisnis', Icons.badge_outlined, Color(0xFFE5F4E8)),
    ];
    return SizedBox(
      height: 98,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoryData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final (name, icon, color) = categoryData[index];
          return InkWell(
            onTap: () => setState(() {
              _selectedCategory = name;
              _selectedTab = 1;
            }),
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: _ink, size: 25),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeading(
    String title, {
    String? action,
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: _red),
            child: Text(
              action,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }

  Widget _buildCatalog({required bool showSearch}) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        const Text(
          'Pilih layanan',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        const Text(
          'Kualitas rapi untuk setiap kebutuhan cetak.',
          style: TextStyle(color: _muted, fontSize: 12),
        ),
        if (showSearch) ...[const SizedBox(height: 16), _buildSearchField()],
        const SizedBox(height: 14),
        _buildCategoryFilters(),
        const SizedBox(height: 16),
        if (_visibleProducts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(child: Text('Layanan tidak ditemukan.')),
          )
        else
          _buildProductGrid(_visibleProducts),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final selected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: _yellow,
              backgroundColor: Colors.white,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: selected ? _ink : _muted,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductGrid(List<_PrintProduct> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 720 ? 3 : 2;
        return GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 212,
          ),
          itemBuilder: (context, index) => _ProductCard(
            product: products[index],
            quantity: _cart[products[index].name] ?? 0,
            priceLabel: _rupiah(products[index].price),
            onAdd: () => _addToCart(products[index]),
          ),
        );
      },
    );
  }

  Widget _buildCart() {
    final cartProducts = _products
        .where((product) => (_cart[product.name] ?? 0) > 0)
        .toList();
    if (cartProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF0C2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: _red,
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 7),
              const Text(
                'Yuk pilih layanan cetak yang kamu butuhkan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => setState(() {
                  _showCart = false;
                  _selectedTab = 1;
                }),
                icon: const Icon(Icons.grid_view_rounded),
                label: const Text('Jelajahi produk'),
                style: FilledButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            children: [
              const Text(
                'Keranjang',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                '$_cartCount item pilihanmu',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              ...cartProducts.map(_buildCartItem),
            ],
          ),
        ),
        _buildCheckoutBar(),
      ],
    );
  }

  Widget _buildCartItem(_PrintProduct product) {
    final quantity = _cart[product.name] ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _ProductIcon(product: product, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_rupiah(product.price)} ${product.unit}',
                  style: const TextStyle(
                    color: _red,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Kurangi ${product.name}',
            onPressed: () => _changeQuantity(product, -1),
            icon: const Icon(Icons.remove_circle_outline, size: 21),
            visualDensity: VisualDensity.compact,
          ),
          Text(
            '$quantity',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          IconButton(
            tooltip: 'Tambah ${product.name}',
            onPressed: () => _changeQuantity(product, 1),
            icon: const Icon(Icons.add_circle_outline, size: 21, color: _red),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E8E2))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total sementara',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                  Text(
                    _rupiah(_cartTotal()),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: _checkout,
              style: FilledButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text('Lanjut pesan'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkout() {
    final order = _PurchaseOrder(
      number:
          'CIHO-${(_purchaseHistory.length + 1).toString().padLeft(4, '0')}',
      items: _products
          .where((product) => (_cart[product.name] ?? 0) > 0)
          .map((product) => '${product.name} x${_cart[product.name]}')
          .toList(),
      itemCount: _cartCount,
      total: _cartTotal(),
      placedAt: DateTime.now(),
    );
    setState(() {
      _purchaseHistory.insert(0, order);
      _cart.clear();
      _showCart = false;
      _selectedTab = 2;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Pesanan ditambahkan ke riwayat pembelian.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildPurchaseHistory() {
    if (_purchaseHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE8D8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: _red,
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Belum ada pembelian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 7),
              const Text(
                'Pesanan yang kamu buat akan muncul di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => setState(() => _selectedTab = 1),
                icon: const Icon(Icons.grid_view_rounded),
                label: const Text('Lihat produk'),
                style: FilledButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        const Text(
          'Riwayat Pembelian',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          '${_purchaseHistory.length} pesanan',
          style: const TextStyle(color: _muted, fontSize: 12),
        ),
        const SizedBox(height: 16),
        ..._purchaseHistory.map(_buildPurchaseOrderCard),
      ],
    );
  }

  Widget _buildPurchaseOrderCard(_PurchaseOrder order) {
    final date = order.placedAt;
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, color: _red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.number,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0C2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Menunggu konfirmasi',
                  style: TextStyle(
                    color: Color(0xFF805300),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(dateLabel, style: const TextStyle(color: _muted, fontSize: 11)),
          const SizedBox(height: 12),
          Text(
            order.items.join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.itemCount} item',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ),
              Text(
                _rupiah(order.total),
                style: const TextStyle(
                  color: _red,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfo() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        const Text(
          'Tentang toko',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              CihoLogo(size: 62),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ciho Print Shop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Cetak mudah, hasil berkualitas.',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _profileInfo(Icons.location_on_outlined, 'Lokasi', 'Jakarta Selatan'),
        _profileInfo(
          Icons.access_time,
          'Jam operasional',
          'Setiap hari, 08.00–23.59',
        ),
        _profileInfo(
          Icons.phone_outlined,
          'Kontak',
          'Hubungi kami untuk konsultasi cetak',
        ),
      ],
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        const Text(
          'Akun Saya',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: _yellow,
                child: Text(
                  _customerInitials,
                  style: const TextStyle(
                    color: _red,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Akun pribadi',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit profil',
                onPressed: _editProfile,
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _profileSectionTitle('INFORMASI PRIBADI'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _privateInfoRow(
                Icons.person_outline,
                'Nama lengkap',
                _customerName,
              ),
              const Divider(height: 1, indent: 52, endIndent: 14),
              _privateInfoRow(
                Icons.phone_outlined,
                'Nomor telepon',
                _customerPhone.isEmpty ? 'Belum ditambahkan' : _customerPhone,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _profileSectionTitle('KERANJANG'),
        const SizedBox(height: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _showCart = true),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8D8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: _red,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Keranjang belanja',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$_cartCount item · ${_rupiah(_cartTotal())}',
                          style: const TextStyle(color: _muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (_cartCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_cartCount',
                        style: const TextStyle(
                          color: _red,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, color: _muted),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _profileSectionTitle('PENGATURAN AKUN'),
        const SizedBox(height: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              _accountSettingRow(
                icon: Icons.shield_outlined,
                title: 'Keamanan akun',
                subtitle: 'Kata sandi dan keamanan masuk',
                onTap: () => _showAccountNotice(
                  'Keamanan akun',
                  'Pengaturan keamanan tersedia setelah akun terhubung ke layanan login.',
                ),
              ),
              const Divider(height: 1, indent: 54, endIndent: 14),
              _accountSettingRow(
                icon: Icons.credit_card_outlined,
                title: 'Metode pembayaran',
                subtitle: 'Belum ada metode tersimpan',
                onTap: () => _showAccountNotice(
                  'Metode pembayaran',
                  'Pembayaran pesanan dikonfirmasi langsung dengan Ciho Print Shop.',
                ),
              ),
              const Divider(height: 1, indent: 54, endIndent: 14),
              _accountSettingRow(
                icon: Icons.notifications_none_rounded,
                title: 'Pengaturan notifikasi',
                subtitle: _notificationsEnabled ? 'Aktif' : 'Nonaktif',
                onTap: () => setState(
                  () => _notificationsEnabled = !_notificationsEnabled,
                ),
                trailing: Switch.adaptive(
                  value: _notificationsEnabled,
                  activeTrackColor: _red,
                  onChanged: (value) =>
                      setState(() => _notificationsEnabled = value),
                ),
              ),
              const Divider(height: 1, indent: 54, endIndent: 14),
              _accountSettingRow(
                icon: Icons.language_rounded,
                title: 'Bahasa aplikasi',
                subtitle: _appLanguage,
                onTap: _chooseLanguage,
              ),
              const Divider(height: 1, indent: 54, endIndent: 14),
              _accountSettingRow(
                icon: Icons.help_outline_rounded,
                title: 'Bantuan dan dukungan',
                subtitle: 'Hubungi atau kunjungi toko',
                onTap: () => _showAccountNotice(
                  'Bantuan dan dukungan',
                  'Ciho Print Shop, Jakarta Selatan. Toko buka setiap hari pukul 08.00–23.59.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar dari akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _red,
              side: const BorderSide(color: _red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _muted,
        fontSize: 11,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _privateInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: _red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Icon(icon, color: _red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: _muted),
          ],
        ),
      ),
    );
  }

  void _showAccountNotice(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseLanguage() async {
    final language = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Bahasa aplikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'Bahasa Indonesia',
              groupValue: _appLanguage,
              activeColor: _red,
              title: const Text('Bahasa Indonesia'),
              onChanged: (value) => Navigator.pop(dialogContext, value),
            ),
            const ListTile(
              enabled: false,
              title: Text('English'),
              subtitle: Text('Segera hadir'),
            ),
          ],
        ),
      ),
    );
    if (language != null && mounted) {
      setState(() => _appLanguage = language);
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu akan kembali ke halaman beranda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && mounted) {
      setState(() {
        _customerName = 'Ahmad';
        _customerPhone = '';
        _cart.clear();
        _purchaseHistory.clear();
        _showCart = false;
        _showStoreInfo = false;
        _selectedTab = 0;
      });
    }
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _customerName);
    final phoneController = TextEditingController(text: _customerPhone);
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nama lengkap'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Nomor telepon'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _red),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (shouldSave == true && mounted) {
      setState(() {
        final name = nameController.text.trim();
        _customerName = name.isEmpty ? 'Ahmad' : name;
        _customerPhone = phoneController.text.trim();
      });
    }
    nameController.dispose();
    phoneController.dispose();
  }

  Widget _profileInfo(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: _red, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.quantity,
    required this.priceLabel,
    required this.onAdd,
  });

  final _PrintProduct product;
  final int quantity;
  final String priceLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ProductIcon(product: product, size: 42),
              const Spacer(),
              if (quantity > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$quantity di keranjang',
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted, fontSize: 10, height: 1.3),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      priceLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _red,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      product.unit,
                      style: const TextStyle(color: _muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton.filled(
                tooltip: 'Tambah ke keranjang',
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(34, 34),
                  maximumSize: const Size(34, 34),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductIcon extends StatelessWidget {
  const _ProductIcon({required this.product, required this.size});

  final _PrintProduct product;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconColor = switch (product.category) {
      'Dokumen' => const Color(0xFF2869B2),
      'Foto' => const Color(0xFFD94A42),
      'Promosi' => const Color(0xFF25814B),
      'Bisnis' => const Color(0xFF7445A8),
      _ => _red,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: product.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(product.icon, color: iconColor, size: size * 0.53),
    );
  }
}

class CihoLogo extends StatelessWidget {
  const CihoLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _CihoLogoPainter()),
    );
  }
}

class _CihoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 300, size.height / 300);

    final goldGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFF36A), Color(0xFFB89B24), Color(0xFFFFF04C)],
      stops: [0, 0.5, 1],
    ).createShader(const Rect.fromLTWH(0, 0, 300, 300));
    final redGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFC92B30), Color(0xFFA91120)],
    ).createShader(const Rect.fromLTWH(0, 0, 300, 300));

    final outerCircle = Path()
      ..addOval(Rect.fromCircle(center: const Offset(150, 150), radius: 120));
    canvas.drawPath(outerCircle, Paint()..color = const Color(0xFF080808));
    _drawDashedCircle(canvas, goldGradient);

    final innerCircle = Path()
      ..addOval(Rect.fromCircle(center: const Offset(150, 150), radius: 115));
    canvas.drawPath(
      innerCircle,
      Paint()
        ..shader = redGradient
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      innerCircle,
      Paint()
        ..color = const Color(0xFF6D1619)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.save();
    canvas.clipPath(
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(150, 150), radius: 118)),
    );
    final highlight = Path()
      ..moveTo(20, 100)
      ..lineTo(90, 55)
      ..lineTo(250, 260)
      ..lineTo(180, 290)
      ..close();
    canvas.drawPath(highlight, Paint()..color = const Color(0x19ED3B3B));
    final shadow = Path()
      ..moveTo(-10, 180)
      ..lineTo(80, 110)
      ..lineTo(210, 300)
      ..lineTo(120, 300)
      ..close();
    canvas.drawPath(shadow, Paint()..color = const Color(0x1F650D16));
    canvas.restore();

    final leftWing = Path()
      ..moveTo(52, 143)
      ..quadraticBezierTo(75, 155, 101, 143)
      ..lineTo(117, 157)
      ..quadraticBezierTo(90, 174, 66, 161)
      ..close();
    canvas.drawPath(leftWing, Paint()..color = const Color(0xFF292024));
    canvas.drawPath(
      leftWing,
      Paint()
        ..color = const Color(0xFF6C2726)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final wingAccent = Path()
      ..moveTo(60, 161)
      ..quadraticBezierTo(83, 173, 103, 164);
    canvas.drawPath(
      wingAccent,
      Paint()
        ..color = const Color(0xFF5A151C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    canvas.drawCircle(
      const Offset(139, 158),
      28,
      Paint()..color = const Color(0xFF10100B),
    );
    canvas.drawCircle(
      const Offset(139, 158),
      28,
      Paint()
        ..color = const Color(0xFFB59A27)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    _drawDashedEmblem(canvas);

    final redCrescent = Path()
      ..moveTo(144, 126)
      ..cubicTo(123, 128, 109, 143, 109, 161)
      ..cubicTo(109, 181, 120, 197, 136, 205)
      ..lineTo(145, 194)
      ..cubicTo(134, 181, 132, 169, 136, 154)
      ..cubicTo(138, 143, 141, 134, 150, 127)
      ..close();
    canvas.drawPath(redCrescent, Paint()..color = const Color(0xFFED2935));
    canvas.drawPath(
      redCrescent,
      Paint()
        ..color = const Color(0xFF9C2425)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final sign = RRect.fromRectAndRadius(
      const Rect.fromLTWH(126, 150, 133, 34),
      const Radius.circular(5),
    );
    canvas.drawRRect(sign, Paint()..color = const Color(0xFF080808));
    canvas.drawRRect(
      sign,
      Paint()
        ..color = const Color(0xFF6C5017)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawLogoText(
      canvas,
      'CIHOPRINTSHOP',
      x: 132,
      baseline: 174,
      fontSize: 25,
      color: const Color(0xFFFFF32B),
      maxWidth: 120,
      outline: true,
    );
    _drawLogoText(
      canvas,
      'JAKARTA',
      x: 178,
      baseline: 195,
      fontSize: 12,
      color: const Color(0xFFB95A5A),
      letterSpacing: 2,
    );
    canvas.restore();
  }

  void _drawDashedCircle(Canvas canvas, Shader shader) {
    final circle = Path()
      ..addOval(Rect.fromCircle(center: const Offset(150, 150), radius: 120));
    final metric = circle.computeMetrics().first;
    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    for (var distance = 0.0; distance < metric.length; distance += 16) {
      canvas.drawPath(
        metric.extractPath(distance, math.min(distance + 9, metric.length)),
        paint,
      );
    }
  }

  void _drawDashedEmblem(Canvas canvas) {
    final circle = Path()
      ..addOval(Rect.fromCircle(center: const Offset(139, 158), radius: 23));
    final metric = circle.computeMetrics().first;
    final paint = Paint()
      ..color = const Color(0xFF71601C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (var distance = 0.0; distance < metric.length; distance += 6) {
      canvas.drawPath(
        metric.extractPath(distance, math.min(distance + 3, metric.length)),
        paint,
      );
    }
  }

  void _drawLogoText(
    Canvas canvas,
    String text, {
    required double x,
    required double baseline,
    required double fontSize,
    required Color color,
    double? maxWidth,
    double letterSpacing = 0,
    bool outline = false,
  }) {
    final style = TextStyle(
      fontFamily: 'sans-serif-condensed',
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: letterSpacing,
    );
    void drawText(Paint? foreground, Color? textColor) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: style.copyWith(color: textColor, foreground: foreground),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      canvas.save();
      canvas.translate(
        x,
        baseline -
            painter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
      );
      if (maxWidth != null && painter.width > 0) {
        canvas.scale(maxWidth / painter.width, 1);
      }
      painter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    if (outline) {
      drawText(
        Paint()
          ..color = const Color(0xFF111111)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
        null,
      );
    }
    drawText(null, color);
  }

  @override
  bool shouldRepaint(covariant _CihoLogoPainter oldDelegate) => false;
}
