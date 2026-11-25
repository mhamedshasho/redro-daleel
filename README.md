# Redro دليل

دليل أعمال وخدمات محلي يبدأ من حلب، مبني على Cloudflare Pages وPages Functions وD1 وR2، مع فحص طلبات الإضافة عبر Google Gemini.

## الحالة الحالية

النسخة الحالية تتضمن:
- واجهة عربية RTL متجاوبة، وبحثاً وتصنيفات ومدناً.
- صفحة تفاصيل لكل مشروع عبر `/business/:slug`.
- نموذج إضافة مع مراجعة البيانات قبل الإرسال وTurnstile.
- Pages Functions لقراءة الدليل والبحث وإرسال الطلبات.
- فحص Gemini من جهة الخادم فقط.
- نشر تلقائي إلى `businesses` عندما تكون نتيجة Gemini `approved` ودرجة التقييم 75 أو أعلى ولا توجد مشكلات.
- حفظ الطلب قبل الاتصال بـ Gemini، وإمكانية إعادة محاولة الطلبات ذات الحالة `pending_retry` بإعادة إرسال البيانات نفسها بعد إكمال Turnstile.
- مخطط D1 وترحيلات متتابعة دون حذف البيانات.

**لم يتم حتى الآن ربط موارد Cloudflare أو نشر التطبيق أو إجراء اختبار تشغيل حي.** لا توجد مشاريع تجريبية داخل قاعدة البيانات.

## البنية

- `public/`: الواجهة الثابتة وصفحات التقديم والتفاصيل.
- `functions/api/[...path].js`: واجهات Pages Functions.
- `migrations/`: مخطط D1 والترحيلات.
- `wrangler.toml`: إعداد Pages bindings؛ يجب استبدال القيم النائبة قبل التشغيل.

## المتطلبات

- Node.js LTS وnpm.
- حساب Cloudflare مع Pages وD1 وR2.
- مفتاح Google Gemini API.
- Turnstile Site Key وSecret Key.

## الإعداد المحلي

1. ثبّت Wrangler: `npm install --save-dev wrangler`.
2. أنشئ قاعدة D1 باسم `redro-daleel`، ثم ضع معرّفها في `wrangler.toml`.
3. أنشئ حاوية R2 وضع اسمها في `wrangler.toml`.
4. انسخ `.dev.vars.example` إلى `.dev.vars` وأدخل الأسرار محلياً.
5. طبّق جميع الترحيلات: `npx wrangler d1 migrations apply redro-daleel --local`.
6. شغّل Pages محلياً: `npx wrangler pages dev public`.

## الإعدادات المطلوبة

أضف الأسرار في إعدادات Pages أو عبر Wrangler Secrets:
- `GEMINI_API_KEY`
- `TURNSTILE_SECRET`\n- `ADMIN_API_KEY` (مفتاح عشوائي طويل يُحفظ كـ Secret ولا يوضع في الواجهة)

أضف متغيراً عادياً:
- `GEMINI_MODEL=gemini-2.5-flash` (تحقق من توفر اسم النموذج في مشروع Gemini قبل الاستخدام).

ضع Turnstile Site Key العام في وسم `meta[name="turnstile-site-key"]` داخل `public/submit.html`. هذا المفتاح عام بطبيعته؛ أما Secret Key فيبقى سرياً على الخادم.

## API

- `GET /api/categories`
- `GET /api/cities`
- `GET /api/businesses?page=1&limit=20&q=&city=&category=`
- `GET /api/businesses/:slug`
- `POST /api/submissions`\n- `POST /api/reports`\n- `GET /api/admin/submissions` (Bearer ADMIN_API_KEY)\n- `PATCH /api/admin/submissions/:id` (Bearer ADMIN_API_KEY)\n- `GET /api/admin/reports` (Bearer ADMIN_API_KEY)
- `GET /api/admin/businesses?q=` (Bearer ADMIN_API_KEY)
- لوحة الإدارة: `/admin.html` (تتطلب ADMIN_API_KEY)
- `POST /api/admin/businesses/:id/images` (multipart field `image`, Bearer ADMIN_API_KEY)
- `DELETE /api/admin/images/:imageId` (Bearer ADMIN_API_KEY)
- `GET /api/images/:imageId` (public, published businesses only)\n- `PATCH /api/admin/reports/:id` (Bearer ADMIN_API_KEY)

يحتاج مسار التقديم إلى Turnstile صالحاً بالـ action المحدد `business_submission` وباسم المضيف المطابق لنطاق الطلب، وإعداد Gemini. إذا تعذر فحص Gemini، يُحفظ الطلب بحالة `pending_retry` ولا ينشر.

## اختبارات منفذة في بيئة التطوير

- اختبار SQLite لترحيل ربط `submissions.business_id` بعلاقة Foreign Key: ناجح.
- اختبار سلوك `ON DELETE SET NULL` في SQLite: ناجح.
- تحقق ساكن من وجود منطق إنشاء سجل الأعمال عند الموافقة، وحد التقييم، وعدم إرسال مفتاح Gemini في Query String.

لم تُنفذ بعد اختبارات Worker محلية أو اختبارات API حية أو Lighthouse أو k6.

## ما لم يكتمل بعد

- ملكية المشاريع وتسجيل أصحابها وتعديل بياناتهم بأمان.
- واجهة لوحة الإدارة المرئية؛ توجد الآن واجهات API محمية لإدارة الطلبات والبلاغات.
واجهة رفع الصور المرئية لصاحب المشروع لم تكتمل؛ الرفع والحذف متاحان حالياً عبر واجهات إدارة محمية بمفتاح الإدارة، مع تخزين R2 والتحقق من JPEG/PNG/WebP والحجم.
- ساعات العمل وروابط التواصل الاجتماعي والعنوان التفصيلي.
- Rate Limiting تشغيلي على مستوى المنصة.
- آلية إعادة محاولة مجدولة للطلبات المعلقة.
- تنظيف الطلبات المؤقتة والملفات اليتيمة.
- ربط موارد Cloudflare والنشر الفعلي واختبارات الإنتاج.

لا تستخدم النسخة الحالية كنظام إنتاج قبل إكمال هذه الضوابط.
