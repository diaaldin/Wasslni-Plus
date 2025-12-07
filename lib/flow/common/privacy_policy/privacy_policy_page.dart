import 'package:flutter/material.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import '../../../widgets/info_section.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.privacy_policy),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.privacy_policy),
              const SizedBox(height: 8),
              Text(s.privacy_intro),
              const SizedBox(height: 24),
              InfoSection(
                icon: Icons.download,
                title: s.data_collection,
                text: s.data_collection_desc,
              ),
              InfoSection(
                icon: Icons.refresh,
                title: s.data_usage,
                text: s.data_usage_desc,
              ),
              InfoSection(
                icon: Icons.share,
                title: s.data_sharing,
                text: s.data_sharing_desc,
              ),
              InfoSection(
                icon: Icons.lock,
                title: s.data_retention,
                text: s.data_retention_desc,
              ),
              InfoSection(
                icon: Icons.phone,
                title: s.phone_number,
                text: '00972-0543596300',
              ),
              InfoSection(
                icon: Icons.verified_user,
                title: s.user_rights,
                text: s.user_rights_desc,
              ),
              const SizedBox(height: 16),
              Text(s.thank_you),
              const SizedBox(height: 8),
              Text(s.contact_support),
            ],
          ),
        ),
      ),
    );
  }
}
