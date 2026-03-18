To create a 3 node Oracle NOSql [ On one node ] cluster follow the below steps

1. Check out the repo or download as zip
2. Install docker-ce, and docker-compose plugin
3. To start the cluster 
   docker compose up --build [ first time ]
   docker compose up [ subsequent runs ]

4. To stop the cluster
   docker compose down
5. To check the logs
   docker compose logs
6. To access oracle nosql cli
   docker exec -it nosql-sn1 bash
   java -jar lib/kvstore.jar runadmin -host sn1 -port 5000

Note : - This is a pure dev env. The cluster is already built and uploaded in repo. If you want to create a fresh cluster again follow below steps

1. rm -rf sn*/*
2. Adjust the memory and cpu in start-sna.sh
3. docker compose up --build
4. docker exec -it nosql-sn1 bash
5. java -jar lib/kvstore.jar runadmin -host sn1 -port 5000
6. load -file configure.sql
