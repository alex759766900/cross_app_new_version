

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Profile/profile.dart';
import 'package:new_cross_app/Routes/route_const.dart';
import 'package:new_cross_app/Sign_up/signup.dart';
import 'package:new_cross_app/chat/screens/chat_home_screen.dart';
import 'package:new_cross_app/chat/screens/search_page.dart';
//import 'package:new_cross_app/main.dart';

import '../Calendar/Consumer/TradieDemo.dart';
import '../ErrorPage.dart';
import '../Home Page/home.dart';
import '../chat/screens/chat_screen.dart';

class MyRouter{
  GoRouter router = GoRouter(
      routes: [
        GoRoute(
            name: RouterName.homePage,
            path:'/home/:userId',
            pageBuilder: (context, state) {
              return MaterialPage(child: Home(userId: state.params['userId']!));
            },
        ),
        GoRoute(
          name: RouterName.profilePage,
          path:'/profile/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(child: Profile(userId: state.params['userId']!));
          },
        ),
        GoRoute(
          name: RouterName.Login,
          path:'/',
          pageBuilder: (context, state) {
            return MaterialPage(child: LoginPage());
          },
        ),
        GoRoute(
          name: RouterName.SignUp,
          path:'/signUp',
          pageBuilder: (context, state) {
            return MaterialPage(child: Signup());
          },
        ),
        GoRoute(
          name: RouterName.CalendarTradie,
          path:'/calendarT',
          pageBuilder: (context, state) {
            return MaterialPage(child: LoginPage());
          },
        ),
        GoRoute(
          name: RouterName.CalendarConsumer,
          path:'/calendarC/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(child: ConsumerProfilePage(consumer: state.params['userId']!,));
          },
        ),
        GoRoute(
          name: RouterName.chat,
          path:'/chat/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(child: ChatRoom( userId: state.params['userId']!,));
          },
        ),
        GoRoute(
          name: RouterName.ChatSearch,
          path:'/chatSearch/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(child: Search( userId: state.params['userId']!,));
          },
        ),
        GoRoute(
          name: RouterName.ChatRoom,
          path:'/chatRoom/:userId/:chatRoomId',
          pageBuilder: (context, state) {
            return MaterialPage(child: Chat( userId: state.params['userId']!, chatRoomId:  state.params['chatRoomId']!,));
          },
        ),
        GoRoute(
          name: RouterName.TradieDemo,
          path:'/tradieSelection/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(child: TradieDemo( userId: state.params['userId']!));
          },
        ),
        ],
    errorPageBuilder: (context, state){
        return MaterialPage(child: ErrorPage());
    }
  );
}