#!/bin/bash
#kubectl apply -f directory-deployment.yaml
#kubectl apply -f directory-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/directory directory
#kubectl apply -f grouper-data-deployment.yaml
#kubectl apply -f grouper-data-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/complex_grouper_data grouper_data
#kubectl apply -f grouper-daemon-deployment.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/complex_grouper_daemon grouper_daemon
#kubectl apply -f grouper-ui-deployment.yaml
#kubectl apply -f grouper-ui-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/complex_grouper_ui grouper_ui
#kubectl apply -f idp-deployment.yaml
#kubectl apply -f idp-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/idp idp
#kubectl apply -f sources-deployment.yaml
#kubectl apply -f sources-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/sources sources
#kubectl apply -f mq-deployment.yaml
#kubectl apply -f mq-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/mq mq
#kubectl apply -f midpoint-data-deployment.yaml
#kubectl apply -f midpoint-data-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/complex_midpoint_data midpoint_data
#kubectl apply -f midpoint-server-deployment.yaml
#kubectl apply -f midpoint-server-service.yaml
gcloud builds submit --tag gcr.io/rcgrant-kromhout-test/complex_midpoint_server midpoint_server
