//Handle background message
import 'package:flutter/material.dart';
// import 'package:income_sms/widgets/ez_button.dart';
// import 'package:income_sms/widgets/ez_input.dart';
// import 'package:income_sms/widgets/tele_bot.dart';

import 'screens/error_page.dart';
import 'screens/home_page.dart';

@pragma("vm:entry-point")
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Income Sms',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppView(title: 'Income Sms'),
    );
  }
}

@pragma("vm:entry-point")
class AppView extends StatefulWidget {
  const AppView({super.key, required this.title});

  final String title;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  var bottomIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: bottomIndex,
        builder: (final _, final index, final __) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Theme.of(context).disabledColor,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                currentIndex: index,
                selectedFontSize: 14,
                unselectedFontSize: 14,
                items: [
                  _buildBottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined,
                        size: 24, color: Colors.grey),
                    activeIcon: const Icon(Icons.home,
                        size: 24, color: Colors.deepPurple),
                    title: 'Home',
                  ),
                  _buildBottomNavigationBarItem(
                    icon: const Icon(Icons.error_outline,
                        size: 24, color: Colors.grey),
                    activeIcon: const Icon(Icons.error,
                        size: 24, color: Colors.deepPurple),
                    title: 'Errors',
                  ),
                ],
                onTap: (final index) async {
                  bottomIndex.value = index;
                  // if (await Utils.handleContributionAndMaintenance(
                  //   pathRoute: Routes.tabBarPages[index],
                  // )) return;
                  // Utils.haptic();
                  // context.read<TabBarBloc>().add(
                  //       TabBarIndexChanged(
                  //         index: index,
                  //         isGuest:
                  //             context.read<UserBloc>().state.user.guestUser(),
                  //       ),
                  //     );
                },
              ),
              body: buildPage(index));
        });
  }

  Widget buildPage(final int index) {
    final pages = getTabbarWidgets().values.toList();

    return pages[index];
  }

  Map<int, Widget> getTabbarWidgets() {
    return {
      0: const HomePage(),
      1: const ErrorPage(),
    };
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required final Widget icon,
    required final Widget activeIcon,
    required final String title,
  }) {
    return BottomNavigationBarItem(
      icon: icon,
      activeIcon: activeIcon,
      label: title,
    );
  }
}
