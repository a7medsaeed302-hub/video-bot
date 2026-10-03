#!/bin/sh
# بيشتغل كـ root لحظيًا: يحدّث المحركات ويجهّز مجلد البيانات، وبعدها يشغّل البوت بمستخدم عادي.
set -e
DATA_DIR="${DATA_DIR:-/data}"
BOT_UID="${BOT_UID:-10001}"

# تحديث المحركات عشان تفضل متوافقة مع المواقع (لو فشل بنكمل بالنسخة المثبّتة)
if [ -z "$SKIP_UPDATE" ]; then
  pip install -U -q 'yt-dlp[default,curl-cffi]' gallery-dl || echo "engine update failed - using installed versions"
fi

if [ "$(id -u)" = "0" ]; then
  # Volume على Railway / مجلد ./data على VPS بيجي ملكه root — لازم المستخدم العادي يقدر يكتب فيه
  mkdir -p "$DATA_DIR"
  chown -R "$BOT_UID:$BOT_UID" "$DATA_DIR"
  exec env HOME=/home/bot setpriv --reuid="$BOT_UID" --regid="$BOT_UID" --clear-groups "$@"
fi
exec "$@"
