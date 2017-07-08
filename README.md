# dart_hub

A GitHub client written in flutter.

## Building

In order to build this project, you'll need to add a `keys.dart` file to the `lib/` directory of this project.
This file contains the oauth client id and client secret necessary to communicate with the GitHub apis.
Inside the file you'll need to define two constants:
```dart
const String CLIENT_ID = 'your oauth client id';
const String CLIENT_SECRET = 'your oauth client secret';
```
You can create an oauth api project [here](https://github.com/settings/applications/new).


## Screenshots

![Activity feed](screenshots/feedview.png) ![Repositories](screenshots/repos.png) ![Followers](screenshots/followers.png) ![Following](screenshots/following.png)


## TODO

- [x] Activity feed showing recent activity
- [x] Notifications ui which shows unread notifications
- [x] Profile ui that shows current logged in user
- [x] Implement pagination on list screens
- [x] Implement follower listing view
- [x] Implement following listing view
- [x] Move notifications in between search and profile
- [x] Implement repo listing view
- [x] Implement showing user activity on profile
- [ ] Activity items clickable
- [ ] Notification items clickable
- [ ] Support comments in activity feed
- [ ] Repository screen
- [ ] Finish up supporting different parameters for notifications
- [ ] Implement search view
- [ ] File viewer
