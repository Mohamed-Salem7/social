import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/models/comments_models.dart';
import 'package:flutter_social/models/post_models.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/component/constant.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  var commentController = TextEditingController();

  late UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context)
    {
      SocialAppCubit.get(context).getComment();
      return BlocConsumer<SocialAppCubit, SocialAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: defaultAppBar(
              title: '',
              context: context,
              actions: [
                IconButton(
                  icon: Icon(IconBroken.Search),
                  onPressed: () {},
                ),
                SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            body: BuildCondition(
              condition: true,
              builder: (context) =>
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => buildComment(SocialAppCubit.get(context).comments[index], context),
                                itemCount:
                                SocialAppCubit
                                    .get(context)
                                    .comments
                                    .length,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.grey[500],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.none,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey[400],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onTap: () {},
                                  controller: commentController,
                                  scrollPhysics: NeverScrollableScrollPhysics(),
                                  //cursorColor: Colors.red,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    focusColor: Colors.red,
                                    hintText: 'write a comment...',
                                    //border: InputBorder.none,
                                    //alignLabelWithHint: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialAppCubit.get(context).writeComment(
                                      text: commentController.text
                                  );
                                },
                                icon: Icon(
                                  IconBroken.Send,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
              fallback: (context) =>
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'No Comments yet',
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.none,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey[400],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onTap: () {},
                                  controller: commentController,
                                  scrollPhysics: NeverScrollableScrollPhysics(),
                                  //cursorColor: Colors.red,
                                  decoration: InputDecoration(
                                    filled: true,
                                    border: InputBorder.none,
                                    focusColor: Colors.red,
                                    hintText: 'write a comment...',
                                    //border: InputBorder.none,
                                    //alignLabelWithHint: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialAppCubit.get(context).writeComment(
                                    text: commentController.text,
                                  );
                                },
                                icon: Icon(
                                  IconBroken.Send,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
            ),
          );
        },
      );
    });
  }

  Widget buildComment(UserModel commentsModels, context) => Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    '${commentsModels.image}',
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey[400],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${commentsModels.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                              ),
                              Text(
                                '${commentsModels.text}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 30.0,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Likes',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            child: Row(
                              children: [
                                Text('120'),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Icon(IconBroken.Heart),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
