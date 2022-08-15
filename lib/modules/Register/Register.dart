import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/layout/social.dart';
import 'package:flutter_social/modules/Login/cubit/cubit.dart';
import 'package:flutter_social/modules/Register/cubit/cubit.dart';
import 'package:flutter_social/modules/Register/cubit/state.dart';
import 'package:flutter_social/shared/component/components.dart';
import 'package:flutter_social/shared/styles/icon_broken.dart';

class SocialRegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state)
        {
          if(state is SocialRegisterSuccessState)
            navigatorFinished(context, SocialLayout());
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Register'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       defaultForm(
                          controller: nameController,
                          label: 'Name',
                          prefix: Icons.perm_identity_outlined,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty)
                              return 'Please enter Email Address';
                            return null as String;
                          },
                        ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultForm(
                        controller: emailController,
                        label: 'Email Address',
                        prefix: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validate: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Please enter Email Address';
                          }
                          return null as String;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultForm(
                        controller: passwordController,
                        label: 'Password',
                        suffix: SocialRegisterCubit.get(context).suffix,
                        suffixPressed: () {
                          SocialRegisterCubit.get(context)
                              .changePasswordShown();
                        },
                        isPassword: SocialRegisterCubit.get(context).isPassword,
                        prefix: Icons.lock_outline_rounded,
                        type: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Password is too short';
                          }
                          return null as String;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultForm(
                        controller: phoneController,
                        label: 'Phone',
                        prefix: Icons.phone,
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Phone';
                          }
                          return null as String;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildCondition(
                        condition : state is! SocialRegisterLoadingState,
                        builder:(context)=> defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              SocialRegisterCubit.get(context).userAccount(
                                email: emailController.text,
                                name: nameController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          text: 'Register Now',
                        ),
                        fallback: (context) => Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
