#!/bin/bash

sleep 60s
./kubectl rollout history deployment "$APP_NAME"
result=$(./kubectl rollout status deployment "$APP_NAME" --timeout 10s)
expected="deployment \"$APP_NAME\" successfully rolled out"

if [[ "$result" != "$expected" ]];
then
  echo "Deployment $APP_NAME rollout status has failed"
 ./kubectl rollout undo deployment $APP_NAME
else
  echo "Deployment $APP_NAME rollout status is success"
fi;
