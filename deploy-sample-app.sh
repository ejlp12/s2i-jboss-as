echo
echo "---> Will deploy sample web app (WAR file) by developer in myproject"
oc login -u developer -p developer > /dev/null
oc project myproject

echo "---> Create new-app with datasource to ORACLE database"
oc new-app s2i-jboss-as-711-centos7~https://github.com/ejlp12/HelloWebAppWAR.git \
--name=helloapp \
-e DB_SERVICE_PREFIX_MAPPING=TEST_ORACLE \
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

sleep 5
echo
echo "---> Follow build progress..."
oc logs -f bc/helloapp
