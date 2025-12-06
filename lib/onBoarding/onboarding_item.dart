import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import 'onboarding_model.dart';

class OnBoardingItem extends StatelessWidget {
  final OnBoardingModel model;
  final bool isFirstPage;
  final bool isLastPage;
  final int index;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const OnBoardingItem({
    super.key,
    required this.model,
    required this.isFirstPage,
    required this.isLastPage,
    required this.index,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية
        Positioned.fill(
          child: Image.asset(
            model.image,
            fit: BoxFit.cover,
          ),
        ),

        // Gradient لكل الصفحات ما عدا الأولى
        if (!isFirstPage)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

        // =========================
        // الصفحة الأولى — النص فوق الزرار
        // =========================
        if (isFirstPage)
          Positioned(
            bottom: 170,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  model.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:AppColor.whiteColor,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

        // زرار الصفحة الأولى فقط
        if (isFirstPage)
          Positioned(
            bottom: 40,
            left:10,
            right: 10,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.yellow,
                foregroundColor: AppColor.blackColor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Explore Now",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),

        // =========================
        // باقي الصفحات — بوكس أسود داخله الكلام + الأزرار
        // =========================
        if (!isFirstPage)
          Positioned(
            bottom: 0.00001,
            left: 0.0001,
            right:0.00001,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50) ,topRight: Radius.circular(50)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    model.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 20),

                  // زر Next / Finish
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.yellow,
                        foregroundColor: AppColor.blackColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isLastPage ? "Finish" : "Next",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // زر Back
                  if (index > 1) ...[
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onBack,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.yellow, width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(color: AppColor.yellow),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
