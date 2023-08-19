import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendFCMMessage(String token, String title, String body) async {
  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA5V7W__o:APA91bHpN-LvBE8JoWim7umo8wXH7TmjchJKCCxA7Pa_fFpOgrR2N6m-4MfFCZzgZTvClYYmVfpznIyLW44ZkUtSKZkAwefW7UWlT_JI_aX1AbaB0XmqzlySYVkWaEYpmppejMQb8jvf'
  };

  final message = {
    'to': token,
    'notification': {
      'title': title,
      'body': body,
    },
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('Mesaj başarıyla gönderildi.');
  } else {
    print('Mesaj gönderimi başarısız oldu. Hata kodu: ${response.statusCode}');
  }
}
