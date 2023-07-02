import 'dart:async';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:level/services/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
    try {
      String adId = await TapsellPlus.instance.requestStandardBannerAd(
          "63e506acb5c4a4614cb5de3e", TapsellPlusBannerType.BANNER_320x50);

      await TapsellPlus.instance.showStandardBannerAd(
          adId,
          TapsellPlusHorizontalGravity.BOTTOM,
          TapsellPlusVerticalGravity.CENTER,
          margin: const EdgeInsets.only(bottom: 1), onOpened: (map) {
        // Ad opened
      }, onError: (map) {
        // Error when showing ad
      });
    } catch (e) {}
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

  final GlobalKey _yKey = GlobalKey();
  final GlobalKey _xKey = GlobalKey();
  final GlobalKey _xyKey = GlobalKey();

  double x = 0;
  double y = 0;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();

    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        try {
          var halfX = _xKey.currentContext!.size!.width / 2;
          var halfY = _yKey.currentContext!.size!.height / 2;
          var centerX = halfX - 20;
          var centerY = halfY - 20;

          x = ((event.x / 10) * halfX) + centerX;
          y = ((event.y / -10) * halfY) + centerY;
        } catch (ex) {
          x = event.x;
          y = event.y;
        }
      });
    }));
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
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 70),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                depth: -10,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(25))),
                            child: SizedBox(
                              key: _xKey,
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Stack(children: [
                                  Positioned(
                                    left: x,
                                    child: Neumorphic(
                                      style: const NeumorphicStyle(
                                          color: Colors.black,
                                          boxShape:
                                              NeumorphicBoxShape.circle()),
                                      child: const SizedBox(
                                        height: 34,
                                        width: 34,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.red.shade700,
                                              width: 2),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                key: _xyKey,
                                child: Neumorphic(
                                  style: const NeumorphicStyle(
                                      depth: -10,
                                      boxShape: NeumorphicBoxShape.circle()),
                                  child: Stack(children: [
                                    Positioned(
                                      top: y,
                                      left: x,
                                      child: Neumorphic(
                                        style: const NeumorphicStyle(
                                            color: Colors.black,
                                            boxShape:
                                                NeumorphicBoxShape.circle()),
                                        child: const SizedBox(
                                          height: 34,
                                          width: 34,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 34,
                                        width: 34,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.red.shade700,
                                                width: 2),
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            )),
                            const SizedBox(
                              width: 20,
                            ),
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: -10,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(25),
                                ),
                              ),
                              child: SizedBox(
                                key: _yKey,
                                width: 50,
                                height: MediaQuery.of(context).size.width - 100,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Stack(children: [
                                    Positioned(
                                      top: y,
                                      child: Neumorphic(
                                        style: const NeumorphicStyle(
                                            color: Colors.black,
                                            boxShape:
                                                NeumorphicBoxShape.circle()),
                                        child: const SizedBox(
                                          height: 34,
                                          width: 34,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 34,
                                        width: 34,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.red.shade700,
                                                width: 2),
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            )
                          ],
                        ),
                        /*  ElevatedButton(
                            onPressed: () {
                              print(
                                  "x height: ${_xKey.currentContext?.size?.height.toInt().toString()}");
                              print(
                                  "x width: ${_xKey.currentContext?.size?.width.toInt().toString()}");
                              print(
                                  "y height: ${_yKey.currentContext?.size?.height.toInt().toString()}");
                              print(
                                  "y width: ${_yKey.currentContext?.size?.width.toInt().toString()}");
                              print(
                                  "xy height: ${_xyKey.currentContext?.size?.height.toInt().toString()}");
                              print(
                                  "xy width: ${_xyKey.currentContext?.size?.width.toInt().toString()}");
                            },
                            child: Text("click"),), */
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
