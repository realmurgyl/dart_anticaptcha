The solution of the captcha is carried out at the expense of the resource workers - https://anti-captcha.com
To solve the captcha, you need to register on the resource and top up your balance.
Documentation - https://anti-captcha.com/apidoc

## Installation

```sh
dart pub add dart_anticaptcha
```

or

```sh
dependencies:
  dart_anticaptcha: ^1.1.4
```


## Usage

### imageToText

The easiest way to use this library is to use the `memoryImageToBase64()` function. This function is intended for converting an image to base64 and further uploading it to the resource to solve the captcha.
Also, to get base64 images from the site, you need to use the `networkImageToBase64()` function.

```dart
import 'package:dart_anticaptcha/dart_anticaptcha.dart';

void main() async {
  String key = 'YOUR_TOKEN';
  String memoryImage = 'captcha.jpeg';
  String networkImage = 'https://api.vk.com/captcha.php?sid=1';

  AntiCaptcha anticaptcha = AntiCaptcha(key);

  String? imgbase64 = await anticaptcha
      .networkImageToBase64(networkImage); //memoryImage or networkImage

  Map headers = {
    "clientKey": key,
    "task": {"type": "ImageToTextTask", "body": imgbase64}
  };
  dynamic result = await anticaptcha.imageToText(headers);
  print(result['solution']['text']);
}

```




### recaptchaV2TaskProxyless

recaptchaV2Demo - Landing page address. It can be located anywhere on the site, including in a section closed to subscribers. Our employees do not visit the site, but instead emulate a visit to the page.

websiteKey - Recaptcha key. More details - https://anti-captcha.com/apidoc/articles/how-to-find-the-sitekey

```dart
import 'package:dart_anticaptcha/dart_anticaptcha.dart';

void main() async {
  String recaptchaV2Demo = 'https://patrickhlauke.github.io/recaptcha/';
  String websiteKey = 'YOUR_WEBSITE_KEY';
  String key = 'YOUR_TOKEN';

  AntiCaptcha antiCaptcha = AntiCaptcha(key);
  Map header = {
    "clientKey": key,
    "task": {
      "type": "RecaptchaV2TaskProxyless",
      "websiteURL": recaptchaV2Demo,
      "websiteKey": websiteKey
    }
  };
  Map response = await antiCaptcha.recaptchaV2TaskProxyless(header);
  print(response['solution']['gRecaptchaResponse']);
}
```