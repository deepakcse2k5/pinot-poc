# Upload schema and table config
# start zookeeper

bin/pinot-admin.sh StartZookeeper -zkPort 2191

#  start kafka
 

bin/pinot-admin.sh  StartKafka -zkAddress=localhost:2181/kafka -port 19092


# create topic

 bin/kafka-topics.sh --create --bootstrap-server localhost:19092 --replication-factor 1 --partitions 1 --topic wxcall-topic

# Upload  schema and table config
export PINOT_DIR=/Users/deemish2/git/pinot-poc/stream-ingestion/wxcall

bin/pinot-admin.sh AddTable \
    -schemaFile ${PINOT_DIR}/call-schema.json \
    -tableConfigFile ${PINOT_DIR}/call-table-realtime.json \
    -exec



# Push  JSON into Kafka topic

bin/kafka-console-producer.sh \
    --broker-list localhost:19092 \
    --topic wxcall-topic < /${PINOT_DIR}/wxcall.json


# update schema

bin/pinot-admin.sh AddSchema -schemaFile ${PINOT_DIR}/transcript-schema.json -exec


