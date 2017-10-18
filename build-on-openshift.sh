IMAGESTREAM_NAME=s2i-jboss-as-711

oc new-build https://github.com/ejlp12/s2i-jboss-as.git --name $IMAGESTREAM_NAME --context-dir 7.1.1

oc new-app s2i-jboss-as-711~https://github.com/ejlp12/HelloWebAppWAR.git \
--name=helloapp \
-e DB_SERVICE_PREFIX_MAPPING=test_oracle \
-e TEST_ORACLE_SERVICE_HOST=docker-oracle-xe \
-e TEST_ORACLE_SERVICE_PORT=1521 \
-e TEST_ORACLE_DATABASE=XE \
-e TEST_ORACLE_USERNAME=system \
-e TEST_ORACLE_PASSWORD=oracle \
-e TEST_ORACLE_NONXA=true  \
-e TEST_ORACLE_TX_ISOLATION= \
-e TEST_ORACLE_MIN_POOL_SIZE= \
-e TTEST_ORACLE_MAX_POOL_SIZE= \
-e TEST_ORACLE_JTA=
