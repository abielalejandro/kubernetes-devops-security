#!/bin/bash

sleep 60s
./kubectl rollout history deployment "$APP_NAME"
if [[ $(./kubectl rollout status deployment "$APP_NAME" --timeout 5s) != *"deployment successfully rolled out"* ]];
then
echo "Deployment $APP_NAME rollout status has failed"
./kubectl rollout undo deployment $APP_NAME
else
echo "Deployment $APP_NAME rollout status is success"
fi;
