

echo
echo "This script will build using "docker build" using Minishift docker engine"

echo "---> Setup Minishift environment first using following command: "
echo 
echo "     minishift-login-registry.sh" 
echo  

read -p "To continue press any key, CTRL+C to cancel..."


echo
echo "---> Build docker image"
make build VERSION=7.1.1

echo
echo "--> Tag docker image using Openshift registry URL then push into it"
docker tag openshift/s2i-jboss-as-711-centos7 $(minishift openshift registry)/openshift/s2i-jboss-as-711-centos7
docker push $(minishift openshift registry)/openshift/s2i-jboss-as-711-centos7
