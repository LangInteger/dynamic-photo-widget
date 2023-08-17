# Dynamic Photo Widget

This is a project to build your own dynamic photo widget app for iOS 14+. It will randomly display your own photos hosted on a github repository.

## 0 PreRequisite

You must have a valid Apple Developer acount to build this app to your iPhone.

## 1 Build Your Own APP

### 1.1 Setup Github Repository for Photos

Clone the [demo_photos_gallary](https://github.com/LangInteger/demo_photos_gallary) repository. Delete the `.git` folder, reInit it and push to your own github account. Put your photos in the `photos` folder, name of photos should match this pattern:

```text
Pattern: yyyy-MM-dd_title_seq.type
eg: 2023-08-17_Sunrise_1.jpg
```

Use the pyhton script to standarize photos for bettter display in Widget:

```shell
pip3 install pillow # run once to install dependencies
python3 ./tool.py
```

The auto generated photoes will be placed in the `min_photos` folder. The auto generated meta info wil be stored in the `data.json` file.

Push all the changes to github, and you get two things here:

- 1 a link to your `data.json` file like below, remember to replace your own github username

  ```text
  https://raw.githubusercontent.com/langinteger/demo_photos_gallary/main/data.json
  ```

- 2 links to your auto generated photo files like below, remember to replace your own github username

  ```text
  https://raw.githubusercontent.com/langinteger/demo_photos_gallary/main/min_photos/2021-10-16_TangLang Mountain_1.jpg
  ```

### 1.2 Build iOS APP of Yuor Own

Clone this repository, open `WidgetForLang.xcodeproj` in XCode and:

- replace value of `metaUrlString` in `./LangWidget/LangWidget.swift` to link to your own `data.json` file like:

  ```text
    https://raw.githubusercontent.com/xxx/demo_photos_gallary/main/data.json
  ```

- replace value of `pictureBaseUrl` in `./LangWidget/LangWidget.swift` to link to your own photo link prefix like:

  ```text
  https://raw.githubusercontent.com/xxx/blog_photos/main/min_photos/
  ```

With your Apple Developer account logined, and unique bundle identifier properly set for both `WidgetForLang` and `LangWidgetExtension` target, now you can build the app to your iPhone.

## 2 Known Issues

### 2.1 iOS Widget Refresh Budget

In `./LangWidget/LangWidget.swift`, the code

```swift
let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
```

aims to refresh the photo displayed on widget every one minute. It may work in this way when you build app to your iPhone with it plugined to computer. But in daily use, there is limitation from iOS that set a daily refresh budget for every widget. The typically daily budget is 45 - 70, so you should not expect refresh happens every one minute. You may adjust the code to match your own requirement.

### 2.2 Privacy

As the repository storing photos created in step 1.1 is designed to be public, please do not upload photoes those you want to keep them private, or others can get access to the photos just as you.

## 3 TODO

- [ ] make the `metaUrlString` and `pictureBaseUrl` configurable
- [ ] display cached picture when access to network failed
