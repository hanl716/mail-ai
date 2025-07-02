import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:enough_mail/enough_mail.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mail_ai_encrypted.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // IMPORTANT: This is a hardcoded password for demonstration purposes.
    // In a real app, this should be securely managed, e.g., using flutter_secure_storage.
    const password = 'your-super-secret-password';

    // Open the database with a password for encryption.
    return await openDatabase(
      path,
      password: password,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    // UserSettings Table
    await db.execute('''
    CREATE TABLE UserSettings (
      user_id INTEGER PRIMARY KEY,
      email TEXT UNIQUE,
      totp_secret TEXT,
      fingerprint_enabled BOOLEAN,
      encryption_key_hash TEXT,
      ui_config TEXT
    )
    ''');

    // MailboxConfig Table
    await db.execute('''
    CREATE TABLE MailboxConfig (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      imap_host TEXT,
      smtp_host TEXT,
      email_address TEXT,
      access_token TEXT,
      last_sync_time INTEGER,
      FOREIGN KEY (user_id) REFERENCES UserSettings (user_id)
    )
    ''');

    // EmailIndex Table from your PDF
    await db.execute('''
    CREATE TABLE EmailIndex (
      id $idType,
      mailbox_id INTEGER,
      email_uid TEXT,
      subject $textType,
      from_name TEXT,
      from_classification TEXT,
      classification_tag TEXT,
      importance TEXT,
      favorite $boolType,
      synced_at $integerType,
      FOREIGN KEY (mailbox_id) REFERENCES MailboxConfig (id)
    )
    ''');

    // EmailBody Table
    await db.execute('''
    CREATE TABLE EmailBody (
      id $idType,
      email_index_id INTEGER,
      body_plaintext TEXT,
      body_html TEXT,
      FOREIGN KEY (email_index_id) REFERENCES EmailIndex (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<void> insertEmail(MimeMessage message, int mailboxId) async {
    final db = await instance.database;
    final indexId = await db.insert('EmailIndex', {
      'mailbox_id': mailboxId,
      'email_uid': message.uid,
      'subject': message.decodeSubject() ?? 'No Subject',
      'from_name':
          message.from?.first.personalName ?? message.from?.first.email,
      'importance': 'normal',
      'favorite': false,
      'synced_at': DateTime.now().millisecondsSinceEpoch,
    });
    await db.insert('EmailBody', {
      'email_index_id': indexId,
      'body_plaintext': message.decodeTextPlainPart(),
      'body_html': message.decodeTextHtmlPart(),
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
