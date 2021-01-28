helm template demov3 ./helm --namespace demo --set image.tag=v3 --set image.weight=1 |k apply -f - -n demo


k port-forward svc/ambassador-admin 8877