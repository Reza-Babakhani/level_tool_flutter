import 'package:flutter/material.dart';
import 'package:level/services/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));

  const appId =
      "fqbjclkjtatdschhlmdecsohcemgfriqdsbmsdeiajbtnhhhidrabjiqqnlerkhhalhkbc";
  TapsellPlus.instance.initialize(appId);
  TapsellPlus.instance.setGDPRConsent(true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> ad() async {
    String adId = await TapsellPlus.instance.requestStandardBannerAd(
        "63e506acb5c4a4614cb5de3e", TapsellPlusBannerType.BANNER_320x50);

    await TapsellPlus.instance.showStandardBannerAd(adId,
        TapsellPlusHorizontalGravity.BOTTOM, TapsellPlusVerticalGravity.CENTER,
        margin: const EdgeInsets.only(bottom: 1), onOpened: (map) {
      // Ad opened
    }, onError: (map) {
      // Error when showing ad
    });
  }

  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await ad();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            child: Builder(builder: (context) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<ThemeNotifier>(
                        builder: (context, theme, _) => IconButton(
                          onPressed: () {
                            if (theme.isDarkMode()) {
                              theme.setLightMode();
                            } else {
                              theme.setDarkMode();
                            }
                          },
                          icon: Icon(theme.isDarkMode()
                              ? Icons.light_mode
                              : Icons.dark_mode),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container())
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}
