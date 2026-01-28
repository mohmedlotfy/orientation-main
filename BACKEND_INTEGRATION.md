# Backend Integration Guide

## ✅ الكود جاهز للربط بالباك اند!

### الخطوات المطلوبة للربط:

#### 1. تغيير وضع التطوير (Dev Mode)
في ملف `orientation/lib/services/api/auth_api.dart`:
```dart
// غيّر من:
static const bool _devMode = true;

// إلى:
static const bool _devMode = false;
```

#### 2. تحديث Base URL
في ملف `orientation/lib/services/dio_client.dart`:
```dart
// غيّر الـ URL حسب بيئتك:
static const String defaultBaseUrl = 'https://your-backend-url.com';

// أو استخدم:
// - Android Emulator: http://10.0.2.2:3000
// - iOS Simulator: http://localhost:3000
// - Physical Device: http://YOUR_COMPUTER_IP:3000
```

أو يمكنك تغيير الـ URL ديناميكياً:
```dart
final authController = AuthController();
authController.setApiBaseUrl('https://your-backend-url.com');
```

### ✅ المميزات الجاهزة:

1. **Authentication Flow**:
   - ✅ Login (`POST /auth/login`)
   - ✅ Register (`POST /auth/register`)
   - ✅ Logout
   - ✅ Token Management (Auto-saved in SharedPreferences)
   - ✅ Auto Token Injection (في كل request)

2. **Token Handling**:
   - ✅ Token يتم حفظه تلقائياً بعد Login/Register
   - ✅ Token يتم إضافته تلقائياً في Header: `Authorization: Bearer {token}`
   - ✅ Token يتم التحقق منه في `isLoggedIn()`

3. **Error Handling**:
   - ✅ معالجة أخطاء الشبكة
   - ✅ معالجة أخطاء الـ API (401, 400, 409, etc.)
   - ✅ رسائل خطأ واضحة للمستخدم

4. **API Endpoints الجاهزة**:
   - `/auth/login` - تسجيل الدخول
   - `/auth/register` - إنشاء حساب
   - `/auth/forgot-password` - نسيان كلمة المرور
   - `/auth/verify-otp` - التحقق من OTP
   - `/auth/reset-password` - إعادة تعيين كلمة المرور
   - `/auth/profile` - الحصول على الملف الشخصي
   - `/auth/profile` (PUT) - تحديث الملف الشخصي
   - `/auth/password` (PUT) - تحديث كلمة المرور

### 📋 متطلبات الـ Backend Response:

#### Login Response:
```json
{
  "user": {
    "id": "string",
    "username": "string",
    "email": "string",
    "role": "string"
  },
  "token": "string"
}
```

#### Register Response:
```json
{
  "user": {
    "id": "string",
    "username": "string",
    "email": "string",
    "phoneNumber": "string",
    "role": "string"
  },
  "token": "string"
}
```

#### Error Response:
```json
{
  "message": "Error message here"
}
```

### 🔒 Security:

- ✅ Token يتم إرساله في Header: `Authorization: Bearer {token}`
- ✅ Token يتم حفظه بشكل آمن في SharedPreferences
- ✅ Token يتم التحقق منه قبل كل request محمي

### 📝 ملاحظات:

1. تأكد من أن الـ Backend يدعم CORS
2. تأكد من أن الـ Backend يرسل Token في Response بعد Login/Register
3. تأكد من أن الـ Backend يتحقق من Token في Header `Authorization`

### 🚀 جاهز للاستخدام!

بعد تغيير `_devMode = false` وتحديث `baseUrl`، الكود جاهز للعمل مع الباك اند مباشرة!

