# This is NOT a OS shell script, but a Karaf script
# To execute it, open a Karaf shell for your container and type: source scripts/<This script's name>

RMI_Registry_Port=1103
RMI_Server_Port=44448
HTTP_Port=8044
HTTPS_Port=9005
SSH_Port=8105
COMMAND_SERVER_PORT=8013
FILE_SERVER_PORT=8014
MONITORING_PORT=8901
PROCESS_MESSAGE_PORT=8568
MS_PORT_RANGE_START=5090
MS_LOG_COLLECTION_PORT=7790
OSGI_LOG_COLLECTION_PORT=7791
ESB_RMI_SERVER_HOST=localhost
ESB_RMI_SERVER_PORT=44445
ESB_RMI_REGISTRY_SERVER=localhost
ESB_RMI_REGISTRY_PORT=1100
OMC_Port=9501

source scripts/configKarafContainer.sh $RMI_Registry_Port $RMI_Server_Port $HTTP_Port $HTTPS_Port $SSH_Port $COMMAND_SERVER_PORT $FILE_SERVER_PORT $MONITORING_PORT $PROCESS_MESSAGE_PORT $MS_PORT_RANGE_START $MS_LOG_COLLECTION_PORT $OSGI_LOG_COLLECTION_PORT $ESB_RMI_SERVER_HOST $ESB_RMI_SERVER_PORT $ESB_RMI_REGISTRY_SERVER $ESB_RMI_REGISTRY_PORT $OMC_Port
