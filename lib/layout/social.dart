import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/modules/Post/post_screen.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>SocialAppCubit()..getPost()..getUser(),
      child: BlocConsumer<SocialAppCubit, SocialAppStates>(
        builder: (context, state) {
          var cubit = SocialAppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(IconBroken.Notification),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(IconBroken.Search),
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              notchMargin: 2.0,
              color: Colors.green,
              child: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (int index) {
                  cubit.changeNavBar(index);
                },
                items: cubit.items,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.black,
              splashColor: Colors.green,
              child: Icon(IconBroken.Upload),
              mini: true,
              onPressed: () {
                navigatorTo(context, PostScreen());
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
