if [ ! -f "/hc/adp-backend-v5/model/public/public-read-me" ]; then
  cp -r /Healthy-Citizen-Code/adp-backend-v5/model/public/* /hc/adp-backend-v5/model/public
  cp -r /www/* /hc/adp-backend-v5/model/public
fi
cat /config_templates/ha-dev-be.env | envsubst > /hc/adp-backend-v5/.env
cat /config_templates/ha-dev.env | envsubst > /hc/ha-dev/.env
cat /config_templates/hc-widget.env | envsubst > /hc/hc-widget/.env
cd /hc/hc-widget
npm run build
cp /hc/hc-widget/dist/* /hc/adp-backend-v5/model/public
cd /hc/ha-dev
npm run build
cd /hc
pm2-runtime start /pm2.json