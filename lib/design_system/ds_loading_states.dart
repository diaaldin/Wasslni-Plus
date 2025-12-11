import 'package:flutter/material.dart';
import 'package:wasslni_plus/design_system/design_tokens.dart';

/// Skeleton Loader Widget for loading states
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool shimmer;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.shimmer = true,
  });

  /// Predefined skeleton for text line
  const SkeletonLoader.text({
    super.key,
    this.width = double.infinity,
    this.shimmer = true,
  })  : height = 16,
        borderRadius =
            const BorderRadius.all(Radius.circular(DesignSystem.radiusSmall));

  /// Predefined skeleton for circular avatar
  const SkeletonLoader.circle({
    super.key,
    required double size,
    this.shimmer = true,
  })  : width = size,
        height = size,
        borderRadius =
            const BorderRadius.all(Radius.circular(DesignSystem.radiusFull));

  /// Predefined skeleton for rectangular card
  const SkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.shimmer = true,
  }) : borderRadius =
            const BorderRadius.all(Radius.circular(DesignSystem.radiusMedium));

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.shimmer) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..repeat();

      _animation = Tween<double>(begin: -2, end: 2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.shimmer) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: DesignSystem.neutral200,
        borderRadius: widget.borderRadius ??
            const BorderRadius.all(Radius.circular(DesignSystem.radiusSmall)),
      ),
      child: widget.shimmer
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: const [
                        DesignSystem.neutral200,
                        DesignSystem.neutral100,
                        DesignSystem.neutral200,
                      ],
                      stops: [
                        _animation.value - 0.3,
                        _animation.value,
                        _animation.value + 0.3,
                      ].map((e) => e.clamp(0.0, 1.0)).toList(),
                    ).createShader(bounds);
                  },
                  child: Container(
                    color: Colors.white,
                  ),
                );
              },
            )
          : null,
    );
  }
}

/// Skeleton List - Shows multiple skeleton items
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final EdgeInsets? padding;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
    this.padding,
  });

  /// Predefined list item skeleton
  static Widget listTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingMedium,
        vertical: DesignSystem.paddingSmall,
      ),
      child: Row(
        children: [
          const SkeletonLoader.circle(size: 48),
          const SizedBox(width: DesignSystem.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader.text(width: 200),
                const SizedBox(height: DesignSystem.space2),
                SkeletonLoader(
                  width: 150,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Predefined card skeleton
  static Widget card() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader.card(height: 200),
          const SizedBox(height: DesignSystem.space3),
          const SkeletonLoader.text(width: 250),
          const SizedBox(height: DesignSystem.space2),
          SkeletonLoader(width: 180, height: 12),
          const SizedBox(height: DesignSystem.space2),
          SkeletonLoader(width: 220, height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

/// Loading Overlay - Shows loading indicator over content
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(DesignSystem.paddingLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DesignSystem.primaryColor,
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: DesignSystem.space4),
                        Text(
                          message!,
                          style: DesignSystem.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Inline Loading Indicator - Shows small loading indicator inline
class InlineLoader extends StatelessWidget {
  final String? message;
  final double size;

  const InlineLoader({
    super.key,
    this.message,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              DesignSystem.primaryColor,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(width: DesignSystem.space3),
          Text(
            message!,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Page Loading Indicator - Full page loading
class PageLoader extends StatelessWidget {
  final String? message;

  const PageLoader({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              DesignSystem.primaryColor,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: DesignSystem.space4),
            Text(
              message!,
              style: DesignSystem.bodyLarge.copyWith(
                color: DesignSystem.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Pull to Refresh Wrapper
class PullToRefreshWrapper extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;

  const PullToRefreshWrapper({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? DesignSystem.primaryColor,
      backgroundColor: DesignSystem.surfaceLight,
      child: child,
    );
  }
}

/// Infinite Scroll List View
class InfiniteScrollList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Future<List<T>> Function(int page) onLoadMore;
  final bool hasMore;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final EdgeInsets? padding;
  final Future<void> Function()? onRefresh;

  const InfiniteScrollList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.hasMore,
    this.loadingWidget,
    this.emptyWidget,
    this.padding,
    this.onRefresh,
  });

  @override
  State<InfiniteScrollList<T>> createState() => _InfiniteScrollListState<T>();
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollList<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && widget.hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      await widget.onLoadMore(_currentPage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    Widget listView = ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < widget.items.length) {
          return widget.itemBuilder(context, widget.items[index], index);
        } else {
          // Loading indicator at bottom
          return Padding(
            padding: const EdgeInsets.all(DesignSystem.paddingLarge),
            child: widget.loadingWidget ??
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      DesignSystem.primaryColor,
                    ),
                  ),
                ),
          );
        }
      },
    );

    if (widget.onRefresh != null) {
      listView = PullToRefreshWrapper(
        onRefresh: widget.onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
