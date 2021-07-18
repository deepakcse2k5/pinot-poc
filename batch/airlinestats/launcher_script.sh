# Upload  schema and table config
export PINOT_DIR=/Users/deemish2/git/pinot-poc/batch/airlinestats


bin/pinot-admin.sh AddTable \
  -tableConfigFile ${PINOT_DIR}/airlineStats_offline_table_config.json \
  -schemaFile ${PINOT_DIR}/airlineStats_schema.json -exec


/Users/deemish2/git/pinot-poc/batch/airlinestats/ingestionJobSpec.yaml




bin/pinot-admin.sh LaunchDataIngestionJob \
    -jobSpecFile ${PINOT_DIR}/ingestionJobSpec.yaml

bin/pinot-ingestion-job.sh ${PINOT_DIR}/ingestionJobSpec.yaml


# convert pinot segment:

bin/pinot-admin.sh ConvertPinotSegment -dataDir ${PINOT_DIR}/segments/2014/01/01 -outputDir ${PINOT_DIR}/data/2014/01/01 -outputFormat CSV -overwrite  -csvDelimiter , -csvWithHeader true