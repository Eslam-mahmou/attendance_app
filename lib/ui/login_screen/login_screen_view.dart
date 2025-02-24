import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/core/Widget/custom_diaolg.dart';
import 'package:attend_app/core/Widget/custom_validate.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import 'package:attend_app/ui/login_screen/manager/login_state.dart';
import 'package:attend_app/ui/login_screen/manager/login_view_model.dart';
import 'package:attend_app/ui/login_screen/widget/CustomAuthButton.dart';
import 'package:attend_app/ui/login_screen/widget/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = getIt.get<LoginViewModel>(); // Get the instance of LoginView
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: BlocConsumer<LoginViewModel,LoginState>(
            bloc: viewModel,
            listener: (context, state) {
              if(state is LoadingLoginState){
                EasyLoading.show();
              }
              if(state is FailureLoginState){
                EasyLoading.dismiss();
                DialogUtils.showMessage(context: context, message:state.errMessage,
                title: "Error",
                postActionName: "Cancel",);
              }
              if(state is SuccessLoginState){
                EasyLoading.dismiss();
                Navigator.pushReplacementNamed(context, PagesRoutes.layoutScreen);
              }
            },
            builder: (context, state) {
              return Form(
                key: viewModel.formLoginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200.h,
                    ),
                    Image.asset(
                      ImageAssets.appLogo,
                      scale: .9,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "  Welcome To FCAI\nAttendance System 👋",
                      style: getTextStyle(FontSize.s28, FontWeightManager.medium,
                          ColorsManager.blackColor),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFormField(
                      validate: AppValidate.validateEmail,
                        controller: viewModel.emailController,
                        keyboardType: TextInputType.emailAddress, text: "Email"),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      validate: AppValidate.validatePassword,
                      controller: viewModel.passwordController,
                      text: "password",
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.visibility_outlined)),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomButton(
                        onPressed: () {
                          if(viewModel.formLoginKey.currentState!.validate()){
                            viewModel.login();
                          }
                        },
                        child: Text(
                          "Login",
                          style: getTextStyle(FontSize.s16, FontWeightManager.light,
                              ColorsManager.whiteColor),
                        ))
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
