import 'package:KafeKotaKita/Constant/images.dart';
import 'package:KafeKotaKita/components/widget/carousel/model/model_carousel.dart';
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:get/get.dart';


List<CarouselItemData> kCarouselitems = [
  CarouselItemData(
    imgUrl: caroImg.moodbanner1,
    onTap: () {
      Get.toNamed(AppRoutes.mood,arguments: {
        'carouselType':'mood1',
        'title':'Nugas Nich',
      });
    },
  ),
  CarouselItemData(
    imgUrl: caroImg.moodbanner2,
    onTap: () {
      Get.toNamed(AppRoutes.mood,arguments: {
        'carouselType':'mood3',
        'title':'Ngedate Nich',
      });
    },
  ),
  CarouselItemData(
    imgUrl: caroImg.moodbanner3,
    onTap: () {
      Get.toNamed(AppRoutes.mood, arguments: {
        'carouselType':'mood3',
        'title':'Galau yaa?',
      });
    },
  )
];
