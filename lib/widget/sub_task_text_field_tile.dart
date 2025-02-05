import 'package:flutter/material.dart';

import '../global_variable.dart';
import '../helper_service.dart';
import 'sub_task_leading_widget.dart';

class SubTaskTextFieldTile extends StatelessWidget {
  final List<AllState> dependentState;
  final AllState currentState;
  final AllState loadingState;
  final TextEditingController? controller;
  final Function()? onConfirmTap;
  final Function()? onSkipTap;

  const SubTaskTextFieldTile({
    super.key,
    required this.dependentState,
    required this.currentState,
    required this.loadingState,
    this.controller,
    this.onConfirmTap,
    this.onSkipTap,
  });

  bool get enable => HelperService().checkIsLoading(
        dependentState: dependentState,
        currentState: currentState,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 24 + 8,
                width: 24 + 8 + (16 * 2),
              ),
              SubTaskLeadingWidget(
                dependentState: dependentState,
                currentState: currentState,
                loadingState: loadingState,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enable,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter Google map API Key",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    hintStyle: TextStyle(
                      // Hint text style
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 32,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(width: 24 + 8 + (16 * 2) + 18 + 16),
              TextButton(
                onPressed: !enable ? null : onConfirmTap,
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: !enable ? null : onSkipTap,
                child: Text(
                  "Skip",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
