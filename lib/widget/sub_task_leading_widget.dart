import 'package:flutter/material.dart';

import '../global_variable.dart';
import '../helper_service.dart';

class SubTaskLeadingWidget extends StatelessWidget {
  final List<AllState> dependentState;
  final AllState currentState;
  final AllState loadingState;
  final AllState? errorState;

  const SubTaskLeadingWidget({
    super.key,
    required this.dependentState,
    required this.currentState,
    required this.loadingState,
    this.errorState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 18,
      alignment: Alignment.center,
      child: HelperService().checkIsLoading(dependentState: dependentState, currentState: currentState)
          ? CircularProgressIndicator(
              strokeWidth: 2,
            )
          : _checkError()
              ? Icon(
                  Icons.error_outline_rounded,
                  size: 18,
                )
              : HelperService().checkIsDone(
                  dependentState: dependentState,
                  currentState: currentState,
                )
                  ? Icon(
                      Icons.check,
                      size: 18,
                    )
                  : Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),
                    ),
    );
  }

  bool _checkError() {
    return currentState == errorState;
  }
}
