# CCExtractor_Beacon_Task

CCExtractor_Beacon_Task is a flutter based app for sharing live location with users for selected period of time.

## Screenshots

<p align="center">
  <img alt="" src="https://user-images.githubusercontent.com/99688344/215712213-5ded86b7-8723-48ba-a248-d4b72ccab53b.png"> 
  <img alt="" src="https://user-images.githubusercontent.com/99688344/215712232-57722e99-3966-4f8e-b16d-d338a5016412.png"> 
  <img alt="" src="https://user-images.githubusercontent.com/99688344/215712237-aea65b14-d337-44b6-86ef-971c0685be7e.png">
  </p>

## Installation


#### Prerequisites:

* Android Studio, Visual Studio Code or another IDE that supports Flutter development
* Flutter SDK
* Android SDK
* Android tablet device or emulator
* Git

Documentation on how to set up Flutter SDK and its environment can be found [here](https://flutter.dev/docs/get-started/install). Make sure to have [Git](https://git-scm.com/) and [Flutter](https://flutter.dev) installed in your machine before proceeding.
    
#### Steps:
  
* Clone the repository via the following terminal command:
  
```bash
$ git clone https://github.com/SagittariusA11/CCExtractor_Beacon_Task
$ cd CCExtractor_Beacon_Task
```
  
* After you have successfully cloned the project, set up Google maps API Key as CCExtractor_Beacon_Task uses [Google maps Android API](https://developers.google.com/maps/documentation/android-sdk/overview) as the map service. To use Google maps you required an **API KEY**. To get this key you need to:

1. Have a Google Account
2. Create a Google Cloud Project
3. Open Google Cloud Console
4. Enable Maps Android SDK
5. Generate an API KEY

With the key in hands, the next step is placing the key inside the app. Go to *android/app/main* and edit the **AndroidManifest.xml**.

Replace the **PLACE_HERE_YOUR_API_KEY** with the key you just created.

```XML
<application
       android:usesCleartextTraffic="true"
        android:label="ccextractor_beacon_task"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
       <meta-data android:name="com.google.android.geo.API_KEY"
           android:value="PLACE_HERE_YOUR_API_KEY"
           />
```  

* You will also need to setup up Firebase project as CCExtractor_Beacon_Task uses Firebase for real time database. To setup firebase you need to:

1. Have a Google Account
2. Open Firebase Console
3. Create a Firebase Project

Go to [Firebase Console](https://console.firebase.google.com) and follow the instructions follow.

* To run the code, open a terminal and navigate to the project root directory. First you need to install the packages by running:
  
```bash
$ flutter pub get
```
  
* Now we check if our devices are connected and if all the environment is correct by the following terminal command:
  
```bash
$ flutter doctor
```

*  After this, we run our app by using the following command:

```bash
$ flutter run
```
   
* To build the APK, use the follwoing terminal command:
  
```bash
$ flutter build apk
```

### Or install app from [apk](https://drive.google.com/file/d/168-rrHRTMcFWqXnBUB6_AO7Z_EnGlLlp/view?usp=share_link)

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
