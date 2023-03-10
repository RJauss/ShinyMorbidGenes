# ShinyMorbidGenes
Docker-compose.yml creates two images:

1. MySQL Image with Bernt's version
2. Morbigenes_app is a simple Shiny app

The folder "app" contains the R-Script for the shiny app and the credentials for the DB

The Dockerfile contains specifications for the shiny app. It runs on port 3838, the database runs on 9918:3306. 

We need the DB files from /home/morbidgenes/morbidgenes_db/data/mysql/ to get the app running. These files are generated separately and are not part of this repository

