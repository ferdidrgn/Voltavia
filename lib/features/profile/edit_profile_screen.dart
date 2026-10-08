import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/initials_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _nameController.text = AppStateScope.of(context).displayName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await AppStateScope.of(context).setDisplayName(_nameController.text);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final name = _nameController.text.trim().isEmpty ? 'Misafir' : _nameController.text.trim();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Kaydet')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: InitialsAvatar(name: name, size: 88)),
            const SizedBox(height: AppSpacing.xl),
            Text('Ad', style: text.overline),
            const SizedBox(height: AppSpacing.xxs),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Adın'),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }
}
