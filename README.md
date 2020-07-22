# family_carpool

A new Flutter application.

## Getting Started

To get the app up and running, download the apk and install on your device. 

Then run the following command (docker) in your main terminal to spin up the postgresql server - 

`docker run --ulimit memlock=-1:-1 -it --rm=true --memory-swappiness=0            --name postgres-quarkus-reactive -e POSTGRES_USER=quarkus_test            -e POSTGRES_PASSWORD=quarkus_test -e POSTGRES_DB=quarkus_test            -p 5432:5432 postgres:11.2`
