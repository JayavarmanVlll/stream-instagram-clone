import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/app.dart';
import '../app_widgets/widgets.dart';
import '../new_post/new_post.dart';
import '../profile/profile.dart';
import '../search/search.dart';
import '../timeline/timeline.dart';

/// {@template home_screen}
/// HomeScreen of the application.
///
/// Shows a feed of user created posts and provides navigation to other pages.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({Key? key}) : super(key: key);

  /// List of pages available from the home screen.
  static const List<Widget> _homePages = <Widget>[
    TimelinePage(),
    SearchPage(),
    ProfilePage()
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Stream-agram', style: GoogleFonts.grandHotel(fontSize: 32)),
        backgroundColor: AppColors.background,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TapFadeIcon(
              onTap: () => Navigator.of(context).push(NewPostScreen.route),
              icon: Icons.add_circle_outline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TapFadeIcon(
              onTap: () async {
                context.removeAndShowSnackbar('Not part of the demo');
              },
              icon: Icons.favorite_outline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TapFadeIcon(
              onTap: () => context.removeAndShowSnackbar('Todo'),
              icon: Icons.call_made,
            ),
          ),
        ],
      ),
      body: Center(
        child: HomeScreen._homePages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: _onNavigationItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          elevation: 0,
          iconSize: 28,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              activeIcon: Icon(
                Icons.search,
                size: 22,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Person',
            )
          ],
        ),
      ),
    );
  }
}
