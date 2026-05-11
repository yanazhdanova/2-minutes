import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../shared/widgets.dart';

/// Общая раскладка для экранов авторизации.
/// Хедер остаётся сверху, а форма получает адаптивный отступ от доступной высоты.
class AuthScreenLayout extends StatelessWidget {
  final List<Widget> children;

  const AuthScreenLayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final c = C(context);

    return Scaffold(
      backgroundColor: c.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topGap = math
                .min(math.max(constraints.maxHeight * 0.105, 44.0), 92.0)
                .toDouble();

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                0,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    const AppHeader(),
                    SizedBox(height: topGap),
                    ...children,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
