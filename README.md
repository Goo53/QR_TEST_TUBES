# QR_Test_Tubes
Goal: Help to manage test-tubes in laboratory with printable QR codes connected to editable database.

## Inspiration

Dynamic Theme: https://pub.dev/packages/dynamic_theme
Scanner, Creator: https://github.com/alfianlosari/flutter_qr_code_scanner_generator_sharing

# Other

- Backend is work of my coworker from university and due to it's specification http request are based on response code '200' and phrase 'success';
- Id is now added on server side;
- Sharing 'login' through pages of app with static class in AppData;
- Colors of AlertDialogs are final and implemented in each in favor to overcome problem on android devices (in light theme text is invincible due to it's white colour [the same as background]);

# Problems:

- 'Listing all probes' script doesn't work properly and on front I might have problems with lists and maps from json response (previous model of static class may not work for many objects);
