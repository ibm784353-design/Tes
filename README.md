# DarkFlix - دليل التشغيل الكامل

## المتطلبات

| متطلب | رابط التحميل |
|-------|-------------|
| Node.js 18+ | https://nodejs.org |
| pnpm | `npm install -g pnpm` |
| Docker Desktop | https://www.docker.com/products/docker-desktop/ |

---

## الخطوات (مرة واحدة فقط)

### 1. تثبيت Docker Desktop
حمّله من الرابط وثبّته، وتأكد إنه شغّال (أيقونة الحوت في الـ taskbar).

### 2. تثبيت الـ dependencies
```powershell
cd stremio-web-5.0.0-beta.36
pnpm install
```

### 3. بناء أو تشغيل DarkFlix (development)
```powershell
pnpm start
```
يفتح على: `https://localhost:8080`

---

## التشغيل اليومي (بضغطة واحدة)

### الطريقة السهلة - سكريبت أوتوماتيك:
```
انقر بالزر الأيمن على start.ps1 → Run with PowerShell
```

السكريبت يعمل تلقائياً:
1. يشغّل Streaming Server عبر Docker
2. ينتظر حتى يصبح جاهز
3. يفتح DarkFlix في المتصفح

### الطريقة اليدوية:
```powershell
# في terminal أول - شغّل السيرفر
docker-compose up -d

# في terminal ثاني - شغّل DarkFlix
cd stremio-web-5.0.0-beta.36
pnpm start
```

---

## حل مشكلة "Streaming Server Unavailable"

إذا ظهرت هذه الرسالة:

1. تأكد أن Docker Desktop شغّال
2. شغّل: `docker-compose up -d`
3. افتح DarkFlix → Settings → Streaming
4. URL يجب أن يكون: `http://127.0.0.1:11470/`
5. اضغط **Reload**

---

## إيقاف السيرفر

```powershell
# من مجلد darkflix-deploy
docker-compose down

# أو انقر بالزر الأيمن على stop-server.ps1 → Run with PowerShell
```

---

## الـ Ports المستخدمة

| Service | Port |
|---------|------|
| DarkFlix Web | https://localhost:8080 |
| Streaming Server HTTP | http://localhost:11470 |
| Streaming Server HTTPS | https://localhost:12470 |

---

## ملاحظة مهمة عن HTTPS

المتصفح قد يحذّر من الشهادة الـ self-signed. اضغط **Advanced → Proceed** لإكمال التحميل.
هذا طبيعي ويحدث في بيئة التطوير المحلي.
