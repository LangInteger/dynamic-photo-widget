# Dynamic Picture Widget

This is a project to build your own dynamic picture widget for iOS 14+. It will randomly display your own photos hosted on a github repository.

## 1 Build Yourn Own APP

### 1.1 Setup your github repository for photos

Clone the [demo_photos_gallary]() repository - which is also submodule for this project. Delete the `.git` repository and push it to your own github account. Put your photos in the `photos` folder, name of pictures must match this pattern:

```text
Pattern: yyyy-MM-dd_title_seq.type
eg: 2023-08-17_Sunrise_1.jpg
```

Use the pyhton script to standarize photos for bettter display in Widget:

```shell
pip3 install pillow # run once to install dependencies
python3 ./tool.py
```

The auto generated photoes will be placed in the `min_photos` folder. The auto generated meta info wil be the `data.json` file.

Push all the changes to github, and you get two things here:

- 1 a link to your `data.json` file like below, remember to replace your own github username

  ```text
  https://raw.githubusercontent.com/langinteger/demo_photos_gallary/main/data.json
  ```

- 2 links to your auto generated photo files like below, remember to replace your own github username

  ```text
  https://raw.githubusercontent.com/langinteger/demo_photos_gallary/main/min_photos/2021-10-16_TangLang Mountain_1.jpg
  ```

### 1.2 Build iOS APP of yuor own

Clone this repository and:

- replace value of `metaUrlString` in `./LangWidget/LangWidget.swift` to link to your own `data.json` file like:

  ```text
    https://raw.githubusercontent.com/xxx/demo_photos_gallary/main/data.json
  ```

- replace value of `pictureBaseUrl` in `./LangWidget/LangWidget.swift` to link to your own photo link prefix like:

  ```text
  https://raw.githubusercontent.com/xxx/blog_photos/main/min_photos/
  ```

## 2 Known Limitations

### 2.1 iOS Widget Refresh Budget
