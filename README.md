# Redro دليل

دليل عربي للأعمال والخدمات المحلية، يبدأ بحلب. يعتمد على Cloudflare Pages وPages Functions وD1، مع مراجعة إدارية يدوية لطلبات الإضافة وحماية النماذج بواسطة Turnstile.

## الحالة الحالية

- مستودع GitHub مربوط بمشروع Cloudflare Pages باسم `redro-daleel` على فرع `main`.
- آخر نشر معروف في Cloudflare نجح، ويستخدم مجلد `public` مع Pages Functions.
- قاعدة D1 باسم `redro-daleel` مربوطة عبر binding اسمه `DB`.
- ترحيلات D1 من `0001` إلى `0005` مطبقة.
- R2 غير مفعّل حالياً؛ لذلك رفع الصور غير متاح، لكنه ليس شرطاً لتشغيل الدليل والبحث والبيانات الأساسية.
- يلزم ضبط Turnstile ومفتاح الإدارة في Cloudflare Pages، ثم إجراء اختبارات فعلية قبل اعتماد الخدمة للإنتاج.

## الوظائف

- واجهة عربية RTL متجاوبة مع البحث والتصنيفات والمدينة والمنطقة.
- صفحات تفاصيل للمشاريع المنشورة.
- نموذج تقديم طلب مشروع محمي بواسطة Turnstile.
- تُحفظ طلبات الإضافة بحالة `needs_review`، ولا تُنشر تلقائياً؛ يراجعها المدير ويقرر قبولها أو رفضها من لوحة الإدارة.
- لوحة إدارة محمية بـ `ADMIN_API_KEY` لإدارة الطلبات والبلاغات والمشاريع والمدن والمناطق والتصنيفات.
- إحصائيات وسجل نشاط وتنبيهات إدارية محفوظة في D1.
- لوحة صاحب المشروع لتعديل بيانات مشروعه باستخدام رمز وصول.
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

جميع المسارات تحت `/api/admin/*` تتطلب ترويسة `Authorization: Bearer <ADMIN_API_KEY>`.

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
4. تأكد من تطبيق ترحيلات D1 بالترتيب من `migrations/0001` إلى `migrations/0005`.
5. أضف الأسرار التالية في إعدادات Pages Production:
   - `ADMIN_API_KEY` — مفتاح عشوائي طويل تحفظه بأمان.
   - `TURNSTILE_SECRET` — المفتاح السري لعنصر Turnstile.
6. لا تضع الأسرار في ملفات المستودع أو ترسلها في المحادثات.
7. افتح `/api/health`، ثم اختبر لوحة الإدارة ونموذج الإرسال فعلياً.

صفحة `/admin-setup.html` تحتوي خطوات الإعداد. لوحة الإدارة متاحة عبر `/admin.html`.

## تخزين الصور الاختياري

عند توفر R2 مستقبلاً، أنشئ bucket واربطه في Pages باسم binding `IMAGES`. لا تضف binding وهمياً ولا تعتبر الصور عاملة قبل اختبار الرفع والاسترجاع والحذف.

## بنية الملفات

- `public/`: صفحات الموقع وملفات CSS وJavaScript.
- `functions/api/[[path]].js`: واجهات Cloudflare Pages Functions.
- `migrations/`: ترحيلات قاعدة D1.
- `wrangler.toml`: إعدادات المشروع وربط D1.
