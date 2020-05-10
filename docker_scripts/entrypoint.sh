#!/bin/bash
set -euo pipefail

# Sometimes 'pid' files can be left over if the webserver crashes, their existence prevents the
# webserver starting up again, even though no webserver is running
rm -rf tmp/pids/*.pid
exec "$@"
