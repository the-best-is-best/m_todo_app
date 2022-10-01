# m_todo_app

* Todo App.
## video

[<img src="github_assets/video_thum.jpg" height:300>](https://youtu.be/9nxOKvtX4V4
 "Now in Android: 25 or above")


## images
<p align="center">
<img src="github_assets/1.jpg" width="49%"></img>
<img src="github_assets/2.jpg" width="49%"></img>
<img src="github_assets/3.jpg" width="49%"/>
<img src="github_assets/4.jpg" width="49%"/>
<img src="github_assets/7.jpg" width="49%"/>
<img src="github_assets/15.jpg" width="49%"/>
<img src="github_assets/8.jpg" width="49%"/>
<img src="github_assets/16.jpg" width="49%"/>
<img src="github_assets/12.jpg" width="49%"/>
<img src="github_assets/5.jpg" width="49%"/>
<img src="github_assets/6.jpg" width="49%"/>
<img src="github_assets/10.jpg" width="49%"/>
<img src="github_assets/9.jpg" width="49%"/>
</p>


**Step 1:**

Download or clone this repo by using the link below:

```
git clone https://github.com/the-best-is-best/ms_store.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```


## MS Store Features:

* app_popup_menu
* Home
* Routing
* Sqflite
* Bloc
* flutter bloc
* Code Generation
* Dependency Injection
* svg
* screen util
* date picker timeline
* awesome notifications
* deviceLocale
* color picker
* localizations
* freezed
* google ads
* get storage
* quick actions

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
```

Here is the folder structure we have been using in this project

```
lib/app/
       |- constants/
       |- resources/
       |- utils/
       |- bindings
       |- refs
       |- app
       |- di
       |- extensions
       |- components
   |- data/ data layer
   |- domain/ domain layer
   |- presentation/ presentation layer
```