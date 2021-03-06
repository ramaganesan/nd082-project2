#!/usr/bin/env bash

#https://medium.com/@dirk.avery/the-bash-trap-trap-ce6083f36700
set -e
trap 'catch $? $LINENO' EXIT

catch() {
  echo "catching!"
  if [ "$1" != "0" ]; then
    # error handling goes here
    echo "Error $1 occurred on $2"
  fi
}

echo "Please Make sure if you are logged in to your subscription before running the script"

read -p "Are you logged in to your Azure Subscription(Yes/No): " loginYes

if [[ ${loginYes^^} != 'YES' ]]; then
echo "Please log in to Azure Subscription"
   exit 1
fi

read -p 'Please enter Resource Group Name: ' rgGroupName
read -p 'Azure Web App Name: ' azWebappName
read -p 'Please enter Yes/No if Resource Group Exists in Azure: ' rgExists

if [[ -z "$rgGroupName" ]]  || [[ -z "$azWebappName" ]] || [[ -z "$rgExists" ]]; then
   echo "Please enter all requested parameters"
   exit 1
fi

if [[ ${rgExists^^} == 'NO' ]]; then
  echo "Going to create Resource Group in Azure: " $rgGroupName
  az group create --name nd082-project2-rg --location eastus
  echo "Going to Create Azure Webapp using free tier: " $azWebappName
  az webapp up --name $azWebappName --resource-group $rgGroupName --sku FREE
  echo "Azure Web App Created Successfully"
else
  echo "Going to Create Azure Webapp using free tier: " $azWebappName
  az webapp up --name $azWebappName --resource-group $rgGroupName --sku FREE
  echo "Azure Web App Created Successfully"
fi

exit 0

