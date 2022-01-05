import 'dart:convert';
import 'dart:io' as Io;
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

String getTaskResultUrl = 'https://api.anti-captcha.com/getTaskResult';
String createTaskUrl = 'https://api.anti-captcha.com/createTask';

class AntiCaptcha {
  late String clientKey;
  AntiCaptcha(this.clientKey);

  //No proxy
  recaptchaV2TaskProxyless(Map settingsHeader) async {
    final event = await _apiRequest(createTaskUrl, settingsHeader);
    final response = json.decode('$event');

    Map headers = {"clientKey": clientKey, "taskId": response['taskId']};
    var res = await _apiRequest(getTaskResultUrl, headers);
    var result = await json.decode('$res');
    //print(result);
    return (await _returnResult(response));
  }

  imageToText(Map settingsHeader) async {
    final event = await _apiRequest(createTaskUrl, settingsHeader);
    final response = json.decode('$event');
    return (await _returnResult(response));
  }

  _returnResult(Map response) async {
    Map headers = {"clientKey": clientKey, "taskId": response["taskId"]};
    while (true) {
      var res = await _apiRequest(getTaskResultUrl, headers);
      var result = await json.decode('$res');
      if (result['status'] == 'processing') {
      } else {
        return result;
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<String?> memoryImageToBase64(String image) async {
    final bytes = Io.File(image).readAsBytesSync();
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<String?> _apiRequest(String url, Map jsonHeaders) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonHeaders)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
}
