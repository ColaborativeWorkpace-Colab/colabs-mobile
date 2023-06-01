import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/screens/pages/jobs.dart';
import 'package:colabs_mobile/screens/pages/messages.dart';
import 'package:colabs_mobile/screens/pages/post.dart';
import 'package:colabs_mobile/screens/pages/projects.dart';
import 'package:colabs_mobile/screens/pages/social.dart';
import 'package:colabs_mobile/types/search_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    LayoutController layoutController = Provider.of<LayoutController>(context);
    RESTService restService = Provider.of<RESTService>(context);

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
                PostPage(pageController: pageController),
                const ProjectsPage(),
                const JobsPage(),
              ]),
          Positioned(
              bottom: 1,
              child: AnimatedNotchBottomBar(
                  pageController: pageController,
                  showLabel: false,
                  bottomBarItems: <BottomBarItem>[
                    const BottomBarItem(
                        inActiveItem:
                            Icon(Icons.home_outlined, color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.home_filled,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Social'),
                    const BottomBarItem(
                        inActiveItem: Icon(Icons.message_outlined,
                            color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.message_rounded,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Messages'),
                    const BottomBarItem(
                        inActiveItem: Icon(Icons.add, color: Colors.blueGrey),
                        activeItem: Icon(
                          Icons.add,
                          color: Color(0xFF5521B5),
                        ),
                        itemLabel: 'Post'),
                    BottomBarItem(
                        inActiveItem: Icon(
                            restService.getProfileInfo['isVerified'] ?? false
                                ? Icons.folder_outlined
                                : Icons.folder_off,
                            color: Colors.blueGrey),
                        activeItem: Icon(
                          restService.getProfileInfo['isVerified'] ?? false
                              ? Icons.folder
                              : Icons.folder_off,
                          color: const Color(0xFF5521B5)
                        ),
                        itemLabel: 'Projects'),
                    BottomBarItem(
                        inActiveItem:
                            Icon(
                              restService.getProfileInfo['isVerified'] ?? false
                                ? Icons.work_outline
                                : Icons.work_off,
                               color: Colors.blueGrey),
                        activeItem: Icon(
                          restService.getProfileInfo['isVerified'] ?? false
                              ? Icons.work
                              : Icons.work_off,
                          color: const Color(0xFF5521B5),
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
