#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cid="$(
	docker run -d --name "${NAME}" "${IMAGE}"
)"
trap "docker rm -vf ${cid} > /dev/null" EXIT

docker exec --user=82 "${NAME}" make check-ready -f /usr/local/bin/actions.mk
echo -n "Checking Drupal version... "
docker exec --user=82 "${NAME}" drush -r "/var/www/html/web" status | grep -q 'Drupal version *: *8\.'
echo "OK"
