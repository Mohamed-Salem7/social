import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/models/post_models.dart';
import 'package:flutter_social/modules/comment/comments.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BuildCondition(
          condition: SocialAppCubit.get(context).posts.length > 0,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(8.0),
                  elevation: 10.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image(
                        image: NetworkImage(
                            'https://as2.ftcdn.net/v2/jpg/02/09/29/21/500_F_209292126_UkSyfTJC11fG1IlgX5iuOZQhedJqywDI.jpg'),
                        fit: BoxFit.cover,
                        height: 180.0,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildPost(
                      SocialAppCubit.get(context).posts[index], context, index),
                  itemCount: SocialAppCubit.get(context).posts.length,
                ),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPost(PostModels postModels, context, index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.all(8.0),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                      '${postModels.image}',
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${postModels.name}',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 15.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '${postModels.dateTime}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                    ),
                  ),
                ],
              ),
              myDivider(),
              SizedBox(
                height: 15.0,
              ),
              Text(
                '${postModels.text}',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Wrap(
              // crossAxisAlignment: WrapCrossAlignment.start,
              //  alignment: WrapAlignment.start,
              //  children: [
              //Container(
              // height: 25.0,
              //child: Padding(
              //padding: const EdgeInsetsDirectional.only(
              //  end: 5.0,
              //),
              // child: MaterialButton(
              // onPressed: () {},
              // minWidth: 1.0,
              //  padding: EdgeInsets.zero,
              //  child: Text(
              //    '#software',
              //     style: TextStyle(
              //        color: Colors.blue,
              //       ),
              //      ),
              //     ),
              //   ),
              //  ),
              // ],
              //),
              if (postModels.postImage != '')
                Card(
                  margin: EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(
                    image: NetworkImage(
                      '${postModels.postImage}',
                    ),
                    fit: BoxFit.cover,
                    height: 180.0,
                    width: double.infinity,
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 20.0,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${SocialAppCubit.get(context).like[index]}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              IconBroken.Send,
                              color: Colors.amber,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${SocialAppCubit.get(context).comments.length} comments',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              myDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigatorTo(context, CommentsScreen());
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                '${SocialAppCubit.get(context).userModel.image}',
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'write a comment......',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        SocialAppCubit.get(context).likePosts(
                            SocialAppCubit.get(context).likePost[index]);
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 20.0,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            'Like',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
