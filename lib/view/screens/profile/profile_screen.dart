import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_delivery_boy/controller/auth_controller.dart';
import 'package:sixvalley_delivery_boy/controller/profile_controller.dart';
import 'package:sixvalley_delivery_boy/controller/splash_controller.dart';
//import 'package:sixvalley_delivery_boy/data/http/utills/clear_wallet.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';
import 'package:sixvalley_delivery_boy/utill/color_resources.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/view/screens/auth/login_screen.dart';
import 'package:sixvalley_delivery_boy/view/screens/dashboard/dashboard_screen.dart';
import 'package:sixvalley_delivery_boy/view/screens/home/home_screen.dart';
import 'package:sixvalley_delivery_boy/view/screens/html/html_viewer_screen.dart';
import 'package:sixvalley_delivery_boy/view/screens/profile/widget/profile_button.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key}) : super(key: key);

  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: GetBuilder<AuthController>(
              builder: (profileController) {
                return Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      color: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'my_profile'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).primaryColorDark),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: ColorResources.colorWhite,
                                    width: 3)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage.assetNetwork(
                                  imageErrorBuilder: (c, o, t) =>
                                      Image.asset(Images.placeholder),
                                  placeholder: Images.placeholder,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.fill,
                                  image:
                                      '${Get.find<SplashController>().baseUrls.reviewImageUrl}/delivery-man/${profileController.profileModel.image}',
                                )),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            profileController.profileModel.fName != null
                                ? '${profileController.profileModel.fName ?? ''} ${profileController.profileModel.lName ?? ''}'
                                : "",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Theme.of(context).primaryColorDark),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'theme_style'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        color: Theme.of(context).highlightColor,
                                        fontSize: Dimensions.fontSizeLarge),
                              ),
                              //Theme section.........................
                              // StatusWidget()
                            ],
                          ),
                          const SizedBox(height: 20),
                          _userInfoWidget(
                              context: context,
                              text: profileController.profileModel.fName),
                          const SizedBox(height: 15),
                          _userInfoWidget(
                              context: context,
                              text: profileController.profileModel.lName),
                          const SizedBox(height: 15),
                          _userInfoWidget(
                              context: context,
                              text: profileController.profileModel.phone),
                          const SizedBox(height: 15),
                          Text('wallet'.tr),
                          const SizedBox(
                            height: 10,
                          ),
                          GetBuilder<ProfileController>(
                            //init: ProfileController(),
                            builder: (controller) => _userInfoWidget(
                                context: context,
                                text: profileController.profileModel.wallet
                                    .toString()),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 22),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                                color: Theme.of(context).primaryColor,
                                //  border: Border.all(color: Colors.white),
                              ),
                              child: const Center(
                                child: Text(
                                  'أضف الأموال',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                            onTap: () async {
                              bool status = await clear_wallet(
                                  amount: profileController.profileModel.wallet,
                                  id: profileController.profileModel.id,
                                  context: context);

                              //  await clear_wallet(
                              //     amount: profileController.profileModel.wallet,
                              //     id: profileController.profileModel.id);

                              if (status) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('تم ارسال طلب للإدارة'),
                                        backgroundColor: Colors.green));
                                profileController.profileModel.wallet = 0;
                                Get.to(const DashboardScreen(
                                  pageIndex: 0,
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('لم يتم ارسال الأموال'),
                                        backgroundColor: Colors.red));
                              }
                            },
                          ),
                          ProfileButton(
                              icon: Icons.privacy_tip,
                              title: 'privacy_policy'.tr,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HtmlViewerScreen(
                                            isPrivacyPolicy: true)));
                              }),
                          const SizedBox(height: 10),
                          ProfileButton(
                              icon: Icons.list,
                              title: 'terms_and_condition'.tr,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HtmlViewerScreen(
                                            isPrivacyPolicy: false)));
                              }),
                          const SizedBox(height: 10),
                          ProfileButton(
                              icon: Icons.logout,
                              title: 'logout'.tr,
                              onTap: () {
                                Get.find<AuthController>()
                                    .clearSharedData()
                                    .then((condition) {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                      (route) => false);
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                );
              },
            )));
  }

  Widget _userInfoWidget({String text, BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).cardColor,
          border: Border.all(color: ColorResources.borderColor)),
      child: Text(
        text ?? '',
        style: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(color: Theme.of(context).focusColor),
      ),
    );
  }

  Future<bool> clear_wallet({int amount, int id, BuildContext context}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(id);
    print(amount);
    log(sharedPreferences.get(AppConstants.token));
    if (amount != 0) {
      try {
        http.Response response = await http.get(
          Uri.parse(
              'https://souqadam.com/api/v2/delivery-man/wallet/remove?delivery_man=$id&amount$amount'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'Bearer ${sharedPreferences.get(AppConstants.token)}'
          },
        );
        log(response.body);
        if (response.statusCode == 200) {
          // Map data = jsonDecode(response.body);
          return true;
        } else if (response.statusCode == 500) {
          return false;
          //
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('حدث خطأ ما.. جرب في وقت لاحق'),
            backgroundColor: Colors.red));
      }
      //  throw Exception('status code not 200 it is ${response.statusCode}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('رصيدك فارغ'), backgroundColor: Colors.red),
      );
      return false;
    }
  }
}
