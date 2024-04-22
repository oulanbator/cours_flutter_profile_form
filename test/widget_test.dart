import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_details.dart';
import 'package:cours_flutter_profile_form/constants.dart';

void main() {
  group('Home Screen Widget Test', () {
    testWidgets('Home screen renders correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(home: Home()));

      // Verify that the home screen contains the app bar title.
      expect(find.text("Profils"), findsOneWidget);

      // Verify that the FloatingActionButton is present.
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
