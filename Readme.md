# OpenOps

kubectl create ns openops

kubectl apply -f ./common

kubectl apply -f ./postgresql
kubectl apply -f ./redis


kubectl apply -f ./tables
kubectl apply -f ./analytics

kubectl apply -f ./app
kubectl apply -f ./engine

kubectl apply -f ./nginx


## OpenOPS
https://openops.vicrem.se/sign-in

User: $OPS_OPENOPS_ADMIN_EMAIL
Passwd: see_secret


## Analytics url
https://openops.vicrem.se/openops-analytics/login

User: admin
Passwd: see_secret
