import 'package:flutter/material.dart';

import '../global_variable.dart';
import '../helper_service.dart';
import 'sub_task_leading_widget.dart';

class SubTaskTile extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final List<AllState> dependentState;
  final AllState currentState;
  final AllState loadingState;
  final AllState? errorState;
  final Widget? icon;

  const SubTaskTile({
    super.key,
    required this.title,
    this.onTap,
    required this.dependentState,
    required this.currentState,
    required this.loadingState,
    this.errorState,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 24 + 8,
              width: 24 + 8 + (16 * 2),
            ),
            SubTaskLeadingWidget(
              dependentState: dependentState,
              currentState: currentState,
              loadingState: loadingState,
              errorState: errorState,
            ),
            SizedBox(
              width: 16,
            ),
            Visibility(
              visible: icon != null,
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: icon,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: onTap != null
                        ? Colors.blueAccent
                        : HelperService().checkIsDone(
                            dependentState: dependentState,
                            currentState: currentState,
                          )
                            ? null
                            : Colors.grey,
                    fontWeight: FontWeight.w400,
                    decoration: onTap != null ? TextDecoration.underline : null,
                    decorationColor: Colors.blueAccent,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
