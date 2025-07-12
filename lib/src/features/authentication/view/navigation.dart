import 'dart:developer';

import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/features/chat/view/chat_page.dart';
import 'package:echo/src/features/notification/view/notifications.dart';
import 'package:echo/src/features/posts/views/add_post.dart';
import 'package:echo/src/features/profile/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

/// The Home Screen of the App
class Navigation extends StatefulWidget {
  /// Constructor
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  late int currentPage;

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    pageController = PageController();
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
    pageController.jumpToPage(newPage); // Use jumpToPage for no animation
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = context.colorScheme.primary;
    final Color selectedColor = context.colorScheme.secondary;

    return SafeArea(
      child: Scaffold(
        body: BottomBar(
          clip: Clip.none,
          fit: StackFit.expand,
          icon:
              (double width, double height) => Center(
                child: IconButton(
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: unselectedColor,
                    size: 32,
                  ),
                ),
              ),
          borderRadius: BorderRadius.circular(500),
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate,
          width: 450,
          barColor:
              context.theme == Brightness.dark ? Colors.black87 : Colors.white,
          iconHeight: 32,
          iconWidth: 32,
          body:
              (BuildContext context, ScrollController controller) => PageView(
                controller: pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swiping
                children: <Widget>[
                  Home(controller: controller),
                  const ChatPage(),
                  const AddPostPage(),
                  const NotificationsPage(),
                  const ProfileView(),
                ],
              ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: <Widget>[
              TabBar(
                physics: const NeverScrollableScrollPhysics(),
                indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                controller: tabController,
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                onTap: (index) {
                  // Prevent middle tab (index 2) from being selected
                  if (index != 2) {
                    // Allow normal tab selection for other tabs
                    changePage(index);
                  }
                  // Do nothing for middle tab (index 2)
                },
                tabs: <Widget>[
                  SizedBox(
                    height: 70,
                    width: 65,
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedHome09,
                        color:
                            currentPage == 0 ? selectedColor : unselectedColor,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 65,
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedChatting01,
                        color:
                            currentPage == 1 ? selectedColor : unselectedColor,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 65,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: unselectedColor, // Always unselected
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 65,
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedNotification03,
                        color:
                            currentPage == 3 ? selectedColor : unselectedColor,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 65,
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedUser,
                        color:
                            currentPage == 4 ? selectedColor : unselectedColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -15,
                height: 65,
                width: 65,
                child: FloatingActionButton(
                  onPressed: () {
                    // Use context.push to navigate to add post page
                    context.push(
                      AppRoutes.addPost,
                    ); // Replace with your actual route
                  },
                  backgroundColor: selectedColor,
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedAdd01,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final ScrollController? controller;
  const Home({this.controller, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) => ListView.builder(
    controller: widget.controller,
    itemCount: 50,
    itemBuilder:
        (BuildContext context, int index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('${index + 1}'),
            ),
            title: Text('Home Item ${index + 1}'),
            subtitle: Text('This is item number ${index + 1} in the home feed'),
            onTap: () {
              log('Tapped on item $index');
            },
          ),
        ),
  );
}
