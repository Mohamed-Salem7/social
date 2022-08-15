import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/models/message_models.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';
import 'package:intl/intl.dart';

class ChatsMessage extends StatelessWidget {
  UserModel userModel;


  ChatsMessage({required this.userModel});
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {

      SocialAppCubit.get(context).getMessage(receiverId: userModel.uId);

      return BlocConsumer<SocialAppCubit, SocialAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 15.0,
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
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      IconBroken.Info_Circle,
                    ),
                  ),
                ],
              ),
              body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index)
                          {
                            var message = SocialAppCubit.get(context).messages[index];

                            if(SocialAppCubit.get(context).userModel.uId == message.senderId)
                              return buildMyMessage(message);
                            return buildMessage(message);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15.0,
                          ),
                          itemCount: SocialAppCubit.get(context).messages.length,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onTap: () {},
                                controller: messageController,
                                decoration: InputDecoration(
                                  filled: true,
                                  //alignLabelWithHint: true,
                                  contentPadding: EdgeInsets.all(8.0),
                                  hintText: 'write a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.blue,

                              child: IconButton(
                                onPressed: () {
                                  SocialAppCubit.get(context).sendMessage(
                                    text: messageController.text,
                                    receiverId: userModel.uId,
                                    dateTime: DateTime.now().toString(),
                                  );
                                },
                                icon: Icon(
                                  IconBroken.Send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            );
          });
    });
  }

  Widget buildMessage(MessageModels messageModels) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: EdgeInsetsDirectional.all(8.0),
          child: Container(
            padding: EdgeInsetsDirectional.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              messageModels.text,
            ),
          ),
        ),
      );

  Widget buildMyMessage(MessageModels messageModels) => Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Padding(
          padding: EdgeInsetsDirectional.all(8.0),
          child: Container(
            padding: EdgeInsetsDirectional.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: Text(
              messageModels.text,
            ),
          ),
        ),
      );
}
