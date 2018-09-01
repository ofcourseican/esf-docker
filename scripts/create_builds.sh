#!/usr/bin/env bash

DATE=$(date +%Y%m%d)

#amd64 build
docker build --build-arg ARCH=amd64 -t frooop/esf:amd64-latest -t frooop/esf:amd64-${DATE} .

if [ $? == 0 ]; then
  docker push frooop/esf:amd64-latest
  docker push frooop/esf:amd64-${DATE}
fi

#arm build
docker build --build-arg ARCH=arm32v7 -t frooop/esf:arm32v7-latest -t frooop/esf:arm32v7-${DATE} .

if [ $? == 0 ]; then
  docker push frooop/esf:arm32v7-latest
  docker push frooop/esf:arm32v7-${DATE}
fi

#manifests
docker manifest create --amend frooop/esf:latest frooop/esf:arm32v7-latest frooop/esf:amd64-latest
docker manifest create --amend frooop/esf:${DATE} frooop/esf:arm32v7-${DATE} frooop/esf:amd64-${DATE}

docker manifest annotate frooop/esf:latest frooop/esf:arm32v7-latest --os linux --arch arm --variant v7
docker manifest annotate frooop/esf:latest frooop/esf:amd64-latest --os linux --arch amd64

docker manifest annotate frooop/esf:${DATE} frooop/esf:arm32v7-${DATE} --os linux --arch arm --variant v7
docker manifest annotate frooop/esf:${DATE} frooop/esf:amd64-${DATE} --os linux --arch amd64

docker manifest push --purge frooop/esf:latest
docker manifest push --purge frooop/esf:${DATE}
