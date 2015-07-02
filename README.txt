This project is done by Lijia Xie, Huiyuan Zhang and Mizan Rahman.
In this project, there two parts scripts, one is .xml for MOVE in folder MOVE, the other one includes ns2 scripts and awk scripts.
In MOVE folder, issue a "java -jar MOVE.jar" command to start MOVE, and load xml files to recreate traffic model. But, SUMO is needed to run .sumo.cfg files.
In default folder, issue a "./go" command to start simulation. Actually, I use 6 ns2 scripts to do experiment. Since I use AODV and DSDV protocols, scripts like aodv_vehicleX.tcl are doing AODV simlutions using various number of vehicles, scripts like dsdv_vehicleX.tcl are doing DSDV simlutions using various number of vehicles. For example,  aodv_vehicle5.tcl uses 10 vehicles to simulate, aodv_vehicle10.tcl uses 20 vehicles, aodv_vehicle15.tcl uses 30 vehicles. So does dsdv_vehicleX.tcls.
After simulation, 6 trace files named like aodv_vehicleX.tr or dsdv_vehicleX.tr are generated with .nam files. Also, thru_aX.out, tcpsend_aX.out, TCPstats_aX.out, TCPstats_dX.out where X=5,10,15 are generated. For example, TCPstats_a10.out is stats from aodv_vehicle10.tcl, TCPstats_d5.out from dsdv_vehicle5.tcl. People can use nam to 
From TCPstats.out file, we can get average throughput which is the 9th number. In tcpstatsformat.txt, there is detailer introduction.
Issue a command "awk -f e2edelay.awk aodv_vehicle10.tr" can get end-to-end delay for a TCP connection in a 20 nodes network using AODV. So, issue this command with different .tr files can get all end-to-end delays.
Issue a command "awk -f packetdeliver.awk dsdv_vehicle5.tr" can  get packet delivery ratio for a TCP connection in a 10 nodes network using DSDV. Issue this command with different .tr files.
For thru_aX.out or thru_dX.out where X=5,10,15, they can be used to draw receiving throughput.
For tcpsend_aX.out or tcpsend_dX.out where X=5,10,15, they can be used to draw tcp sending rate.

