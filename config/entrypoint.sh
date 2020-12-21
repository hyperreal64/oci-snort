#!/usr/bin/env bash

set -e

if [ -z "${OINKCODE}" ]; then
  echo >&2 'Error: Missing OINKCODE environment variable'
  echo >&2 '  try running again with -e OINKCODE=<your oinkcode>'
  exit 1
fi

cp -v /config/snort.conf /etc/snort/snort.conf
sed -i '/rule_url=https:\/\/www.snort.org/s/^#//g' /etc/pulledpork/pulledpork.conf
sed -i "s/<oinkcode>/${OINKCODE}/g" /etc/pulledpork/pulledpork.conf
mkdir /etc/snort/rules/iplists
touch /etc/snort/rules/{black,white}_list.rules
pulledpork -c /etc/pulledpork/pulledpork.conf

snort -D -l /var/log/snort -h $HOME_NET -u snort -g snort -c /etc/snort/snort.conf
