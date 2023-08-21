# mobile

The Flutter Devs ke mobile application

## Getting Started

This project is a starting point for the flutter devs ke mobile app
Since the application is made using flutter, you will first have to install and set up [Flutter](https://docs.flutter.dev/get-started/install)

Clone this repository by typing the following command on the terminal/command prompt

```
    git clone https://github.com/KenyaFlutterDev/flutter_ke.git
```

Go to the mobile folder:

```
    cd mobile
```

Get the dependencies

```
    flutter pub get
```

Use build_runner to generate required files
```
    dart run build_runner watch
```

Finally run the project and make changes as you wish
```
    flutter run
```

## Documentation  

### Routing package - gorouter  

[gorouter](https://pub.dev/) on pub.dev.  
Gorouter is a routing package for flutter that uses the Router API providing convinient, url-based API for navigating between different screens.  
We chose gorouter for our project because you can define url patterns, handle url navigation, deep linking and its rich set of features.  

Features and pros of using gorouter  
- Named routes  
- Parsing path and query params with a templet syntax, eg "user/:id"  
- Subroutes - displaying multiple screens for a destination  
- Supports redirection  
- Support for multiple navigators via [ShellRoute](https://pub.dev/documentation/go_router/latest/go_router/ShellRoute-class.html)  
- Supports both Material and Cupertino apps  
- Type-safe routes  
- Custom transitions and animations  
- Elegant and declarative approach to routing  

Cons of using gorouter  
- There is a potential increase in the size of our application due to using gorouter package.  
- Learning curve, Our contributers that have been using the default inbuilt routing package will have to familiarize and learn how to use it.

