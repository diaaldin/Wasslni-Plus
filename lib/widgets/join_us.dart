import 'package:flutter/material.dart';
import 'package:turoudi/generated/l10n.dart';
import 'package:turoudi/widgets/join_us_description.dart';
import 'package:turoudi/widgets/join_us_form.dart';
import 'package:turoudi/widgets/policy_checkbox_row.dart';
import 'package:turoudi/widgets/primary_buttom.dart';

class JoinUs extends StatefulWidget {
  const JoinUs({super.key});

  @override
  State<JoinUs> createState() => _JoinUsPageState();
}

class _JoinUsPageState extends State<JoinUs> {
  bool acceptedPolicy = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.joinUs)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const JoinUsDescriptionCard(),
            const SizedBox(height: 16),
            PolicyCheckboxRow(
              value: acceptedPolicy,
              onChanged: (value) => setState(() => acceptedPolicy = value),
            ),
            const SizedBox(height: 8),
            if (acceptedPolicy) const JoinUsForm(),
            const Spacer(),
            PrimaryButton(
              text: s.submit,
              onPressed: () {
                // send logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
