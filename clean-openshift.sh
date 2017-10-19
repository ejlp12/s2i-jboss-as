echo "---> Delete all resources with selector 'app=helloapp' and name 's2i-jboss-as-711'"
oc login -u system:admin > /dev/null
oc delete all --selector app=helloapp
oc delete is s2i-jboss-as-711 -n openshift
oc delete bc s2i-jboss-as-711 -n openshift

# Should we delete this? 
oc delete is base-centos7 -n openshift

echo "---> Delete all images with has name 's2i-jboss-as-711'"
for img in $(oc get images |grep s2i-jboss-as-711 | awk '{print $1}'); do oc delete images $img; done


