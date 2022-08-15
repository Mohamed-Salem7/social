import 'package:flutter_social/modules/Login/Login.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/network/local/cache_helper.dart';

String uId = '';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigatorFinished(context, SocialLoginScreen());
    }
  });
}