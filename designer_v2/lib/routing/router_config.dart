import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studyu_designer_v2/common_views/pages/error_page.dart';
import 'package:studyu_designer_v2/common_views/pages/splash_page.dart';
import 'package:studyu_designer_v2/features/auth/login_page.dart';
import 'package:studyu_designer_v2/features/auth/password_recovery_page.dart';
import 'package:studyu_designer_v2/features/auth/password_forgot_page.dart';
import 'package:studyu_designer_v2/features/auth/signup_page.dart';
import 'package:studyu_designer_v2/features/dashboard/dashboard_page.dart';
import 'package:studyu_designer_v2/features/dashboard/studies_filter.dart';
import 'package:studyu_designer_v2/features/legacy/designer_page.dart';
import 'package:studyu_designer_v2/features/main_page_scaffold.dart';
import 'package:studyu_designer_v2/features/study/study_analyze_page.dart';
import 'package:studyu_designer_v2/features/study/study_monitor_page.dart';
import 'package:studyu_designer_v2/features/study/study_recruit_page.dart';
import 'package:studyu_designer_v2/features/study/study_scaffold.dart';
import 'package:studyu_designer_v2/features/study/study_test_page.dart';
import 'package:studyu_designer_v2/routing/router_intent.dart';

class RouterKeys {
  static const studyKey = ValueKey("study"); // shared key for study page tabs
}

class RouteParams {
  static const studiesFilter = 'filter';
  static const studyId = 'studyId';
}

/// The route configuration passed to [GoRouter] during instantiation.
///
/// Any route that should be accessible from the app must be registered as
/// a [topLevelRoutes] (or as a subroute of a top-level route)
///
/// Note: Make sure to always specify [GoRoute.name] so that [RoutingIntent]s
/// can be dispatched correctly.
class RouterConfig {

  /// Public routes can be accessed without login
  static final topLevelPublicRoutes = [
    root,
    splash,
    error,
    login,
    signup,
    passwordForgot,
  ];

  /// Private routes can only be accessed after login
  static final topLevelPrivateRoutes = [
    studies,
    study,
    studyEdit,
    studyTest,
    studyMonitor,
    studyRecruit,
    studyAnalyze,
    passwordRecovery,
  ];

  /// This list is provided to [GoRouter.routes] during instantiation.
  /// See router.dart
  static final topLevelRoutes = topLevelPublicRoutes + topLevelPrivateRoutes;

  static final root = GoRoute(
    path: "/",
    name: "root",
    redirect: (GoRouterState state) => state.namedLocation(studies.name!),
  );

  static final studies = GoRoute(
      path: "/studies",
      name: "studies",
      builder: (context, state) => DashboardScreen(
          filter: (){
            if (state.queryParams[RouteParams.studiesFilter] == null) {
              return null;
            }
            final idx = StudiesFilter.values.map((v) => v.toShortString())
                .toList().indexOf(state.queryParams[RouteParams.studiesFilter]!);
            return (idx != -1) ? StudiesFilter.values[idx] : null;
          }() // call anonymous closure to resolve param to enum
      ),
  );

  static final study = GoRoute(
    path: "/studies/:${RouteParams.studyId}",
    name: "study",
    redirect: (GoRouterState state) => state.namedLocation(
        studyEdit.name!,
        params: {
          RouteParams.studyId: state.params[RouteParams.studyId]!
        }
    ),
  );

  static final studyEdit = GoRoute(
      path: "/studies/:${RouteParams.studyId}/edit",
      name: "studyEdit",
      pageBuilder: (context, state) => MaterialPage(
          key: RouterKeys.studyKey,
          child: StudyScaffold(
            studyId: state.params[RouteParams.studyId]!,
            selectedTab: StudyScaffoldTab.edit,
            // TODO: replace legacy editor with new version
            //child: StudyEditScreen(state.params['studyId']!)
            child: DesignerScreen(state.params[RouteParams.studyId]!),
          )
      )
  );

  static final studyTest = GoRoute(
      path: "/studies/:${RouteParams.studyId}/test",
      name: "studyTest",
      pageBuilder: (context, state) => MaterialPage(
          key: RouterKeys.studyKey,
          child: StudyScaffold(
              studyId: state.params[RouteParams.studyId]!,
              selectedTab: StudyScaffoldTab.test,
              child: StudyTestScreen(state.params[RouteParams.studyId]!)
          )
      )
  );

  static final studyRecruit = GoRoute(
      path: "/studies/:${RouteParams.studyId}/recruit",
      name: "studyRecruit",
      pageBuilder: (context, state) => MaterialPage(
          key: RouterKeys.studyKey,
          child: StudyScaffold(
              studyId: state.params[RouteParams.studyId]!,
              selectedTab: StudyScaffoldTab.recruit,
              child: StudyRecruitScreen(state.params[RouteParams.studyId]!)
          )
      )
  );

  static final studyMonitor = GoRoute(
      path: "/studies/:${RouteParams.studyId}/monitor",
      name: "studyMonitor",
      pageBuilder: (context, state) => MaterialPage(
          key: RouterKeys.studyKey,
          child: StudyScaffold(
              studyId: state.params[RouteParams.studyId]!,
              selectedTab: StudyScaffoldTab.monitor,
              child: StudyMonitorScreen(state.params[RouteParams.studyId]!)
          )
      )
  );

  static final studyAnalyze = GoRoute(
      path: "/studies/:${RouteParams.studyId}/analyze",
      name: "studyAnalyze",
      pageBuilder: (context, state) => MaterialPage(
          key: RouterKeys.studyKey,
          child: StudyScaffold(
              studyId: state.params[RouteParams.studyId]!,
              selectedTab: StudyScaffoldTab.analyze,
              child: StudyAnalyzeScreen(state.params[RouteParams.studyId]!)
          )
      )
  );

  static final splash = GoRoute(
    path: "/splash",
    name: "splash",
    builder: (context, state) => const SplashPage(),
  );

  static final login = GoRoute(
    path: "/login",
    name: "login",
    pageBuilder: (context, state) => MaterialPage(
        child: MainPageScaffold(
            childName: state.name!,
            child: const LoginPage()
        )
    )
  );

  static final signup = GoRoute(
      path: "/signup",
      name: "signup",
      pageBuilder: (context, state) => MaterialPage(
          child: MainPageScaffold(
              childName: state.name!,
              child: const SignupPage()
          )
      )
  );

  static final passwordForgot = GoRoute(
    path: "/forgot_password",
    name: "passwordForgot",
      pageBuilder: (context, state) => MaterialPage(
          child: MainPageScaffold(
            childName: state.name!,
            child: PasswordForgotPage(email: state.extra as String?),
          )
      )
  );

  static final passwordRecovery = GoRoute(
      path: "/password_recovery",
      name: "passwordRecovery",
      pageBuilder: (context, state) => MaterialPage(
          child: MainPageScaffold(
              childName: state.name!,
              child: const PasswordRecoveryPage()
          )
      )
  );

  static final error = GoRoute(
    path: "/error",
    name: "error",
    builder: (context, state) => ErrorPage(error: state.extra as Exception),
  );
}
