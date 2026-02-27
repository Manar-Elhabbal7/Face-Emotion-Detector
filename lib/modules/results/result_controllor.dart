import 'package:face_condition_detector/services/face_analyzer.dart';
import 'package:get/get.dart';

class ResultController extends GetxController {
  var result = Rxn<Result>();

  void setResult(Result newResult) {
    result.value = newResult;
    print(' Result set: ${newResult.emotionalState} - ${newResult.lightingStatus}');
  }

  void clearResult() {
    result.value = null;
  }
}