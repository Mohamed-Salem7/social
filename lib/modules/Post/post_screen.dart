import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      builder: (context, stat) {
        var userModel = SocialAppCubit.get(context).userModel;
        var textController = TextEditingController();
        return Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Create Post',
              ),
              actions: [
                defaultTextButton(
                  function: () {
                    if (SocialAppCubit.get(context).postImage == null) {
                      SocialAppCubit.get(context).createPost(
                        text: textController.text,
                        dateTime: DateTime.now().toString(),
                      );
                    }else
                      {
                        SocialAppCubit.get(context).uploadPost(
                            text: textController.text,
                            dateTime: DateTime.now().toString(),
                        );
                      }
                  },
                  text: 'Post',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                          '${userModel.image}',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '${userModel.name}',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: TextFormField(
                      controller: textController,
                      onTap: () {},
                      decoration: InputDecoration(
                        hintText: 'write is on your mind........',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (SocialAppCubit.get(context).postImage != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 180.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                4.0,
                              ),
                              topRight: Radius.circular(
                                4.0,
                              ),
                            ),
                            image: DecorationImage(
                              image: FileImage(
                                SocialAppCubit.get(context).postImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            SocialAppCubit.get(context).removeImagePost();
                          },
                          icon: CircleAvatar(
                            radius: 20.0,
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Spacer(),
                  InkWell(
                    onTap: ()
                    {
                      SocialAppCubit.get(context).getPostImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconBroken.Image,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'add photo',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
