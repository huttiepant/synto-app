import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin iOSKeyboardInsetUtil<T extends StatefulWidget>
on State<T>, WidgetsBindingObserver {

  bool _isKeyboardVisible = false;

  //1. Only apply if the app is running on (web AND iOS)
  bool get isIOSWeb {
    return kIsWeb && TargetPlatform.iOS == defaultTargetPlatform;
  }

  @override
  void initState() {
    super.initState();
    //2. Listen to WidgetsBinding for didChangeMetrics below
    if (isIOSWeb) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if (isIOSWeb) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    //3. Listen to didChangeMetrics and detect the keyboard hide/show state via viewInsets.bottom.
    super.didChangeMetrics();
    if (isIOSWeb) {
      final bottomInset = View.of(context).viewInsets.bottom;

      //4. Store keyboard "opened" state based on the condition that viewInsets.bottom >0
      final newKeyboardState = bottomInset > 0;

      //5. Update the _isKeyboardVisible and use it in your parent widget if needed.
      if (_isKeyboardVisible != newKeyboardState) {
        setState(() {
          _isKeyboardVisible = newKeyboardState;
        });

        if (!newKeyboardState) {
          //6. If newKeyboardState is false(keyboard is hidden), unfocus from the widget.
          FocusScope.of(context).requestFocus(FocusNode());
        }
      }
    }
  }

  bool get isKeyboardVisible => _isKeyboardVisible;
}