import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/models/comments_models.dart';
import 'package:flutter_social/models/message_models.dart';
import 'package:flutter_social/models/post_models.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/modules/Chats/chats_screen.dart';
import 'package:flutter_social/modules/Home/home_screen.dart';
import 'package:flutter_social/modules/Map/map_screen.dart';
import 'package:flutter_social/modules/Profile/profile_screen.dart';
import 'package:flutter_social/shared/component/constant.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SocialAppCubit extends Cubit<SocialAppStates> {
  SocialAppCubit() : super(SocialAppInitialState());

  static SocialAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  late UserModel userModel;

  late PostModels postModels;

  void getUserData() {
    emit(SocialGetUserDataLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      userModel = UserModel.fromJason(value.data());
      emit(SocialGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserDataErrorState());
    });
  }

  void changeNavBar(int index) {
    if (index == 1) getUser();
    currentIndex = index;
    emit(SocialChangeNavBarState());
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Chat),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Location),
      label: 'Map',
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Profile),
      label: 'Profile',
    ),
  ];

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  List<String> title = [
    'Home',
    'Chats',
    'Maps',
    'Profile',
  ];

  void updateData({
    required String name,
    required String bio,
    required String phone,
    String? image,
    String? cover,
  }) {
    emit(SocialAppGetUserDataLoadingState());
    UserModel model = UserModel(
        bio: bio,
        name: name,
        phone: phone,
        uId: uId,
        isEmailVerified: false,
        email: userModel.email,
        image: image ?? userModel.image,
        cover: cover ?? userModel.cover,
        text: userModel.text);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      emit(SocialAppGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialAppGetUserDataErrorState());
    });
  }

  late File profileImage;

  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialGetProfileImageSuccessState());
    } else {
      print('No Image selected');
      emit(SocialGetProfileImageErrorState());
    }
  }

  late File coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialGetProfileImageSuccessState());
    } else {
      print('No Image selected');
      emit(SocialGetProfileImageErrorState());
    }
  }

  void uploadProfile({
    required String name,
    required String bio,
    required String phone,
  }) {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateData(
          name: name,
          bio: bio,
          phone: phone,
          image: value,
        );
      }).catchError((error) {
        emit(SocialGetUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialGetUploadProfileImageErrorState());
    });
  }

  void uploadCover({
    required String name,
    required String bio,
    required String phone,
  }) {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateData(
          name: name,
          bio: bio,
          phone: phone,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialGetUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialGetUploadCoverImageErrorState());
    });
  }

  late File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialGetPostImageSuccessState());
    } else {
      print('No Image selected');
      emit(SocialGetPostImageErrorState());
    }
  }

  void uploadPost({
    required String text,
    required String dateTime,
  }) {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(text: text, dateTime: dateTime, postImage: value);
      }).catchError((error) {
        emit(SocialGetUploadPostImageErrorState());
      });
    }).catchError((error) {
      emit(SocialGetUploadPostImageErrorState());
    });
  }

  void removeImagePost() {
    postImage = null as File ;
    emit(SocialRemoveImagePostState());
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    PostModels postModels = PostModels(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModels.toMap())
        .then((value) {
      print(value);
      emit(SocialCreateNewPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateNewPostErrorState());
    });
  }

  List<PostModels> posts = [];
  List<int> like = [];
  List<String> likePost = [];

  Future<void> getPost() async {
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          like.add(value.docs.length);
          likePost.add(element.id);
          posts.add(PostModels.fromJason(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostSuccessState());
    }).catchError((error) {
      emit(SocialGetPostErrorState());
    });
  }

  void likePosts(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({'likes': true}).then((value) {
      emit(SocialGetLikePostSuccessState());
    }).catchError((error) {
      emit(SocialGetLikePostErrorState());
    });
  }

  List<UserModel> users = [];

  void getUser() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            users.add(UserModel.fromJason(element.data()));
        });
        emit(SocialGetUsersChatsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetUsersChatsErrorState());
      });
  }

  void sendMessage({
    required String text,
    required String receiverId,
    required String dateTime,
  }) {
    MessageModels messageModels = MessageModels(
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
      senderId: userModel.uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messageModels.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('message')
        .add(messageModels.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModels> messages = [];

  void getMessage({required String receiverId}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModels.fromJason(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }

  List<UserModel> comments = [];

  List<UserModel> user = [];

  void getUsers() {
    if (user.length == 0)
      FirebaseFirestore.instance.collection('posts').get().then((value) {
        value.docs.forEach((element) {
          user.add(UserModel.fromJason(element.data()));
        });
        emit(SocialGetUsersChatsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetUsersChatsErrorState());
      });
  }

  void writeComment({
    required String text,
  }) {
    CommentsModels commentsModels = CommentsModels(
      text: text,
      uId: userModel.uId,
      name: userModel.name,
      image: userModel.image,
    );
    FirebaseFirestore.instance
        .collection('comments')
        .add(commentsModels.toMap())
        .then((value) {
      print(userModel.uId);
      emit(SocialWriteCommentsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialWriteCommentsErrorState());
    });
  }

  Future<void> getComment() async{
    comments = [];
    await FirebaseFirestore.instance
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(userModel.uId);
        comments.add(UserModel.fromJason(element.data()));
      });
      emit(SocialGetCommentsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetCommentsErrorState());
    });
  }
}
