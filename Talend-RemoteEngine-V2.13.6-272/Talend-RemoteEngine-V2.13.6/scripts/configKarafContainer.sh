# This is NOT a OS shell script, but a Karaf script
# To execute it, open a Karaf shell for your container and type: source scripts/<This script's name>

# Expected
RMI_Registry_Port=${1}
RMI_Server_Port=${2}
HTTP_Port=${3}
HTTPS_Port=${4}
SSH_Port=${5}
COMMAND_SERVER_PORT=${6}
FILE_SERVER_PORT=${7}
MONITORING_PORT=${8}
PROCESS_MESSAGE_PORT=${9}
MS_PORT_RANGE_START=${10}
MS_LOG_COLLECTION_PORT=${11}
OSGI_LOG_COLLECTION_PORT=${12}
ESB_RMI_SERVER_HOST=${13}
ESB_RMI_SERVER_PORT=${14}
ESB_RMI_REGISTRY_SERVER=${15}
ESB_RMI_REGISTRY_PORT=${16}

echo "Start configuring ......"

echo
echo "JMX Management configuration (PID: org.apache.karaf.management.cfg)"
config:edit --force org.apache.karaf.management
echo "rmiRegistryPort = $1"
config:property-set rmiRegistryPort $1
echo "rmiServerPort = $2"
config:property-set rmiServerPort $2
config:property-set serviceUrl service:jmx:rmi://\${rmiServerHost}:\${rmiServerPort}/jndi/rmi://\${rmiRegistryHost}:\${rmiRegistryPort}/karaf-\${karaf.name}
config:update

echo
echo "OSGI HTTP/HTTPS Service configuration (Pid: org.ops4j.pax.web.cfg)"
config:edit --force org.ops4j.pax.web
echo "org.osgi.service.http.port = $3"
config:property-set org.osgi.service.http.port $3
echo "org.osgi.service.http.port.secure = $4"
config:property-set org.osgi.service.http.port.secure $4
config:update

echo
echo "Karaf SSH shell configuration (Pid: org.apache.karaf.shell.cfg)"
config:edit --force org.apache.karaf.shell
echo "sshPort = $5"
config:property-set sshPort $5
config:update

echo
echo "Jobserver configuration (Pid: org.talend.remote.jobserver.server.cfg)"
config:edit --force org.talend.remote.jobserver.server
echo "org.talend.remote.jobserver.server.TalendJobServer.COMMAND_SERVER_PORT = $6"
config:property-set org.talend.remote.jobserver.server.TalendJobServer.COMMAND_SERVER_PORT $6
echo "org.talend.remote.jobserver.server.TalendJobServer.FILE_SERVER_PORT = $7"
config:property-set org.talend.remote.jobserver.server.TalendJobServer.FILE_SERVER_PORT $7
echo "org.talend.remote.jobserver.server.TalendJobServer.MONITORING_PORT = $8"
config:property-set org.talend.remote.jobserver.server.TalendJobServer.MONITORING_PORT $8
echo "org.talend.remote.jobserver.server.TalendJobServer.PROCESS_MESSAGE_PORT = $9"
config:property-set org.talend.remote.jobserver.server.TalendJobServer.PROCESS_MESSAGE_PORT $9

config:update

echo
echo "DSRunner configuration (Pid: org.talend.ipaas.rt.dsrunner.cfg)"
config:edit --force org.talend.ipaas.rt.dsrunner
echo "ms.http.port.range.start = ${MS_PORT_RANGE_START}"
config:property-set ms.http.port.range.start ${MS_PORT_RANGE_START}
echo "ms.log.collection.port = ${MS_LOG_COLLECTION_PORT}"
config:property-set ms.log.collection.port ${MS_LOG_COLLECTION_PORT}
echo "osgi.log.collection.port = ${OSGI_LOG_COLLECTION_PORT}"
config:property-set osgi.log.collection.port ${OSGI_LOG_COLLECTION_PORT}
config:update

echo
echo "DSRunner Log4J Socket Collector configuration (Pid: org.talend.ipaas.rt.dsrunner.log4jsocket.collector.cfg)"
config:edit --force org.talend.ipaas.rt.dsrunner.log4jsocket.collector
echo "ms.socket.port = ${MS_LOG_COLLECTION_PORT}"
config:property-set ms.socket.port ${MS_LOG_COLLECTION_PORT}
echo "osgi.socket.port = ${OSGI_LOG_COLLECTION_PORT}"
config:property-set osgi.socket.port ${OSGI_LOG_COLLECTION_PORT}
config:update

echo
echo "DSRunner Talend Runtime configuration (Pid: org.talend.ipaas.rt.dsrunner.talendruntime.client.cfg)"
config:edit --force org.talend.ipaas.rt.dsrunner.talendruntime.client
echo "talendruntime.jmx.url = service:jmx:rmi://${ESB_RMI_SERVER_HOST}:${ESB_RMI_SERVER_PORT}/jndi/rmi://${ESB_RMI_REGISTRY_SERVER}:${ESB_RMI_REGISTRY_PORT}/karaf-trun"
config:property-set talendruntime.jmx.url service:jmx:rmi://${ESB_RMI_SERVER_HOST}:${ESB_RMI_SERVER_PORT}/jndi/rmi://${ESB_RMI_REGISTRY_SERVER}:${ESB_RMI_REGISTRY_PORT}/karaf-trun
config:update

echo
echo "Configuration finished successfully."