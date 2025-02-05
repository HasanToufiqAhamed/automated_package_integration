import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const SelectionButton({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.grey,
          ),
        ),
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            FlutterLogo(
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
