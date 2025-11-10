#!/bin/bash

docker compose exec st2actionrunner sh -c /st2actionrunner-snpseq.sh
docker compose exec st2client sh -c /st2client-snpseq.sh
