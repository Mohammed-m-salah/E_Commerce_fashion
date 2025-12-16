# إعداد Redirect URLs في Supabase - دليل بالعربية

## الخطوات المطلوبة:

### 1. افتح لوحة تحكم Supabase

انتقل إلى: https://app.supabase.com

### 2. اختر مشروعك

اختر المشروع: **blpirgrhytbjmapmjfnq.supabase.co**

### 3. انتقل إلى إعدادات Authentication

- اذهب إلى **Authentication** (المصادقة)
- ثم اضغط على **URL Configuration** (تكوين الروابط)

### 4. أضف Redirect URLs التالية:

في قسم **Redirect URLs**، أضف الروابط التالية:

```
io.supabase.ecommerce://reset-password
io.supabase.ecommerce://login-callback
io.supabase.ecommerce://signup-callback
```

### 5. احفظ التغييرات

اضغط على زر **Save** (حفظ)

---

## شرح الروابط:

### `io.supabase.ecommerce://reset-password`
- يُستخدم عند طلب إعادة تعيين كلمة المرور
- عندما يضغط المستخدم على الرابط في البريد الإلكتروني، سيفتح التطبيق

### `io.supabase.ecommerce://login-callback`
- يُستخدم بعد تسجيل الدخول الناجح
- للتحقق من البريد الإلكتروني

### `io.supabase.ecommerce://signup-callback`
- يُستخدم بعد التسجيل
- للتحقق من البريد الإلكتروني

---

## إعدادات إضافية مهمة:

### 1. Site URL (رابط الموقع)
في نفس الصفحة، اضبط **Site URL** على:
```
io.supabase.ecommerce://
```

### 2. تفعيل Email Provider
- اذهب إلى **Authentication** → **Providers**
- تأكد من تفعيل **Email**

### 3. قوالب البريد الإلكتروني
- اذهب إلى **Authentication** → **Email Templates**
- يمكنك تخصيص رسالة إعادة تعيين كلمة المرور

---

## التأكد من الإعدادات:

بعد إضافة الروابط، يجب أن تبدو القائمة هكذا:

✅ `io.supabase.ecommerce://reset-password`
✅ `io.supabase.ecommerce://login-callback`
✅ `io.supabase.ecommerce://signup-callback`

---

## اختبار Reset Password:

1. شغّل التطبيق
2. اذهب إلى شاشة "Forget Password"
3. أدخل بريدك الإلكتروني
4. اضغط "Send reset link"
5. افتح البريد الإلكتروني
6. اضغط على الرابط - سيفتح التطبيق مباشرة!

---

## ملاحظات مهمة:

⚠️ **يجب** إضافة جميع الروابط بالضبط كما هي مكتوبة
⚠️ لا تنسى الضغط على **Save** بعد الإضافة
⚠️ قد تحتاج بضع دقائق حتى تصبح التغييرات فعالة

---

## في حالة المشاكل:

إذا لم يعمل الرابط:
1. تأكد من كتابة Redirect URLs بشكل صحيح
2. تأكد من حفظ التغييرات
3. أعد تشغيل التطبيق
4. جرب مرة أخرى

---

✅ **تم الإعداد بنجاح!**

الآن يمكنك اختبار جميع وظائف Authentication:
- تسجيل حساب جديد ✓
- تسجيل الدخول ✓
- إعادة تعيين كلمة المرور ✓
