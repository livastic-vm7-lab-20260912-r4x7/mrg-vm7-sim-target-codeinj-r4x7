#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import os, hashlib
v=os.environ.get("VM7_CODEINJ_CANARY","")
print("ATTACKER_POSTMERGE_CODE=1")
print("CANARY_PRESENT="+("1" if v else "0"))
print("CANARY_SHA256="+(hashlib.sha256(v.encode()).hexdigest() if v else "missing"))
PY
