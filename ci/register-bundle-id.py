#!/usr/bin/env python3
"""Register es.verkvest.mallowskip with App Store Connect if it is missing.

409 / already-exists is success. Creating the App Store Connect *app record*
is not possible with this API; TestFlight upload reports that separately.
"""

import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

import jwt

BUNDLE_ID = os.environ.get("BUNDLE_ID", "es.verkvest.mallowskip")
NAME = os.environ.get("APP_NAME", "Mallowskip")
KEY_ID = os.environ["APPSTORE_API_KEY_ID"]
ISSUER = os.environ["APPSTORE_API_ISSUER_ID"]
KEY_PATH = os.environ["APPSTORE_API_KEY_PATH"]


def token() -> str:
    now = int(time.time())
    private_key = open(KEY_PATH, "r", encoding="utf-8").read()
    encoded = jwt.encode(
        {"iss": ISSUER, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"},
        private_key,
        algorithm="ES256",
        headers={"kid": KEY_ID, "typ": "JWT"},
    )
    return encoded if isinstance(encoded, str) else encoded.decode("ascii")


def request(method, url, body=None):
    data = None if body is None else json.dumps(body).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method=method,
        headers={
            "Authorization": f"Bearer {token()}",
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            return response.status, response.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as error:
        return error.code, error.read().decode("utf-8", "replace")


def main() -> int:
    query = urllib.parse.urlencode({"filter[identifier]": BUNDLE_ID})
    status, payload = request("GET", f"https://api.appstoreconnect.apple.com/v1/bundleIds?{query}")
    if status != 200:
        print(f"bundle id lookup failed: HTTP {status}", file=sys.stderr)
        print(payload[:800], file=sys.stderr)
        return 1
    found = json.loads(payload).get("data") or []
    if found:
        print(f"bundle id {BUNDLE_ID} already registered")
        return 0
    status, payload = request(
        "POST",
        "https://api.appstoreconnect.apple.com/v1/bundleIds",
        {
            "data": {
                "type": "bundleIds",
                "attributes": {
                    "identifier": BUNDLE_ID,
                    "name": NAME,
                    "platform": "IOS",
                },
            }
        },
    )
    if status in (201, 409):
        print(f"bundle id {BUNDLE_ID} ready (HTTP {status})")
        return 0
    print(f"bundle id registration failed: HTTP {status}", file=sys.stderr)
    print(payload[:800], file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
