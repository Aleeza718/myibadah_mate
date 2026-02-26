import 'package:flutter/material.dart';
import '../services/hijri_service.dart';
import '../models/hijri_date_model.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const AppBarWidget({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            title ?? 'IbadahMate',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          FutureBuilder<HijriDateModel?>(
            future: HijriService.getHijriDate(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox();
              }
              final h = snapshot.data!;
              return Text(
                '${h.day} ${h.month} ${h.year} AH',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
              );
            },
          ),
        ],
      ),
      centerTitle: true,
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
