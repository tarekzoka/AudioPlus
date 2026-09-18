#!/bin/sh
# ==========================================
# سكربت تثبيت وتحديث البلجن لأجهزة Enigma2
# ==========================================

# إعدادات الروابط والمتغيرات
GITHUB_USER="Ahmadarjan1"
GITHUB_REPO="IPAudioPlus"
BRANCH="main"
PLUGIN_NAME="IPAudioPlus"
TAR_FILE="IPAudioPlus.tar.gz"

DEST_DIR="/usr/lib/enigma2/python/Plugins/Extensions/$PLUGIN_NAME"
URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH/$TAR_FILE"
TMP_DIR="/tmp/$PLUGIN_NAME"

echo ""
echo "============================================"
echo "    جاري بدء تثبيت / تحديث $PLUGIN_NAME    "
echo "============================================"
echo ""

# 1. تنظيف أي ملفات مؤقتة سابقة
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

# 2. تحميل الأرشيف
echo "--> جاري تنزيل أحدث إصدار من سيرفر GitHub..."
wget -q --no-check-certificate "$URL" -O "$TMP_DIR/$TAR_FILE"

# فحص نجاح التنزيل
if [ ! -s "$TMP_DIR/$TAR_FILE" ]; then
    echo "❌ خطأ: فشل تحميل الملف! يرجى التأكد من اتصال الإنترنت أو صحة الرابط."
    rm -rf $TMP_DIR
    exit 1
fi

# 3. فك الضغط في مجلد مؤقت
echo "--> جاري فك الضغط وفحص الملفات..."
tar -xzf "$TMP_DIR/$TAR_FILE" -C $TMP_DIR/

# 4. إزالة النسخة القديمة إذا وُجدت وتثبيت الجديدة
echo "--> جاري تثبيت الملفات في المسار المخصص..."
rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"

# نسخ المحتويات إلى مسار إضافات الإنجما2
if [ -d "$TMP_DIR/$PLUGIN_NAME" ]; then
    cp -r "$TMP_DIR/$PLUGIN_NAME/"* "$DEST_DIR/"
else
    # في حال تم فك الضغط مباشرة بدون مجلد أب
    cp -r "$TMP_DIR/"* "$DEST_DIR/" 2>/dev/null
    rm -f "$DEST_DIR/$TAR_FILE"
fi

# 5. ضبط الصلاحيات للملفات المنقولة
chmod -R 755 "$DEST_DIR"

# 6. تنظيف الملفات المؤقتة
rm -rf $TMP_DIR
sync

echo ""
echo "============================================"
echo "      ✅ تم تثبيت البلجن بنجاح!           "
echo "============================================"
echo ""

# 7. خيار إعادة تشغيل الإنجما2 (GUI Restart)
echo "--> جاري إعادة تشغيل واجهة Enigma2 لتطبيق التغييرات..."
sleep 2

if [ -f /usr/bin/systemctl ]; then
    systemctl restart enigma2
elif which init >/dev/null 2>&1; then
    init 4
    sleep 2
    init 3
else
    killall -9 enigma2
fi

exit 0
