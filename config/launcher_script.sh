export PINOT_VERSION=0.7.1

cd apache-pinot-incubating-${PINOT_VERSION}-bin
bin/pinot-admin.sh StartZookeeper





# run pinot controller
export PINOT_DIR=/Users/deemish2/git/pinot-poc
bin/pinot-admin.sh StartController -configFileName ${PINOT_DIR}/config/pinot-controller.conf


# run Pinot Broker
export PINOT_DIR=/Users/deemish2/git/pinot-poc
bin/pinot-admin.sh StartBroker -clusterName pinot-quickstart -zkAddress localhost:2181 -configFileName ${PINOT_DIR}/config/pinot-broker.conf


# run Pinot Server
export PINOT_DIR=/Users/deemish2/git/pinot-poc
bin/pinot-admin.sh StartServer -clusterName pinot-quickstart -zkAddress localhost:2181 -configFileName ${PINOT_DIR}/config/pinot-server.conf

#start minion 

export PINOT_DIR=/Users/deemish2/git/pinot-poc

bin/pinot-admin.sh StartMinion -clusterName pinot-quickstart -zkAddress localhost:2181 -configFileName ${PINOT_DIR}/config/pinot-minion.conf




# run Pinot Service Manager

export PINOT_DIR=/Users/deemish2/git/pinot-poc

bin/pinot-admin.sh StartServiceManager -zkAddress localhost:2181 -clusterName pinot-quickstart  -port -1 -bootstrapServices  [] -bootstrapConfigPaths ${PINOT_DIR}/config/pinot-controller.conf  ${PINOT_DIR}/config/pinot-broker.conf

bin/pinot-admin.sh StartBroker -zkAddress localhost:2181 -clusterName pinot-quickstart  -bootstrapServices CONTROLLER BROKER -bootstrapConfigPaths ${PINOT_DIR}/config/pinot-controller.conf  ${PINOT_DIR}/config/pinot-broker.conf

# cluster info

bin/pinot-admin.sh ShowClusterInfo -clusterName pinot-quickstart  -zkAddress localhost:2181


bin/pinot-admin.sh StartController -configFileName ${PINOT_DIR}/config/pinot-controller.conf StartBroker -clusterName pinot-quickstart -zkAddress localhost:2181 -configFileName ${PINOT_DIR}/config/pinot-broker.conf StartServer -configFileName ${PINOT_DIR}/config/pinot-server.conf  StartMinion -configFileName ${PINOT_DIR}/config/pinot-minion.conf





# stop process

bin/pinot-admin.sh StopProcess -controller -broker -server -minion