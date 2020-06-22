#! /bin/bash

SP_USERNAME=$1
SP_PASSWORD=$2
SP_TENANT=$3
SubscriptionId=$4
StartTime=$5
EndTime=$6


#Login using Service Principal
spdata=$(az login --service-principal --username $SP_USERNAME --password $SP_PASSWORD --tenant $SP_TENANT)

az account set -s $SubscriptionId

#Fetch the VM ids
vmlist=$(az vm list --query "[].id" -o tsv)

#Populate the CPU usage of the VMs
az account show -o table > $SubscriptionId.csv

for virtmachine in ${vmlist[@]}; do
	echo "Fetching details for VM -- "$virtmachine >> $SubscriptionId.csv
        az monitor metrics list --resource $virtmachine --metric 'Percentage CPU' --aggregation Average --interval PT1H --start-time $StartTime --end-time $EndTime --output table >> $SubscriptionId.csv 
done
