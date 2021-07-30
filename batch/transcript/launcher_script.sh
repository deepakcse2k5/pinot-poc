# Upload  schema and table config
export PINOT_DIR=/Users/deemish2/git/pinot-poc/batch/transcript


bin/pinot-admin.sh AddTable \
  -tableConfigFile ${PINOT_DIR}/transcript-table-offline.json \
  -schemaFile ${PINOT_DIR}/transcript-schema.json -exec


  bin/pinot-admin.sh AddTable \
  -tableConfigFile ${PINOT_DIR}/transcript-table-offline.json -exec


bin/pinot-admin.sh ConvertPinotSegment -dataDir /var/folders/31/k4zym6155mv4_ymqml2k3x2h0000gp/T/1626667288900/baseballStats/rawdata/PinotControllerDir0/transcript_realtime/transcript_realtime__0__1__20210719T0423Z  -outputDir ${PINOT_DIR}/data/01/   -outputFormat CSV -overwrite -csvDelimiter , -csvWithHeader




bin/pinot-admin.sh LaunchDataIngestionJob \
    -jobSpecFile /Users/deemish2/git/pinot-poc/batch/transcript/batch-job-spec.yml


# convert pinot segment:

bin/pinot-admin.sh ConvertPinotSegment -dataDir ${PINOT_DIR}/segments/02 -outputDir ${PINOT_DIR}/data/02 -outputFormat CSV -overwrite -csvDelimiter , -csvWithHeader

bin/pinot-admin.sh ConvertPinotSegment -dataDir /var/folders/31/k4zym6155mv4_ymqml2k3x2h0000gp/T/1626667288900/baseballStats/rawdata/PinotControllerDir0/transcript_realtime/transcript_realtime__0__0__20210719T0422Z  -outputDir ${PINOT_DIR}/data/ -outputFormat CSV -overwrite -csvDelimiter , 