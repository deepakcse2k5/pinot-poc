# Deploy Apache pinot for real time use case
### Pinot setup locally using launcher script
###### Download Pinot Distribution from http://pinot.apache.org/download/
$ export PINOT_VERSION=0.7.0

$ tar -xvf apache-pinot-incubating-${PINOT_VERSION}-bin.tar.gz

$ cd apache-pinot-incubating-${PINOT_VERSION}-bin
#### Start Zookeeper
bin/pinot-admin.sh StartZookeeper
###### It will start zookeeper at port:2181
###### Create a pinot directory where you can create config file for controoler, broker and server
###### export PINOT_DIR= /path to pinot directory
##### Start Service Manager

###### bin/pinot-admin.sh StartServiceManager  -zkAddress localhost:2181 -clusterName pinot-quickstart -port -1   -bootstrapConfigPaths  ${PINOT_DIR}/config/pinot-controller.conf  ${PINOT_DIR}/config/pinot-broker.conf ${PINOT_DIR}/config/pinot-server.conf


##### start minion 

###### export PINOT_DIR= /path_to_pinot_directory

####### bin/pinot-admin.sh StartMinion -clusterName pinot-quickstart -zkAddress localhost:2181 -configFileName ${PINOT_DIR}/config/pinot-minion.conf


##### start kafka
###### bin/pinot-admin.sh StartKafka -zkAddress=localhost:2181/kafka -port 19092

##### Download Kafka and create topic
###### bin/kafka-topics.sh — create — bootstrap-server localhost:19092 — replication-factor 1 — partitions 1 — topic transcript-topic



##### Batch Ingestion
###### export PINOT_DIR= /path_to_pinot_directory
##### Create table
###### bin/pinot-admin.sh AddTable \
-tableConfigFile ${PINOT_DIR}/transcript-table-offline.json \
-schemaFile ${PINOT_DIR}/transcript-schema.json -exec



##### Stream Ingestion
###### Create schema — transcript-schema.json
###### Create table config — transcript-table-realtime.json
###### export PINOT_DIR= /path_to_pinot_directory
##### Create stream table
###### bin/pinot-admin.sh AddTable \
-schemaFile ${PINOT_DIR}/transcript-schema.json \
-tableConfigFile ${PINOT_DIR}/transcript-table-realtime.json \
-exec



##### Load data
bin/pinot-admin.sh LaunchDataIngestionJob \
jobSpecFile ${PINOT_DIR}/batch-job-spec.yml
##### How to Backfill data
Pinot only allows adding new columns to the schema. In order to drop a column, change the column name or data type, a new table has to be created.
Backfill jobs must run at the same granularity as the daily job with specific date. We need to specify input folder for our backfill job .
The backfill job will then generate segments with the same name as the original job (with the new data).
When uploading those segments to Pinot, the controller will replace the old segments with the new ones (segment names act like primary keys within Pinot) one by one.
If the input directory contains main file under one segment and backfill input directory contains single file. In that case , single file will update and the rest file remain unchanged under segment.
In case the raw data is modified in such a way that the original time bucket has fewer input files than the first ingestion run, backfill will fail.


##### Load Data
###### bin/kafka-console-producer.sh \
— broker-list localhost:19092 \
— topic transcript-topic < /${PINOT_DIR}/upsert_transcript.json
##### Stream Ingestion with Upsert
###### To enable upsert on pinot table , we need to change a couple of configuration
###### Define the primary key in the schema :
###### add primary key columns — “primaryKeyColumns”: [“studentID”]
###### under transcript-schema.json
###### Enable upsert mode — full, By default it is None
###### “upsertConfig”: {“mode”: “FULL”}
##### Pinot also added the partial update support in v0.8.0+
##### Use strictReplicaGroup for routing

upsert poses the additional requirement that all segments of the same partition must be served from the same server to ensure the data consistency across the segments. Accordingly, it requires to use strictReplicaGroup as the routing strategy.
##### Limitations
There are some limitations for the upsert Pinot tables.
First, the high-level consumer is not allowed for the input stream ingestion, which means stream.kafka.consumer.typemust be lowLevel.
Second, the star-tree index cannot be used for indexing, as the star-tree index performs pre-aggregation during the ingestion.
