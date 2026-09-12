#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import os
v=os.environ.get("VM7_CODEINJ_CANARY","")
print("TRUSTED_POSTMERGE_BASELINE=1")
print("CANARY_PRESENT="+("1" if v else "0"))
PY
