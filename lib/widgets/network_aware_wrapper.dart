import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';

class NetworkAwareWrapper extends StatelessWidget {
  final Widget child;
  final bool showOfflineBanner;

  const NetworkAwareWrapper({
    super.key,
    required this.child,
    this.showOfflineBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showOfflineBanner) return child;

    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged, // Assuming v5 stream
      builder: (context, snapshot) {
        final result = snapshot.data;
        final isOffline = result == ConnectivityResult.none;

        if (!isOffline) return child;

        return Column(
          children: [
            Expanded(child: child),
            Container(
              width: double.infinity,
              color: Colors.red[800],
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                S.of(context).no_internet_connection,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }
}
