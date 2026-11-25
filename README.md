# Redro دليل

دليل أعمال وخدمات محلي يبدأ من حلب، مبني على Cloudflare Pages وPages Functions وD1 وR2، مع فحص طلبات الإضافة عبر Google Gemini.

## الحالة الحالية

هذه هي الدفعة التأسيسية للمشروع. تتضمن واجهة عربية RTL، صفحات تصفح أولية، واجهات API للقراءة والبحث والتقديم، مخطط D1 أولياً، ونقطة تكامل Gemini وTurnstile. لم يتم ربط موارد Cloudflare أو أسرار Gemini/Turnstile أو نشر الموقع بعد. لا توجد بيانات أعمال تجريبية في قاعدة البيانات.

## البنية

- `public/`: الواجهة الثابتة.
- `functions/api/[[path]].js`: واجهات Pages Functions.
- `migrations/`: مخطط D1 والبذور المرجعية للتصنيفات ومدينة حلب.
- `wrangler.toml`: إعداد Pages bindings (يتطلب استبدال المعرفات النائبة).

## المتطلبات

- Node.js LTS وnpm.
- حساب Cloudflare مع Pages وD1 وR2.
- مفتاح Google Gemini API.
- مفاتيح موقع Turnstile وسره.

## الإعداد المحلي

1. ثبّت Wrangler: `npm install --save-dev wrangler`.
2. أنشئ قاعدة D1 باسم `redro-daleel`، ثم ضع معرّفها في `wrangler.toml`.
3. أنشئ حاوية R2 وضع اسمها في `wrangler.toml`.
4. انسخ `.dev.vars.example` إلى `.dev.vars` وأدخل الأسرار محلياً.
5. طبّق الترحيل: `npx wrangler d1 migrations apply redro-daleel --local`.
6. شغّل Pages محلياً: `npx wrangler pages dev public`.

## النشر

بعد إنشاء موارد D1 وR2 واستبدال القيم النائبة، اربط المستودع بـ Cloudflare Pages واضبط متغيرات الأسرار في إعدادات المشروع: `GEMINI_API_KEY` و`GEMINI_MODEL` و`TURNSTILE_SECRET`. لا تضع الأسرار في GitHub أو ملفات الواجهة.

## API الأولية

- `GET /api/categories`
- `GET /api/cities`
- `GET /api/businesses?page=1&limit=20&q=&city=&category=`
- `GET /api/businesses/:slug`
- `POST /api/submissions` (يتطلب Turnstile وGemini)

## ما لم يكتمل بعد

إثبات ملكية أصحاب المشاريع، جلسات الإدارة، رفع الصور الآمن إلى R2، تحرير ونشر سجلات الأعمال من الطلبات المعتمدة، البلاغات، تنظيف البيانات المؤقتة، قيود معدل الطلبات المتقدمة، اختبارات التكامل والأداء، وربط النشر الفعلي. لا تستخدم هذا الإصدار كنظام إنتاج قبل إكمال هذه الضوابط.
