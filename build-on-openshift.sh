IMAGESTREAM_NAME=s2i-jboss-as-711
IMAGE_URL=https://github.com/ejlp12/s2i-jboss-as.git
CODE_URL=https://github.com/ejlp12/HelloWebAppWAR.git

echo "If you have modified something, make sure to push to GIT server first"
echo "This build will use code in $IMAGE_URL" 


oc login -u system:admin > /dev/null
oc project openshift

echo "---> Build new image by system:admin ... it will take sometime"
oc new-build $IMAGE_URL --name $IMAGESTREAM_NAME --context-dir 7.1.1 -n openshift

echo "---> Monitor build process..."
#Sometime first try is getting error since the build container is not yet created, so try again several times
oc logs -f bc/s2i-jboss-as-711 -n openshift 2>/dev/null
while [ $? -ne 0 ]; do
   echo "retrying.."
   sleep 10
   oc logs -f bc/s2i-jboss-as-711 -n openshift  
done

# Check build status by looking into build-pod status
# usually the name of build-pod is something like <imagename>-XX-build 
BUILD_STATUS=$(oc get pod | grep $IMAGESTREAM_NAME | grep "\-build" | awk '{print $3}')
if [ "$BUILD_STATUS" == "Error" ]; then
   echo "---> Build error. Exiting the script.. will not continue"
   echo "        If you got: Failed to push image: received unexpected HTTP status: 500 Internal Server Error"
   echo "        Try to do this command: "
   echo 
   echo "        registrypod=\$(oc get pods -n default | grep docker-registry | grep Running | awk '{print \$1}')"
   echo "        oc logs $registrypod -n default |grep err" 
   echo "        oc exec $registrypod -n default -- ls -lda /registry/docker"
   echo "        oc exec $registrypod -n default -- df -h"
   exit 1
fi


echo
echo "---> List image-stream and build-config..."
oc get is -n openshift | grep $IMAGESTREAM_NAME 
oc get bc -n openshift | grep $IMAGESTREAM_NAME

IMAGE_REPO=$(oc get is |grep $IMAGESTREAM_NAME | awk '{print $2}')
oc tag $IMAGE_REPO $IMAGESTREAM_NAME:latest
oc tag openshift/$IMAGESTREAM_NAME $IMAGESTREAM_NAME:latest


oc login -u developer -p developer > /dev/null

echo
echo "---> Build new app in openshift... by developer"
oc new-app $IMAGESTREAM_NAME:latest~$CODE_URL \
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
-e TEST_ORACLE_JTA= \
--allow-missing-imagestream-tags \
--strategy=source

# Note: --allow-missing-imagestream-tags and --strategy=source is workaround since 'oc tag' above is not working

