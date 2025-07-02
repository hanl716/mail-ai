// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:enough_mail/enough_mail.dart';
// import 'mail_service.dart';
// import 'database_helper.dart';
// import 'ai_service.dart';
// import 'settings_screen.dart'; // Import the new settings screen
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DatabaseHelper.instance.database;
//
//   final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO);
//
//   await client.connectUser(
//     User(id: 'tutorial-flutter'),
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiGRh_1JbfI-GkTaEt1CSoHEMSo5vGJZk2M',
//   );
//
//   runApp(MyApp(client: client));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key, required this.client});
//   final StreamChatClient client;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mail-AI',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,
//       builder: (context, child) => StreamChat(client: client, child: child!),
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<MimeMessage> _emails = [];
//   MimeMessage? _selectedEmail;
//   bool _isLoading = false;
//   String? _error;
//
//   final _mailService = MailService(
//     imapServerHost: 'your_imap_server.com',
//     username: 'your_email@example.com',
//     password: 'your_password',
//     mailboxId: 1,
//   );
//
//   Future<void> _fetchEmails() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//       _selectedEmail = null;
//     });
//     try {
//       final emails = await _mailService.fetchAndStoreEmails();
//       setState(() {
//         _emails = emails;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _onEmailSelected(MimeMessage email) {
//     setState(() {
//       _selectedEmail = email;
//     });
//   }
//
//   void _navigateToSettings() {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => const SettingsScreen(),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.appTitle),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchEmails,
//             tooltip: 'Fetch Emails',
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: _navigateToSettings,
//             tooltip: 'Settings',
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           Container(
//             width: 300,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               border: Border(right: BorderSide(color: Colors.grey.shade300)),
//             ),
//             child: _buildEmailList(),
//           ),
//           Expanded(
//             child: _selectedEmail != null
//                 ? EmailDetailView(email: _selectedEmail!)
//                 : const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.mail_outline, size: 64, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text('Select an email to view its content.'),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmailList() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Fetching emails...'),
//           ],
//         ),
//       );
//     }
//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, size: 64, color: Colors.red),
//               const SizedBox(height: 16),
//               Text(
//                 'Failed to fetch emails. Please check your connection and credentials.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.red.shade800),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _error!,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     if (_emails.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             const Text('Your inbox is empty.'),
//             const SizedBox(height: 8),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.refresh),
//               label: const Text('Fetch Now'),
//               onPressed: _fetchEmails,
//             )
//           ],
//         ),
//       );
//     }
//     return ListView.builder(
//       itemCount: _emails.length,
//       itemBuilder: (context, index) {
//         final email = _emails[index];
//         final isSelected = _selectedEmail == email;
//         return ListTile(
//           title: Text(email.decodeSubject() ?? 'No Subject', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
//           subtitle: Text(email.from?.first.personalName ?? email.from?.first.email ?? 'Unknown Sender', maxLines: 1, overflow: TextOverflow.ellipsis),
//           onTap: () => _onEmailSelected(email),
//           tileColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
//         );
//       },
//     );
//   }
// }
//
// class EmailDetailView extends StatefulWidget {
//   const EmailDetailView({super.key, required this.email});
//   final MimeMessage email;
//
//   @override
//   State<EmailDetailView> createState() => _EmailDetailViewState();
// }
//
// class _EmailDetailViewState extends State<EmailDetailView> {
//   final AiService _aiService = AiService();
//   String? _summary;
//   bool _isSummarizing = false;
//
//   @override
//   void didUpdateWidget(covariant EmailDetailView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.email != oldWidget.email) {
//       setState(() {
//         _summary = null;
//         _isSummarizing = false;
//       });
//     }
//   }
//
//   Future<void> _summarizeEmail() async {
//     setState(() {
//       _isSummarizing = true;
//       _summary = null;
//     });
//     final body = widget.email.decodeTextPlainPart() ?? '';
//     if (body.isNotEmpty) {
//       final summary = await _aiService.summarizeEmail(body);
//       if (mounted) {
//         setState(() {
//           _summary = summary;
//           _isSummarizing = false;
//         });
//       }
//     } else {
//       setState(() {
//         _summary = 'Could not find text content to summarize.';
//         _isSummarizing = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final subject = widget.email.decodeSubject() ?? 'No Subject';
//     final from = widget.email.from?.join((e) => e.toString()) ?? 'Unknown Sender';
//     final date = widget.email.decodeDate();
//     final body = widget.email.decodeTextPlainPart() ?? 'No content available.';
//
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(subject, style: Theme.of(context).textTheme.headlineSmall),
//             const SizedBox(height: 8),
//             Text('From: $from', style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 4),
//             Text('Date: ${date?.toLocal().toString() ?? 'Unknown Date'}', style: Theme.of(context).textTheme.bodySmall),
//             const Divider(height: 24),
//             _buildAiSection(),
//             const Divider(height: 24),
//             Text(body),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAiSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ElevatedButton.icon(
//           icon: const Icon(Icons.auto_awesome),
//           label: const Text('Generate Summary'),
//           onPressed: _isSummarizing ? null : _summarizeEmail,
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white, backgroundColor: Colors.blue.shade600,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//         const SizedBox(height: 16),
//         if (_isSummarizing)
//           const Center(child: CircularProgressIndicator())
//         else if (_summary != null)
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.blue.shade200),
//             ),
//             child: Text(_summary!, style: TextStyle(color: Colors.blue.shade900, fontStyle: FontStyle.italic)),
//           ),
//       ],
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:test/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int _addResult;

  @override
  void initState() {
    super.initState();
    _addResult = RustLib.instance.api.crateApiAdd(a: 10, b: 20);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Rust Bridge Demo')),
        body: Center(
          child: Text(
            '10 + 20 = $_addResult',
          ),
        ),
      ),
    );
  }
}
