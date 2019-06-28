#!/bin/bash

calcifer_path="${HOME}/.calcifer.noindex/Calcifer"
if [ -f ${calcifer_path} ]; then
   enabled=$("${calcifer_path}" obtainConfigValue --keyPath enabled | head -1)
   if [ "$enabled" == "1" ]; then
      "${calcifer_path}" sendCommandToDaemon --commandName prepareRemoteCache
   fi
fi