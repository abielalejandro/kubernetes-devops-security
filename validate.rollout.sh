#!/bin/bash

sleep 60s
./kubectl rollout status deployment $APP_NAME --timeout 5 > status.log
if [[ ${cat status.log} != *"deployment successfully rolled out"* ]];
then
echo "Deployment $APP_NAME rollout status has failed"
./kubectl rollout undo deployment $APP_NAME
else
echo "Deployment $APP_NAME rollout status is success"
fi;
