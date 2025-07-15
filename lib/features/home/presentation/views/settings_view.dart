import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_chatting/features/auth/presentation/manager/auth/auth_cubit.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    currentPassController.dispose();
    newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Write the new name'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => loading = true);
                    await context
                        .read<AuthCubit>()
                        .updateName(context, nameController.text.trim())
                        .then((value) => nameController.clear());

                    setState(() => loading = false);
                  },
                  child: const Text(
                    'Update Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: currentPassController,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                ),
                TextField(
                  controller: newPassController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => loading = true);
                    await context
                        .read<AuthCubit>()
                        .updatePassword(
                          context,
                          currentPassController.text.trim(),
                          newPassController.text.trim(),
                        )
                        .then((value) {
                      currentPassController.clear();
                      newPassController.clear();
                    });
                    setState(() => loading = false);
                  },
                  child: const Text(
                    'Update Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    setState(() => loading = true);
                    await context.read<AuthCubit>().deleteAccount(context);
                    setState(() => loading = false);
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () async {
                    await context.read<AuthCubit>().logout(context);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}
