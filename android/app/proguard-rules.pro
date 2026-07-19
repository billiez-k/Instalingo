# Keep MainActivity — required by AndroidManifest
-keep class com.instalingo.app.MainActivity { *; }
# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
