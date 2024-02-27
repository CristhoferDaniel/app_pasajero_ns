import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/password/secure_password_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurePasswordPage extends StatelessWidget {
  final SecurePasswordController _conX;
  final _appX = Get.find<AppPrefsController>();

  SecurePasswordPage(this._conX);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<SecurePasswordController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Contraseña',
              subtitle: _conX.isEditMode
                  ? 'Cambiar contraseña'
                  : (_conX.firebaseAuthType == FirebaseAuthType.create
                      ? 'Crea una contraseña'
                      : 'Introduce tu contraseña'),
              onBack: () async {
                if (await _conX.handleBack()) Get.back();
              },
              children: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Content(
                          child: Column(
                            children: [
                              _buildForm(),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomActions(),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => LoadingOverlay(_conX.loading.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _conX.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: akContentPadding),
          _conX.isEditMode
              ? AkText(
                  'Por seguridad, primero ingresa la contraseña actual.',
                  style: TextStyle(
                    color: akTextColor.withOpacity(.75),
                  ),
                )
              : AkText(
                  _conX.firebaseAuthType == FirebaseAuthType.create
                      ? 'Necesitarás 6 o más caracteres.'
                      : 'Hola de nuevo, introduce la contraseña de tu cuenta Taxigua: \n\n   ${Helpers.getObfuscateEmail(_conX.email)}',
                  // : 'Introduce la contraseña de tu cuenta \nemail\n para actualizar tu nuevo número.',
                  style: TextStyle(
                    color: akTextColor.withOpacity(.75),
                  ),
                ),
          SizedBox(height: 20),
          _conX.isEditMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _editPasswordLabels('Contraseña actual'),
                    Obx(
                      () => AkInput(
                        maxLength: 30,
                        focusNode: _conX.currentPasswordFocusNode,
                        obscureText: _conX.hideCurrentPassword.value,
                        filledColor: Colors.transparent,
                        type: AkInputType.underline,
                        hintText: 'Contraseña actual',
                        validator: _conX.validatePassword,
                        labelColor: akTextColor.withOpacity(0.35),
                        onSaved: (text) => _conX.currentPassword = text!.trim(),
                        textInputAction: TextInputAction.next,
                        suffixIcon: _conX.hidePassword.value
                            ? Icon(Icons.visibility_rounded)
                            : Icon(Icons.visibility_off_rounded),
                        enableClean: false,
                        onSuffixIconTap: _conX.toggleCurrentPasswordVisibility,
                        onFieldSubmitted: (_) =>
                            _conX.passwordFocusNode.requestFocus(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _editPasswordLabels('Nueva contraseña'),
                  ],
                )
              : SizedBox(),
          Obx(() => AkInput(
                maxLength: 30,
                controller: _conX.passwordCtlr,
                focusNode: _conX.passwordFocusNode,
                obscureText: _conX.hidePassword.value,
                filledColor: Colors.transparent,
                type: AkInputType.underline,
                hintText: _conX.firebaseAuthType == FirebaseAuthType.create
                    ? (_conX.isEditMode
                        ? 'Nueva contraseña'
                        : 'Escribe una contraseña')
                    : 'Escribe la contraseña',
                validator: _conX.validatePassword,
                labelColor: akTextColor.withOpacity(0.35),
                onSaved: (text) => _conX.password = text!.trim(),
                textInputAction: TextInputAction.next,
                suffixIcon: _conX.hidePassword.value
                    ? Icon(Icons.visibility_rounded)
                    : Icon(Icons.visibility_off_rounded),
                enableClean: false,
                onSuffixIconTap: _conX.togglePasswordVisibility,
                onFieldSubmitted: (_) =>
                    _conX.confirmPasswordFocusNode.requestFocus(),
                onChanged: _conX.handleStatusNextButton,
              )),
          _conX.firebaseAuthType == FirebaseAuthType.create
              ? Obx(() => AkInput(
                    maxLength: 30,
                    focusNode: _conX.confirmPasswordFocusNode,
                    obscureText: _conX.hideConfirmPassword.value,
                    filledColor: Colors.transparent,
                    type: AkInputType.underline,
                    hintText: _conX.isEditMode
                        ? 'Repite nueva contraseña'
                        : 'Repite la contraseña',
                    validator: _conX.validateConfirmPassword,
                    labelColor: akTextColor.withOpacity(0.35),
                    suffixIcon: _conX.hideConfirmPassword.value
                        ? Icon(Icons.visibility_rounded)
                        : Icon(Icons.visibility_off_rounded),
                    enableClean: false,
                    onSuffixIconTap: _conX.toggleConfirmPasswordVisibility,
                    onSaved: (text) => _conX.confirmPassword = text!.trim(),
                    textInputAction: TextInputAction.next,
                  ))
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _editPasswordLabels(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: AkText(
        title,
        style: TextStyle(
          color: akTitleColor,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _labelLostPassword(),
          SizedBox(height: 20),
          Obx(() => AkButton(
                onPressed: _conX.onNextPressed,
                text: 'Siguiente',
                fluid: true,
                enableMargin: false,
                disabled: _conX.disabledNextButton.value,
              )),
        ],
      ),
    );
  }

  Widget _labelLostPassword() {
    Widget widget = GestureDetector(
      onTap: _conX.goToResetPasswordPage,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: AkText(
              'He olvidado mi contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: akSecondaryColor,
                fontSize: akFontSize + 1.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    return _conX.firebaseAuthType == FirebaseAuthType.create
        ? SizedBox()
        : widget;
  }
}
