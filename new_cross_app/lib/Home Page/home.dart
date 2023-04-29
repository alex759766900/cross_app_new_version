import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
//import 'package:jemma/models/user.dart';
//import 'package:jemma/repository.dart';
import 'package:new_cross_app/Home Page/adaptive.dart';
import 'package:new_cross_app/Home Page/responsive.dart';
import 'package:new_cross_app/Home Page/graphical_banner.dart';
import 'package:new_cross_app/Home Page/login_button.dart';
import 'package:new_cross_app/Home Page/nav_bar.dart';
import 'package:new_cross_app/Home Page/notification_panel.dart';
import 'package:new_cross_app/Home Page/search_bar.dart';
import 'package:new_cross_app/Home Page/web_footer.dart';
import 'package:new_cross_app/Home Page/about_jemma.dart';
import 'package:new_cross_app/Home Page/why_jemma.dart';


/// Home screen for guests and customers
///
/// Restricting max width of widgets to be 1080 based on the data from:
/// https://gs.statcounter.com/screen-resolution-stats/desktop/worldwide
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);


  static const borderRadius = 40.0;
  static const maxWidth = 1080.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var scrollController = ScrollController();
    return Scaffold(
      drawer: NavBar(),
      endDrawer: const NotificationPanel(),
      appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(Icons.notifications)),
            ),
          ],
          /*title: ValueListenableBuilder<User?>(
              valueListenable: Repository().user,
              builder: (BuildContext context, User? user, Widget? child) {

                return Row(
                  children:  [
                    const Text("Home"),
                    const Spacer(),
                    if(user == null)
                    const LoginButton(),
                  ],
                );
              })*/
      ),
      body: Scrollbar(
        isAlwaysShown: isWeb(),
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            child:Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  child:Column(
                      children:[
                        SizedBox(height: 2.5.ph(size)),

                        const GraphicalBanner(),

                        Transform.translate(
                            offset:const Offset(0,-GraphicalBanner.bannerHeight * 0.25),
                            child: const SearchBar()),

                        const AboutJemma(),

                        SizedBox(height: 5.ph(size)),

                        WhyJemma(),
                      ]),
                ),

                if (isWeb())
                  const WebFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }
}