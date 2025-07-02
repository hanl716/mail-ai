import 'package:enough_mail/enough_mail.dart';
import 'database_helper.dart'; // Import the database helper

class MailService {
  final String imapServerHost;
  final String username;
  final String password;
  final int mailboxId; // To associate emails with a mailbox config

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  MailService({
    required this.imapServerHost,
    required this.username,
    required this.password,
    required this.mailboxId,
  });

  Future<List<MimeMessage>> fetchAndStoreEmails() async {
    final client = ImapClient(isLogEnabled: true);
    try {
      await client.connectToServer(imapServerHost, 993, isSecure: true);
      await client.login(username, password);
      await client.selectInbox();

      // Fetch the 10 most recent messages
      final fetchResult = await client.fetchRecentMessages(messageCount: 10);
      final emails = fetchResult.messages;

      // Store each email in the database
      for (final email in emails) {
        await _dbHelper.insertEmail(email, mailboxId);
      }

      return emails;
    } finally {
      await client.logout();
    }
  }
}
