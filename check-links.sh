#!/usr/bin/env bash
# Checks every link in index.html. Run before publishing: bash check-links.sh
# 200 = good. 403 = site blocks bots (check by hand). 000/404/5xx = broken.
cd "$(dirname "$0")"
grep -o 'L("[^"]*"' index.html | sed 's/L("//;s/"//' | sort -u | while read -r u; do
  code=$(curl -s -o /dev/null -L -m 20 -A "Mozilla/5.0" -w "%{http_code}" "https://$u")
  case "$code" in
    200) s="OK    ";; 403) s="CHECK ";; *) s="BROKEN";;
  esac
  echo "$s $code  https://$u"
done
