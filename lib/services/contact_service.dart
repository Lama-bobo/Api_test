import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ContactService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  // GET: جلب جهات الاتصال
  Future<List<Contact>> fetchContacts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((json) => Contact.fromJson(json)).toList();
      } else {
        throw Exception('فشل جلب جهات الاتصال (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  // POST: إضافة جهة اتصال
  Future<Contact> addContact(Contact contact) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Contact.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('فشل الإضافة (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('خطأ أثناء الإضافة: $e');
    }
  }

  // PUT: تعديل جهة اتصال
  Future<void> updateContact(int id, Contact contact) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(contact.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('فشل التحديث (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('خطأ أثناء التحديث: $e');
    }
  }

  // DELETE: حذف جهة اتصال
  Future<void> deleteContact(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل الحذف (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('خطأ أثناء الحذف: $e');
    }
  }
}