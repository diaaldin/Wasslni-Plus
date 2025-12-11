import 'package:flutter/material.dart';
import 'package:wasslni_plus/design_system/design_tokens.dart';
import 'package:wasslni_plus/design_system/ds_button.dart';

/// Empty State Widget - Shows when there's no data
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.illustration,
  });

  /// Predefined empty state for no data
  factory EmptyState.noData({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Predefined empty state for no results
  factory EmptyState.noResults({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Predefined empty state for no notifications
  factory EmptyState.noNotifications({
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message: 'You\'re all caught up! No new notifications at the moment.',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Predefined empty state for no parcels
  factory EmptyState.noParcels({
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'No Parcels',
      message:
          'You haven\'t created any parcels yet. Start by adding your first parcel!',
      actionLabel: actionLabel ?? 'Add Parcel',
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or Icon
            if (illustration != null)
              illustration!
            else
              Container(
                padding: const EdgeInsets.all(DesignSystem.paddingLarge),
                decoration: const BoxDecoration(
                  color: DesignSystem.neutral100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 80,
                  color: DesignSystem.neutral400,
                ),
              ),

            const SizedBox(height: DesignSystem.space6),

            // Title
            Text(
              title,
              style: DesignSystem.h5.copyWith(
                color: DesignSystem.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: DesignSystem.space3),

            // Message
            Text(
              message,
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DesignSystem.space6),
              DSButton(
                text: actionLabel!,
                onPressed: onAction,
                variant: DSButtonVariant.primary,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error State Widget - Shows when there's an error
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;
  final IconData icon;
  final Color? iconColor;

  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.iconColor,
  });

  /// Predefined error state for network error
  factory ErrorState.network({
    String? message,
    VoidCallback? onRetry,
  }) {
    return ErrorState(
      icon: Icons.wifi_off,
      title: 'Connection Error',
      message: message ??
          'Unable to connect to the server. Please check your internet connection and try again.',
      actionLabel: 'Retry',
      onRetry: onRetry,
      iconColor: DesignSystem.warning,
    );
  }

  /// Predefined error state for server error
  factory ErrorState.server({
    String? message,
    VoidCallback? onRetry,
  }) {
    return ErrorState(
      icon: Icons.cloud_off,
      title: 'Server Error',
      message:
          message ?? 'Something went wrong on our end. Please try again later.',
      actionLabel: 'Retry',
      onRetry: onRetry,
      iconColor: DesignSystem.error,
    );
  }

  /// Predefined error state for permission denied
  factory ErrorState.permissionDenied({
    String? message,
    VoidCallback? onAction,
  }) {
    return ErrorState(
      icon: Icons.lock_outline,
      title: 'Access Denied',
      message: message ?? 'You don\'t have permission to access this resource.',
      actionLabel: 'Go Back',
      onRetry: onAction,
      iconColor: DesignSystem.warning,
    );
  }

  /// Predefined error state for not found
  factory ErrorState.notFound({
    String? message,
    VoidCallback? onAction,
  }) {
    return ErrorState(
      icon: Icons.search_off,
      title: 'Not Found',
      message: message ??
          'The item you\'re looking for doesn\'t exist or has been removed.',
      actionLabel: 'Go Back',
      onRetry: onAction,
      iconColor: DesignSystem.neutral500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(DesignSystem.paddingLarge),
              decoration: BoxDecoration(
                color: (iconColor ?? DesignSystem.error).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: iconColor ?? DesignSystem.error,
              ),
            ),

            const SizedBox(height: DesignSystem.space6),

            // Title
            Text(
              title,
              style: DesignSystem.h5.copyWith(
                color: DesignSystem.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: DesignSystem.space3),

            // Message
            Text(
              message,
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (actionLabel != null && onRetry != null) ...[
              const SizedBox(height: DesignSystem.space6),
              DSButton(
                text: actionLabel!,
                onPressed: onRetry,
                variant: DSButtonVariant.primary,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success State Widget - Shows success message
class SuccessState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SuccessState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(DesignSystem.paddingLarge),
              decoration: const BoxDecoration(
                color: DesignSystem.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: DesignSystem.success,
              ),
            ),

            const SizedBox(height: DesignSystem.space6),

            // Title
            Text(
              title,
              style: DesignSystem.h5.copyWith(
                color: DesignSystem.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: DesignSystem.space3),

            // Message
            Text(
              message,
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DesignSystem.space6),
              DSButton(
                text: actionLabel!,
                onPressed: onAction,
                variant: DSButtonVariant.success,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Generic State Container - Switches between loading, error, empty, and content states
class StateContainer<T> extends StatelessWidget {
  final Future<T>? data;
  final Widget Function(T data) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final bool Function(T data)? isEmpty;

  const StateContainer({
    super.key,
    required this.data,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: data,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const PageLoader();
        }

        // Error state
        if (snapshot.hasError) {
          return errorWidget ??
              ErrorState.server(
                message: snapshot.error.toString(),
                onRetry: () {
                  // Trigger rebuild
                  (context as Element).markNeedsBuild();
                },
              );
        }

        // Empty state
        if (snapshot.hasData) {
          final isDataEmpty = isEmpty?.call(snapshot.data as T) ?? false;
          if (isDataEmpty && emptyWidget != null) {
            return emptyWidget!;
          }

          // Content state
          return builder(snapshot.data as T);
        }

        // Default loading
        return loadingWidget ?? const PageLoader();
      },
    );
  }
}

/// Page Loader widget for full-page loading
class PageLoader extends StatelessWidget {
  final String? message;

  const PageLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(DesignSystem.primaryColor),
          ),
          if (message != null) ...[
            const SizedBox(height: DesignSystem.space4),
            Text(
              message!,
              style: DesignSystem.bodyMedium.copyWith(
                color: DesignSystem.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
