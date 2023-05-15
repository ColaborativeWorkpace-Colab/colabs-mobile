import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/screens/pages/jobs.dart';
import 'package:colabs_mobile/screens/pages/messages.dart';
import 'package:colabs_mobile/screens/pages/post.dart';
import 'package:colabs_mobile/screens/pages/projects.dart';
import 'package:colabs_mobile/screens/pages/social.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    LayoutController layoutController = Provider.of<LayoutController>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          PageView(
              clipBehavior: Clip.none,
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                const SocialPage(),
                const MessagesPage(),
                PostPage(),
                const ProjectsPage(),
                const JobsPage(),
              ]),
          Positioned(
              bottom: 1,
              child: AnimatedNotchBottomBar(
                  pageController: pageController,
                  showLabel: false,
                  bottomBarItems: const <BottomBarItem>[
                    BottomBarItem(
                        inActiveItem:
                            Icon(Icons.home_outlined, color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.home_filled,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Social'),
                    BottomBarItem(
                        inActiveItem: Icon(Icons.message_outlined,
                            color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.message_rounded,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Messages'),
                    BottomBarItem(
                        inActiveItem: Icon(Icons.add, color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.add,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Post'),
                    BottomBarItem(
                        inActiveItem:
                            Icon(Icons.folder_outlined, color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.folder,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Projects'),
                    BottomBarItem(
                        inActiveItem:
                            Icon(Icons.work_outline, color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.work,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Jobs'),
                  ],
                  onTap: (int page) {
                    pageController.animateToPage(page,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut);
                    layoutController.setSearchFilter =
                        SearchFilter.values[page];
                  }))
        ]));
  }
}
