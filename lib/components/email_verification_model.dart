import '/flutter_flow/flutter_flow_util.dart';
import 'email_verification_widget.dart' show EmailVerificationWidget;
import 'package:flutter/material.dart';

class EmailVerificationModel extends FlutterFlowModel<EmailVerificationWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeController?.dispose();
  }
}
