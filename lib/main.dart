import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/social.dart';
import 'package:flutter_social/modules/Login/Login.dart';
import 'package:flutter_social/modules/native_code.dart';
import 'package:flutter_social/shared/app_cubit/cubit.dart';
import 'package:flutter_social/shared/app_cubit/state.dart';
import 'package:flutter_social/shared/bloc_observer.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/component/constant.dart';
import 'package:flutter_social/shared/network/local/cache_helper.dart';
import 'package:flutter_social/shared/network/remote/dio_helper.dart';
import 'package:flutter_social/shared/styles/theme.dart';

Future<void> firebaseOnBackgroundMessage(RemoteMessage message) async {
  print('on background message ');
  print(message.data.toString());
  showToast(
    text: 'on background message',
    state: ToastShow.SUCCESS,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  await CacheHelper.init();

  Widget widget;

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());

    showToast(
      text: 'on message',
      state: ToastShow.SUCCESS,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(
      text: 'on message opened',
      state: ToastShow.SUCCESS,
    );
  });

  FirebaseMessaging.onBackgroundMessage(firebaseOnBackgroundMessage);

  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  Widget startWidget;

  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialAppCubit()
              ..getUserData()
              ..getPost()
        ),
        BlocProvider(create: (context) => AppCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            home: startWidget,
            debugShowCheckedModeBanner: false,
            theme: lightheme,
          );
        },
      ),
    );
  }
}
