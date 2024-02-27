import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:keyboard_utils/keyboard_listener.dart' as keylib;
// import 'package:keyboard_utils/keyboard_utils.dart' as keyutil;

class CuponesController extends GetxController {
  final added = false.obs;

  // Keyboard variables
  /*  keyutil.KeyboardUtils _keyboardUtils = keyutil.KeyboardUtils(); */
  int? _idKeyboardListener;

  final inputPadding = 0.0.obs;

  final iptFNode = FocusNode();

  final showInputLayer = false.obs;

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  void _init() {
    /* _idKeyboardListener = _keyboardUtils.add(
      listener: keylib.KeyboardListener(
        willHideKeyboard: () {
          print(
              '_keyboardUtils.keyboardHeight: ${_keyboardUtils.keyboardHeight}');
          // _streamController.sink.add(_keyboardUtils.keyboardHeight);
          inputPadding.value = _keyboardUtils.keyboardHeight;
        },
        willShowKeyboard: (double keyboardHeight) {
          print('keyboardHeight: $keyboardHeight');
          // _streamController.sink.add(keyboardHeight);
          inputPadding.value = keyboardHeight;
        },
      ),
    ); */
    print('_idKeyboardListener: $_idKeyboardListener');
  }

  @override
  void onClose() {
    super.onClose();

    /* _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    } */

    iptFNode.dispose();
  }

  void onUserSubmitCode() async {
    Get.focusScope?.unfocus();
    showInputLayer.value = false;
    added.value = true;
  }

  void onAddButtonTap() async {
    showInputLayer.value = true;
    iptFNode.requestFocus();
  }

  void onCloseInputButtonTap() async {
    showInputLayer.value = false;
  }
}
