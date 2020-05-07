This repository provides files for building docker image of Healthy Citizen Widgets

Example usage:

docker run -d -v /tmp/hc/log:/var/log/hc -v /tmp/hc/public:/hc/adp-backend-v5/model/public -v /tmp/hc/data:/data -p 8000:8000 --env-file=.env --name hc conceptant/healthy-citizen-widgets:latest 

- 8000 - the port on which the backend will run
- /data/log - where the logs will be stored
- /data/public - if you want to add more files to the distribution then put them here. Expose this folder via your web server
- .env - use example.env to create your own .env file and provide environment

For debugging:  docker run --env-file=.env --name hc -it -v /tmp/hc/log:/var/log/hc -v /tmp/hc/public:/hc/adp-backend-v5/model/public -p 8000:8000 conceptant/healthy-citizen-widgets:latest bash
For tunnel from hc container into the database:  ssh amikhalchuk@conceptant3.conceptant.com -p 11022 -L 27017:172.17.0.1:27017

