import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final int index;

  const TaskTile({
    super.key,
    required this.index,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 24 + 8,
            width: 24 + 8,
            decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(200)),
            margin: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              index.toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Text(title, style: Theme.of(context).textTheme.titleLarge,)
        ],
      ),
    );
  }
}
