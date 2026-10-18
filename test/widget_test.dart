// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cihoprintshopjkt/main.dart';

Future<void> _signIn(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'ahmad@example.com');
  await tester.enterText(find.byType(TextFormField).at(1), 'password123');
  await tester.tap(find.text('Masuk'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Validates login and opens the print shop', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Selamat datang!'), findsOneWidget);
    expect(find.text('Ciho'), findsOneWidget);
    expect(find.text('PrintShop'), findsOneWidget);

    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(
      find.text('Masukkan email atau nomor HP yang valid'),
      findsOneWidget,
    );
    expect(find.text('Password minimal 6 karakter'), findsOneWidget);

    await _signIn(tester);
    expect(find.text('Halo, Ahmad!'), findsOneWidget);
  });

  testWidgets('Adds a print service to the cart', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await _signIn(tester);

    expect(find.text('Halo, Ahmad!'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Produk'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Keranjang'), findsNothing);
    expect(find.text('Toko'), findsNothing);

    await tester.tap(find.text('Produk'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih layanan'), findsOneWidget);

    await tester.tap(find.byTooltip('Tambah ke keranjang').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keranjang belanja'));
    await tester.pumpAndSettle();

    expect(find.text('1 item pilihanmu'), findsOneWidget);
    expect(find.text('Rp 500'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjut pesan'));
    await tester.pumpAndSettle();

    expect(find.text('Riwayat Pembelian'), findsOneWidget);
    expect(find.text('CIHO-0001'), findsOneWidget);
    expect(find.text('Cetak Dokumen x1'), findsOneWidget);
    expect(find.text('Rp 500'), findsOneWidget);
  });

  testWidgets('Opens the customer profile and edit form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await _signIn(tester);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.text('Akun Saya'), findsOneWidget);
    expect(find.text('Ahmad'), findsNWidgets(2));
    expect(find.text('Belum ditambahkan'), findsOneWidget);
    expect(find.text('INFORMASI PRIBADI'), findsOneWidget);
    expect(find.text('KERANJANG'), findsOneWidget);
    expect(find.text('Keranjang belanja'), findsOneWidget);

    await tester.tap(find.text('Keranjang belanja'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('Edit profil'));
    await tester.tap(find.byTooltip('Edit profil'));
    await tester.pumpAndSettle();

    expect(find.text('Edit profil'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Simpan'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('PENGATURAN AKUN'));
    await tester.pumpAndSettle();
    expect(find.text('PENGATURAN AKUN'), findsOneWidget);
    expect(find.text('Keamanan akun'), findsOneWidget);
    expect(find.text('Metode pembayaran'), findsOneWidget);
    expect(find.text('Pengaturan notifikasi'), findsOneWidget);
    expect(find.text('Bahasa aplikasi'), findsOneWidget);
    expect(find.text('Bantuan dan dukungan'), findsOneWidget);

    await tester.ensureVisible(find.byType(Switch));
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.scrollUntilVisible(
      find.text('Keluar dari akun'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Ahmad!'), findsOneWidget);
  });
}
