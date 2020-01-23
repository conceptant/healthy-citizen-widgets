if [ ! -f "/adp-backend-v5/model/public/public-read-me" ]; then
  cp -r /Healthy-Citizen-Code/adp-backend-v5/model/public/* /adp-backend-v5/model/public
  cp -r /www/* /adp-backend-v5/model/public
fi
cat /config_templates/ha-dev-be.env | envsubst > /adp-backend-v5/.env
cat /config_templates/ha-dev.env | envsubst > /ha-dev/.env
cat /config_templates/hc-widget.env | envsubst > /hc-widget/.env && \
cd /hc-widget
npm run build
cp /hc-widget/dist/* /adp-backend-v5/model/public
cd /ha-dev
npm run build
cd /
pm2-runtime start /pm2.json