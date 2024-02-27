/*part of 'utils.dart';

class KeyboardController extends GetxController {
  // Keyboard variables
  //KeyboardUtils _keyboardUtils = KeyboardUtils();
  //KeyboardUtils get keyboardUtils => this._keyboardUtils;
  int? _idKeyboardListener;

  RxDouble keyboardHeight = (0.0).obs;

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  @override
  void onClose() {
    super.onClose();

    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
  }

  void _init() {
    _idKeyboardListener = _keyboardUtils.add(
      listener: kl.KeyboardListener(
        willHideKeyboard: () {
          //print('HIDE: ${_keyboardUtils.keyboardHeight}');
          // inputPadding.value = _keyboardUtils.keyboardHeight;
          keyboardHeight.value = _keyboardUtils.keyboardHeight;
        },
        willShowKeyboard: (double keybdheight) {
          // print('SHOW: ${keyboardHeight}');
          // inputPadding.value = keyboardHeight;
          keyboardHeight.value = keybdheight;
        },
      ),
    );
  }
}
*/