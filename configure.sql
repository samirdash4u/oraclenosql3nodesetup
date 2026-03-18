configure -name mystore
plan deploy-zone -name "Bangalore" -rf 1 -wait
show topology
plan deploy-sn -zn zn1 -host sn1 -port 5000 -wait
plan deploy-admin -sn sn1 -wait
pool create -name BangalorePool
pool join -name BangalorePool -sn sn1
plan deploy-sn -zn zn1 -host sn2 -port 5000 -wait
pool join -name BangalorePool -sn sn2
plan deploy-sn -zn zn1 -host sn3 -port 5000 -wait
pool join -name BangalorePool -sn sn3
topology create -name topo -pool BangalorePool -partitions 6
plan deploy-topology -name topo -wait
