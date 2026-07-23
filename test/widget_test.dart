import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishinet/main.dart';
import 'package:krishinet/admin_login_screen.dart';
import 'package:krishinet/admin_dashboard_screen.dart';

void main() {
  HttpOverrides.global = null;
  testWidgets('Krishinet dashboard renders successfully', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KrishinetApp());

    // Verify that the title 'Krishinet' is shown.
    expect(find.text('Krishinet'), findsOneWidget);
    expect(find.text('Empowering\nEvery Acre'), findsOneWidget);

    // Verify quick action items exist.
    expect(find.text('Yield AI'), findsOneWidget);
    expect(find.text('Climate'), findsOneWidget);
  });

  testWidgets('Admin Dashboard renders by itself', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: AdminDashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('AgriEcosystem Admin'), findsOneWidget);
    expect(find.text('Global Analytics'), findsOneWidget);
    expect(find.text('GROSS VOLUME'), findsOneWidget);
    expect(find.text('৳24.8M'), findsOneWidget);
  });

  testWidgets('Admin Login and Dashboard Screen Flow', (
    WidgetTester tester,
  ) async {
    HttpOverrides.global = null;
    SharedPreferences.setMockInitialValues({});
    // Set screen size to fit scroll views in test
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;

    // Reset screen size after test
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build the admin login widget
    await tester.pumpWidget(const MaterialApp(home: AdminLoginScreen()));

    // Verify branding and input fields exist
    expect(find.text('Krishinet Admin'), findsOneWidget);
    expect(find.text('ADMINISTRATOR EMAIL'), findsOneWidget);
    expect(find.text('SECURE KEY'), findsOneWidget);
    expect(find.text('Secure Login'), findsOneWidget);

    // Fill in credentials
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    await tester.ensureVisible(emailField);
    await tester.enterText(emailField, 'admin@krishinet.ecosystem');

    await tester.ensureVisible(passwordField);
    await tester.enterText(passwordField, 'secretkey123');

    // Tap Secure Login button
    final loginButton = find.text('Secure Login');
    await tester.ensureVisible(loginButton);

    await tester.runAsync(() async {
      await tester.tap(loginButton);
      // Wait for real network request and transition logic
      await Future.delayed(const Duration(seconds: 3));
    });

    // Resolve routing animation frames
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify we have navigated to the Admin Dashboard screen
    expect(find.text('AgriEcosystem Admin'), findsOneWidget);
    expect(find.text('Global Analytics'), findsOneWidget);
    expect(find.text('GROSS VOLUME'), findsOneWidget);

    // Match Bangladesh Taka symbol currency representation is formatted correctly
    expect(find.text('৳24.8M'), findsOneWidget);
  });
}
