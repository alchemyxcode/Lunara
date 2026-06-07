// LunaFlow - Encryption Service
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final EncryptionService instance = EncryptionService._internal();
  EncryptionService._internal();

  // Derive a 32-byte AES key from the user's password using SHA-256
  Key _deriveKey(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return Key(Uint8List.fromList(digest.bytes));
  }

  // Encrypt a string, returns base64-encoded "iv:ciphertext"
  String encrypt(String plaintext, String password) {
    final key = _deriveKey(password);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    // Store IV alongside ciphertext so we can decrypt later
    final combined = '${iv.base64}:${encrypted.base64}';
    return combined;
  }

  // Decrypt a "iv:ciphertext" base64 string
  String decrypt(String encryptedData, String password) {
    final key = _deriveKey(password);
    final parts = encryptedData.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted data format');
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
