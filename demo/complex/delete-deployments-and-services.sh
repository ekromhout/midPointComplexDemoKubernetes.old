#!/bin/bash
kubectl delete -f directory-deployment.yaml
kubectl delete -f directory-service.yaml
kubectl delete -f grouper-data-deployment.yaml
kubectl delete -f grouper-data-service.yaml
kubectl delete -f grouper-daemon-deployment.yaml
kubectl delete -f grouper-ui-deployment.yaml
kubectl delete -f grouper-ui-service.yaml
kubectl delete -f idp-deployment.yaml
kubectl delete -f idp-service.yaml
kubectl delete -f sources-deployment.yaml
kubectl delete -f sources-service.yaml
kubectl delete -f mq-deployment.yaml
kubectl delete -f mq-service.yaml
kubectl delete -f midpoint-data-deployment.yaml
kubectl delete -f midpoint-data-service.yaml
kubectl delete -f midpoint-server-deployment.yaml
kubectl delete -f midpoint-server-service.yaml
