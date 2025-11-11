# OkHttp and Retrofit keep rules
-dontwarn okhttp3.**
-dontwarn okio.**

# Optional TLS providers (ignore if missing)
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
# --- PayU & UI ---
-keep class com.payu.** { *; }
-dontwarn com.payu.**

# --- Google Pay India in-app API (present on device; keep to avoid R8 missing class) ---
-keep class com.google.android.apps.nbu.paisa.inapp.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.**

# --- Google Credentials API (used by PayU for phone/email hints) ---
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-dontwarn com.google.android.gms.auth.api.credentials.**

# (usual Kotlin/AndroidX reflection safety)
-keep class kotlin.** { *; }
-keep class androidx.lifecycle.** { *; }
-dontwarn kotlin.**
-dontwarn androidx.**
