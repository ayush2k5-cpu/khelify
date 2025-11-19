import 'package:flutter/material.dart';
import 'record_modal_sheet.dart';

class RecordFullModal extends StatelessWidget {
  final VoidCallback? onClose;
  const RecordFullModal({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return RecordModalSheet(
      onDrillSelected: (_) {
        if (onClose != null) onClose!();
      },
    );
  }
}
