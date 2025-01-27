import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyu_designer_v2/constants.dart';
import 'package:studyu_designer_v2/features/app_controller.dart';
import 'package:studyu_designer_v2/localization/app_translation.dart';
import 'package:studyu_designer_v2/localization/locale_providers.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';
import 'package:studyu_designer_v2/routing/router.dart';
import 'package:studyu_designer_v2/services/notification_dispatcher.dart';
import 'package:studyu_designer_v2/theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

/// Entry widget of the app.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const AppContent();
  }

  @override
  void initState() {
    super.initState();
  }
}

class AppContent extends ConsumerStatefulWidget {
  const AppContent({Key? key}) : super(key: key);

  @override
  ConsumerState<AppContent> createState() => _AppContentState();
}

class _AppContentState extends ConsumerState<AppContent> {
  late final AppController appController;

  final settings = ValueNotifier(ThemeSettings(
    //sourceColor: Color(0xff2a4fda),
    //sourceColor: Color(0xff583aee),
    sourceColor: const Color(0xff4845e5),
    //sourceColor: const Color(0xff2962ff),
    themeMode: ThemeMode.system,
  ));

  @override
  void initState() {
    super.initState();
    appController = ref.read(appControllerProvider.notifier);
    appController.onAppStart();
    // todo move this into appControllerProvider
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Locale Startup Actions
      ref.read(localeStateProvider.notifier).initLocale();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTranslation.init(ref); // todo Refactor this into initState locale delegate if possible
    final router = ref.watch(routerProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => ThemeProvider(
        lightDynamic: lightDynamic,
        darkDynamic: darkDynamic,
        settings: settings,
        child: Builder(
          builder: (context) {
            final themeProvider = ThemeProvider.of(context);
            final theme = themeProvider.light(settings.value.sourceColor);
            return MaterialApp.router(
              scaffoldMessengerKey: scaffoldMessengerKey,
              builder: (context, widget) => NotificationDispatcher(
                scaffoldMessengerKey: scaffoldMessengerKey,
                navigatorKey: router.routerDelegate.navigatorKey,
                child: widget,
              ),
              debugShowCheckedModeBanner: Config.isDebugMode,
              title: 'StudyU Designer V2'.hardcoded,
              color: theme.colorScheme.surface,
              theme: theme,
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              locale: ref.watch(localeProvider),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                ...AppLocalizations.localizationsDelegates,
                // See: https://github.com/danvick/flutter_form_builder/blob/master/packages/form_builder_validators/README.md#l10n
                // FormBuilderLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
