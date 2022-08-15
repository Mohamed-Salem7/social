import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/component/constant.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userModel = SocialAppCubit.get(context).userModel;
    return BuildCondition(
      condition: userModel != null,
      builder: (context) => BlocConsumer<SocialAppCubit, SocialAppStates>(
        builder: (context, state) {
          var nameController = TextEditingController();
          var bioController = TextEditingController();
          var phoneController = TextEditingController();


          nameController.text = userModel.name;
          bioController.text = userModel.bio;
          phoneController.text = userModel.phone;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Edit Profile',
              ),
              actions: [
                defaultTextButton(
                  function: () {
                    SocialAppCubit.get(context).updateData(
                      name: nameController.text,
                      bio: bioController.text,
                      phone: phoneController.text,
                    );
                  },
                  text: 'Update',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is SocialAppGetUserDataLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  //margin: EdgeInsets.all(8.0),
                                  height: 140.0,
                                  //alignment: AlignmentDirectional.topCenter,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    // image: DecorationImage(
                                    //   //image:
                                    // //     SocialAppCubit.get(context).coverImage ==
                                    // //     null
                                    // //     ? NetworkImage(userModel.cover)
                                    // //     : FileImage(
                                    // //   userModel.coverImage,
                                    // // ),
                                    //   //fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: ()
                                  {
                                    SocialAppCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 15.0,
                                    child: Icon(
                                      IconBroken.Camera,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 62.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 57.0,
                                  // backgroundImage:
                                  //     SocialAppCubit.get(context).profileImage ==
                                  //             null
                                  //         ? NetworkImage('${userModel.image}')
                                  //         : FileImage(
                                  //             SocialAppCubit.get(context)
                                  //                 .profileImage,
                                  //           ),
                                ),
                              ),
                              IconButton(
                                onPressed: ()
                                {
                                  SocialAppCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 15.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (SocialAppCubit.get(context).profileImage != null ||
                        SocialAppCubit.get(context).coverImage != null)
                      Row(
                        children: [
                          if (SocialAppCubit.get(context).userModel.image != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  SocialAppCubit.get(context).uploadProfile(
                                    name: nameController.text,
                                    bio: bioController.text,
                                    phone: phoneController.text,
                                  );
                                },
                                child: Text(
                                  'Upload Image',
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (SocialAppCubit.get(context).userModel.cover != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  SocialAppCubit.get(context).uploadCover(
                                    phone: phoneController.text,
                                    name: nameController.text,
                                    bio: bioController.text,
                                  );
                                },
                                child: Text(
                                  'Upload Cover',
                                ),
                              ),
                            ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 8.0,
                        //end: 8.0,
                      ),
                      child: defaultForm(
                        controller: nameController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'email must be not empty';
                          }
                          return null as String;
                        },
                        label: 'Name',
                        prefix: IconBroken.User,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 8.0,
                        //end: 8.0,
                      ),
                      child: defaultForm(
                        controller: bioController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'bio must be not empty';
                          }
                          return null as String;
                        },
                        label: 'Bio',
                        prefix: IconBroken.Info_Circle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 8.0,
                        //end: 8.0,
                      ),
                      child: defaultForm(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'phone must be not empty';
                          }
                          return null as String;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is SocialAppGetUserDataSuccessState) {}
        },
      ),
    );
  }
}
