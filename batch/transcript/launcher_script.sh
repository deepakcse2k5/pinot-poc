# Upload  schema and table config
export PINOT_DIR=/Users/deemish2/git/pinot-poc/batch/transcript


bin/pinot-admin.sh AddTable \
  -tableConfigFile ${PINOT_DIR}/transcript-table-offline.json \
  -schemaFile ${PINOT_DIR}/transcript-schema.json -exec







bin/pinot-admin.sh LaunchDataIngestionJob \
    -jobSpecFile ${PINOT_DIR}/batch-job-spec-offline.yml


# convert pinot segment:

bin/pinot-admin.sh ConvertPinotSegment -dataDir ${PINOT_DIR}/segments/01 -outputDir ${PINOT_DIR}/data/01 -outputFormat CSV -overwrite -csvDelimiter , 