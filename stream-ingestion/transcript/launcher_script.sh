# Upload schema and table config


#  start kafka
 bin/pinot-admin.sh  StartKafka -zkAddress=localhost:2123/kafka -port 19092


# create topic

 bin/kafka-topics.sh --create --bootstrap-server localhost:19092 --replication-factor 1 --partitions 1 --topic transcript-topic

# delete topic 

# bin/kafka-topics.sh –-delete --zookeeper localhost:19092 –-topic transcript-topic 
# Upload  schema and table config
export PINOT_DIR=/Users/deemish2/git/pinot-poc/stream-ingestion/transcript

bin/pinot-admin.sh AddTable \
    -schemaFile ${PINOT_DIR}/transcript-schema.json \
    -tableConfigFile ${PINOT_DIR}/transcript-table-realtime.json \
    -exec


bin/pinot-admin.sh AddTable \
    -tableConfigFile ${PINOT_DIR}/transcript-table-realtime.json \
    -exec


# Push  JSON into Kafka topic

bin/kafka-console-producer.sh \
    --broker-list localhost:19092 \
    --topic transcript-topic < /${PINOT_DIR}/upsert_transcript.json


# update schema

bin/pinot-admin.sh AddSchema -schemaFile ${PINOT_DIR}/transcript-schema.json -exec



bin/pinot-admin.sh StreamAvroIntoKafka \
  -avroFile examples/stream/airlineStats/sample_data/airlineStats_data.avro \
  -kafkaTopic flights-realtime -kafkaBrokerList localhost:19092 -zkAddress localhost:2191/kafka



  pinot-admin.sh ValidateSegment -tablePrefix transcript_realtime -clusterName PinotCluster -zkAddress localhost:2123


bin/pinot-admin.sh ConvertPinotSegment -dataDir /Users/deemish2/git/pinot-poc/controller/data/transcript/transcript__0__0__20210720T0224Z -outputDir /Users/deemish2/git/pinot-poc/server/data/ -outputFormat CSV -overwrite -csvDelimiter , --csvWithHeader