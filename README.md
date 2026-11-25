# Redro دليل

دليل عربي للأعمال والخدمات المحلية، يبدأ بحلب. يعتمد على Cloudflare Pages وPages Functions وD1، مع مراجعة إدارية يدوية لطلبات الإضافة وحماية النماذج بواسطة Turnstile.

## الحالة الحالية

- مستودع GitHub مربوط بمشروع Cloudflare Pages باسم `redro-daleel` على فرع `main`.
- آخر نشر معروف في Cloudflare نجح، ويستخدم مجلد `public` مع Pages Functions.
- قاعدة D1 باسم `redro-daleel` مربوطة عبر binding اسمه `DB`.
- ترحيلات D1 من `0001` إلى `0012` موجودة، وجداول جلسات المدير وحسابات المالكين ونقل الملكية والمدفوعات ومحاولات دخول المالكين موجودة في قاعدة D1.
- R2 غير مفعّل حالياً؛ لذلك رفع الصور غير متاح، لكنه ليس شرطاً لتشغيل الدليل والبحث والبيانات الأساسية.
- إعدادات المدير موثقة أدناه؛ يجب اختبار تسجيل الدخول فعلياً بعد كل نشر.
- لا تعتبر حماية Turnstile فعالة حتى يتم ضبط السر الصحيح واختبار إرسال نموذج فعلي.

## الوظائف

- واجهة عربية RTL متجاوبة مع البحث والتصنيفات والمدينة والمنطقة.
- صفحات تفاصيل للمشاريع المنشورة.
- نموذج تقديم طلب مشروع محمي بواسطة Turnstile.
- تُحفظ طلبات الإضافة بحالة `needs_review`، ولا تُنشر تلقائياً؛ يراجعها المدير ويقرر قبولها أو رفضها من لوحة الإدارة. يتطلب استقبال الطلبات ضبط Turnstile والتحقق منه فعلياً.
- لوحة إدارة محمية بجلسة Cookie من نوع HttpOnly وSecure، مع تخزين تجزئة الجلسة في D1، وتحديد محاولات الدخول، وفحص Origin للطلبات المعدّلة.
- إحصائيات وسجل نشاط وتنبيهات إدارية محفوظة في D1.
- لوحة صاحب المشروع الحالية لتعديل بيانات مشروعه باستخدام رمز وصول قديم؛ نظام حسابات المالكين الجديد وجلساته ونقل الملكية لم يكتمل بعد. توجد بنية لتحديد محاولات دخول المالكين، لكن واجهات تسجيل الدخول وربط الحسابات لم تُفعّل بعد.
- مسارات الصور موجودة، لكنها تتطلب R2 binding باسم `IMAGES`؛ من دونه تعيد عمليات الرفع خطأ `image_storage_unavailable`.

## واجهات عامة

- `GET /api/health`
- `GET /api/cities`
- `GET /api/regions?city=aleppo`
- `GET /api/categories`
- `GET /api/businesses?page=1&limit=20&q=&city=&category=&region=`
- `GET /api/businesses/:slug`
- `POST /api/submissions`
- `POST /api/reports`

## واجهات الإدارة

جميع المسارات تحت `/api/admin/*` تتطلب جلسة مدير صالحة باسم `redro_admin_session`. يسجّل المدير الدخول من `/admin.html` باستخدام `ADMIN_PHONE` و`ADMIN_PASSWORD_HASH`، وتُخزّن الجلسة في D1 مع تاريخ انتهاء، وتُلغى عند تسجيل الخروج. ملف Cookie صالح في المتصفح لمدة تصل إلى عشر سنوات.

- `GET /api/admin/dashboard`
- `GET /api/admin/notifications`
- `PATCH /api/admin/notifications/:id`
- `GET/POST /api/admin/categories` و`PATCH /api/admin/categories/:id`
- `GET/POST /api/admin/cities` و`PATCH /api/admin/cities/:id`
- `GET/POST /api/admin/regions` و`PATCH /api/admin/regions/:id`
- `GET /api/admin/submissions` و`PATCH /api/admin/submissions/:id`
- `GET /api/admin/reports` و`PATCH /api/admin/reports/:id`
- إدارة المشاريع وسجل التعديلات ضمن `/api/admin/*`.

## الإعداد

1. اربط مستودع `mhamedshasho/redro-daleel` بمشروع Cloudflare Pages.
2. استخدم فرع `main` ومجلد إخراج `public` مع تفعيل Pages Functions.
3. اربط قاعدة D1 باسم binding `DB` وقاعدة `redro-daleel`.
4. تأكد من تطبيق ترحيلات D1 بالترتيب من `migrations/0001` إلى `migrations/0012`.
5. أضف `ADMIN_PHONE` و`ADMIN_PASSWORD_HASH` إلى إعدادات Pages Production.
6. أضف `TURNSTILE_SECRET` بعد إنشاء عنصر Turnstile وضبط اسم المضيف والإجراء المتوقع.
7. اختبر تسجيل دخول المدير والجلسة وتسجيل الخروج، ثم اختبر تقديم طلب حقيقي.
8. لا تضع الأسرار في ملفات المستودع أو ترسلها في المحادثات.
9. افتح `/api/health`، ثم اختبر لوحة الإدارة ونموذج الإرسال فعلياً.

صفحة `/admin-setup.html` تحتوي خطوات الإعداد. لوحة الإدارة متاحة عبر `/admin.html`.

## تخزين الصور الاختياري

عند توفر R2 مستقبلاً، أنشئ bucket واربطه في Pages باسم binding `IMAGES`. لا تضف binding وهمياً ولا تعتبر الصور عاملة قبل اختبار الرفع والاسترجاع والحذف.

## بنية الملفات

- `public/`: صفحات الموقع وملفات CSS وJavaScript.
- `functions/api/[[path]].js`: واجهات Cloudflare Pages Functions.
- `migrations/`: ترحيلات قاعدة D1.
- `wrangler.toml`: إعدادات المشروع وربط D1.
