# flutter_chore
<p align="center">
  <a href="https://opensource.org/licenses/Apache-2.0"><img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-blue.svg"/></a>
  <p align="center">
  A flutter package for invoking a certain block of code only a fixed amount of times.
  </p>

## 1. Installation

1.1.1 Add flutter_chore to your pubspec.yaml file:
```yaml
    dependencies:
        flutter_chore:
            git:
              url: https://github.com/mustafadakhel/Flutter-Chore
```
1.1.2 Run flutter packages get to install the package.


## 2. Usage

### 2.1 Initialize the package
2.1.1 Import Flutter Chore with:
```dart
    import 'package:flutter_chore/flutter_chore.dart';
```
2.1.2 Initialize the package:
```dart
    await Chore.init();
```

### 2.2 Use the package
2.2.1 Using the Chore.newChore method:
```dart
    Chore.newChore(
          "chore_mark",
          (int time) {
            // do something only 4 times
          },
          times: 4,
        ).run();
```
2.2.2 Using the Chore.builder method:
```dart
    Chore.builder()
         .invoke((int time) {
            // do something only 4 times
         })
         .times(4)
         .mark("mark")
         .run();
```
other methods:
```dart
    Chore.builder()
         .invoke((int time) {
            // do something only 1 time
         })
         .once()
         .mark("chore_mark")
         .run();

    Chore.builder()
         .invoke((int time) {
            // do something only 2 times
         })
         .twice()
         .mark("chore_mark")
         .run();

    Chore.builder()
        .invoke((int time) {
            // do something only 3 times
         })
        .thrice()
        .mark("chore_mark")
        .run();
```
2.2.3 Using the once, twice, and thrice methods:
```dart
    Chore.once("chore_mark", () {
          // do something only 1 time
        }).run();

    Chore.twice("chore_mark", (int time) {
          // do something only 2 times
        }).run();

    Chore.thrice("chore_mark", (int time) {
          // do something only 3 times
        }).run();
```
2.2.4 Listen for events:
```dart
Chore.newChore(
      "chore_mark",
      (time) {
        // do something only 5 times
      },
      times: 5,
    ).run().onSecondTime(() {
      // do something before doing the chore for the second time
    }).beforeLastTime(() {
      // do something before doing the chore for the last time
    }).ifDone(() {
      // do something after the chore has been done as many times as set in the 'times' field
    });
```
2.2.3 Get a list of all registered chores:
```dart
    List<ChoreItem> chores = Chore.getAllChores();
```

# License
```xml
Copyright 2021 mustafadakhel (Mustafa Muhammed Dakhel)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```