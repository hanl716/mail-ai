import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Manage Account'),
            subtitle: const Text('user@example.com'),
            onTap: () {
              // TODO: Implement account management
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Mailboxes'),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Gmail'),
            subtitle: const Text('your_email@gmail.com'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement mailbox editing
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Mailbox'),
            onTap: () {
              // TODO: Implement add mailbox flow
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'AI Settings'),
          SwitchListTile(
            title: const Text('Enable AI Features'),
            value: true,
            onChanged: (bool value) {
              // TODO: Implement AI feature toggle
            },
            secondary: const Icon(Icons.auto_awesome),
          ),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('Manage AI Keys'),
            onTap: () {
              // TODO: Implement AI key management
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Security'),
          SwitchListTile(
            title: const Text('Enable Fingerprint Lock'),
            value: false,
            onChanged: (bool value) {
              // TODO: Implement fingerprint lock
            },
            secondary: const Icon(Icons.fingerprint),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
