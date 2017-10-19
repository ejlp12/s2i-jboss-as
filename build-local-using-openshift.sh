

echo
echo "This script will build using "docker build" using Openshift docker engine"

echo "---> Setup Openshift environment first using follwing command: "
echo 
echo "     minishift-login-registry.sh" 
echo  


echo
echo "---> Build docker image"
make build VERSION=7.1.1

echo
echo "--> Tag docker image using Openshift registry URL then push into it"
docker tag openshift/s2i-jboss-as-711-centos7 $(minishift openshift registry)/openshift/s2i-jboss-as-711-centos7
docker push $(minishift openshift registry)/openshift/s2i-jboss-as-711-centos7
