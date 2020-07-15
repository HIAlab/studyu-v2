import 'package:flutter/material.dart';

import 'screens/app_onboarding/about.dart';
import 'screens/app_onboarding/loading_screen.dart';
import 'screens/app_onboarding/terms.dart';
import 'screens/app_onboarding/welcome.dart';
import 'screens/study/dashboard/contact_tab/contact.dart';
import 'screens/study/dashboard/dashboard.dart';
import 'screens/study/dashboard/settings.dart';
import 'screens/study/onboarding/consent.dart';
import 'screens/study/onboarding/intervention_selection.dart';
import 'screens/study/onboarding/journey_overview.dart';
import 'screens/study/onboarding/study_overview.dart';
import 'screens/study/onboarding/study_selection.dart';

class Routes {
  static const String loading = '/loading';
  static const String dashboard = '/dashboard';
  static const String welcome = '/welcome';
  static const String about = '/about';
  static const String terms = '/terms';
  static const String studySelection = '/studySelection';
  static const String studyOverview = '/studyOverview';
  static const String interventionSelection = '/interventionSelection';
  static const String journey = '/journey';
  static const String consent = '/consent';
  static const String contact = '/contact';
  static const String appSettings = '/settings';
  static const String questionnaire = '/questionnaire';

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('No route defined for ${settings.name}.\nThe developers should fix this 👩‍💻'),
              )),
            ));
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeMap = {
      loading: (_) => LoadingScreen(),
      dashboard: (_) => DashboardScreen(),
      welcome: (_) => WelcomeScreen(),
      about: (_) => AboutScreen(),
      terms: (_) => TermsScreen(),
      studySelection: (_) => StudySelectionScreen(),
      studyOverview: (_) => StudyOverviewScreen(),
      interventionSelection: (_) => InterventionSelectionScreen(),
      journey: (_) => JourneyOverviewScreen(),
      consent: (_) => ConsentScreen(),
      contact: (_) => Contact(),
      appSettings: (_) => Settings(),
    };

    if (!routeMap.containsKey(settings.name)) {
      // null will be handled by onUnknownRoute
      return null;
    }

    return MaterialPageRoute(builder: routeMap[settings.name], settings: settings);
  }
}