import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/cubit/cubit.dart';
import 'package:flutter_social/layout/cubit/state.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/modules/chats_message/chats_message.dart';
import 'package:flutter_social/shared/component/components.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BuildCondition(
          condition: SocialAppCubit
              .get(context)
              .users.length > 0,
          builder: (context) =>
              ListView.separated(itemBuilder: (context, index) => buildChats(SocialAppCubit.get(context).users[index],context),
                separatorBuilder: (context, index) => myDivider(),
                itemCount: SocialAppCubit
                    .get(context)
                    .users.length,
              ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChats(UserModel userModel,context) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                navigatorTo(context, ChatsMessage(userModel: userModel,));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
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
            ),
          ),
        ],
      );
}
