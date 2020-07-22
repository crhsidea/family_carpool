# family_carpool

A new Flutter application.

## Getting Started

Make sure to have maven and docker set up and running on your computer to run this application. 

To get the app up and running, download the apk and install on your device. 

Then run the following command (docker) in your main terminal to spin up the postgresql server - 

`docker run --ulimit memlock=-1:-1 -it --rm=true --memory-swappiness=0            --name postgres-quarkus-reactive -e POSTGRES_USER=quarkus_test            -e POSTGRES_PASSWORD=quarkus_test -e POSTGRES_DB=quarkus_test            -p 5432:5432 postgres:11.2`

**Note make sure that docker is running, and that you have it installed

Once you have done that, then just go into your project directory, navigate into the quarkus project with `cd quarkus-server/`.

Finally use `mvn quarkus:dev` to run the server. 

To get the app up and running with test data, open the app, and tap the menu icon in the bottom right. This will open a prompt to enter in your local ip, or ipv4. Simply find your ipv4 address by going to your network settings, and then type it in (eg. 192.168.0.20), this will link your quarkus server to your app. Then go ahead and register for a new account with the register button, this will start you off with a clean slate. If you would like to start off with this then you are set, otherwise, to load in a bunch of test data, click the plus button in the top right of the home page. This will open a new prompt with a button that says something about loading data to the database. Go ahead and click it, and add an address to start off, it will auto-generate data for you. At the moment, all the test addresses are in Katy, Texas, but you can feel free to type in any address you want, it might just generate routes with ridiculous ETA! 23440 Cinco Ranch Blvd, Katy, TX is a good starting point if you want some realistic ETAs. 
