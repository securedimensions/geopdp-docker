# geopdp-docker
Dockerized GeoPDP service processing GeoXACML authorization decision requests

## Description
This project enables you to build a docker container that acts as a geoPDP for the 
[geopep Apache2 reverse proxy container](https://github.com/securedimensions/geopep-apache2-reverse-proxy) 
(geoPEP) available from [Secure Dimensions](https://www.secure-dimensions.de).

How to build and run a docker container for the 'geoPEP' is described [here](https://github.com/securedimensions/geopep-apache2-reverse-proxy).

## Build the docker image
The geoPDP is an extension to the Thales AuthzForce PDP that is implemented in Java. We therefore deploy the geoPDP as an extension
to the Thales implementation.

The docker image uses the 'tomcat' template.

Change directory to where you like to clone this repository. For the ease of description, let's assume that this is '/opt'.

Now, clone this repository with
```
git clone https://github.com/securedimensions/geopdp-docker.git
```

Then, build the docker image with:
```
docker build --tag geopdp .
```

## Creating the 'geopdp' container to listen on HTTP
You need to adopt the listen port to meet your environment. The command below will make the geoPDP listen on port 8080.
Please note: If you change the port you MUST change the port in the virtualhosts configuration file of the 'geopep-apache2-reverse-proxy'!
```
docker create --name geopdp -p8080:8080 -v /opt/geopdp-docker/tomcat/logs:/usr/local/tomcat/logs geopdp
```

## Start/stop the geoPDP
You can simply start the geopdp with:
````
docker container start geopdp
````
You can determine a successful startup using the 'netstat' command.

You can simply stop the geopdp with:
````
docker container stop geopdp
````
## The geoPDP policy
The executed geoPDP operates on an example GeoXACML policy that acts on OGC Web Map Service. Requests for any other OGC service result in a PERMIT decision which will cause the geoPEP to permit the Apache reverse proxy to process the intercepted request.

For WMS requests, the policy will return different responses based on the WMS operation. Each response will cause the geoPEP to function differently. For this example setup, only image redaction is triggered from the policy:
* WMS / GetMap or WMTS/GetTile request: A request will cause the GeoPDP to return Permit+Obligation. The Obligation has the identifier "Image-Redact" and a MultiPolygon that defines the area to be redacted. The Policy acts on WMS/WMTS requests using EPSG:4326 and EPSG:3857 spatial reference systems.

This example project uses the tomcat8 jre8 docker template.
geometry. The geoPEP will use the information to redact the map image in the given geometry before sending it to the client.

## More information
For more information please [contact us](mailto:support@secure-dimensions.de).
