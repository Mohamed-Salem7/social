import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/modules/Register/cubit/state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  late UserModel userModel;

  void userAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUserAccount(
        email: email,
        name: name,
        uId: value.user!.uid,
        phone: phone,
      );
    });
  }

  void createUserAccount({
    required String email,
    required String name,
    required String uId,
    required String phone,
  }) {
    UserModel userModel = UserModel(
      name: name,
      email: email,
      isEmailVerified: false,
      phone: phone,
      uId: uId,
      bio: 'write a bio here',
      cover:
          'https://www.agiledrop.com/sites/default/files/styles/blog_big_teaser/public/2020-06/Experience%204.png?itok=jSQs2fXW',
      image:
          'https://www.dotcominfoway.com/wp-content/uploads/2020/01/social-media-app-cost.png',
      text: '',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(SocialRegisterSuccessState());
    }).catchError((error) {
      emit(SocialRegisterErrorState());
    });
  }
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordShown()
  {
    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialChangePasswordVisibility());
  }
}
