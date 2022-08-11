#cat containers_restart.sh
#!/bin/sh
if [[ -z "${UMP_HOST_NAME}" ]]; then
echo 'UMP_HOST_NAME' is not defined, Please make sure UMP_HOST_NAME is defined be
exit -1
fi
#
if [[ -z "${HNM_REGION}" ]]; then
export HNM_REGION=EAST
fi
#
HOME_DIR=/apps/opt/hnm
CB_SERVER_LOGS=$HOME_DIR/cb-server/logs
#
IMG_PFX=hnm-docker-np.oneartifactoryprod.verizon.com/nts/hnmv/hnm2
#
mkdir -p $CB_SERVER_LOGS
chmod 777 $CB_SERVER_LOGS
#
#Run the callback server
CNAME='cb-server'
docker stop $CNAME
docker rm $CNAME
IMG=$IMG_PFX/cb_server:latest
#
docker run -v $CB_SERVER_LOGS:/apps/logs \
--network=ump-net -d --name $CNAME -h "${CNAME}.${UMP_HOST_NAME}" --restart=unle
#
#Run the hnm2 app server
CNAME='hnm-apps'
docker stop $CNAME
docker rm $CNAME
IMG=$IMG_PFX/hnm-apps:latest
#
docker run --env-file $HOME_DIR/env.vars \
-e "UMP_CB_SERVER=https://$UMP_HOST_NAME" -e UMP_HOST_NAME -e HNM_REGION \
-v $HOME_DIR/app/logs:/apps/opt/hnm2/logs \
--network=ump-net -d --name $CNAME -h "hnm-1.${UMP_HOST_NAME}" --restart=unless-
#
#Run the nginx front end server
CNAME=nginx
IMG=$IMG_PFX/nginx:latest
docker stop $CNAME
docker rm $CNAME
docker run -v /apps/opt/ssl-certs:/ssl-certs -p 443:8443 \
--network=ump-net -d --name $CNAME -h "${CNAME}.${UMP_HOST_NAME}" --restart=unle
#
echo 'All processes started at ' `date`
