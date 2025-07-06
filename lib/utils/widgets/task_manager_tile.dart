import 'package:flutter/material.dart';

import '../../models/task_manager_model.dart';

class TaskManagerTile extends StatelessWidget {
  final TaskManagerModel manager;
  final VoidCallback onTap;
  final VoidCallback onMorePressed;

  const TaskManagerTile({
    required this.manager,
    required this.onTap,
    required this.onMorePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Color(
      int.parse(manager.colorHex.replaceFirst('#', '0xff')),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              baseColor.withOpacity(0.85),
              Colors.black.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: manager.isPinned
              ? Border.all(
            color: Colors.white,
            width: 2,
          )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(0, 8),
              blurRadius: 30,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Icon(
                Icons.apps,
                size: 100,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (manager.isPinned) ...[
                              Icon(Icons.push_pin,
                                  color: Colors.yellowAccent, size: 20),
                              const SizedBox(width: 6),
                            ],
                            Flexible(
                              child: Text(
                                manager.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          manager.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (manager.isPinned)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Pinned",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: onMorePressed,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
