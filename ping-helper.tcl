#######################
# TCL routines for the Ping  and Loss_mon application
########################

set PING_DEBUG 0

######################################
# Global variables for Ping 
######################################
set lastPingReceived 0
set totalPings 0
set totalPingDrops 0

####################################################################################
#function : startPingProcess
####################################################################################
proc startPingProcess { ns pinger interval} {
  proc doPing {ns  mypinger myinterval} {
    global totalPings totalPingDrops PING_DEBUG 

#    set $totalPings [expr $totalPings + 1.0]
    incr totalPings
    if {$PING_DEBUG == 1} {
      puts "Ping:([$ns now]): Sending a new ping..  total sent:  $totalPings;  total dropped: $totalPingDrops"
    }


    $mypinger send
#    $ns at [expr [$ns now]  + $myinterval + [uniform .1 .5]] "doPing $ns $mypinger  $myinterval"
    $ns at [expr [$ns now]  + $myinterval + [uniform .001 .009]] "doPing $ns $mypinger  $myinterval"
  }
  $ns at 0.0 "doPing $ns $pinger $interval"
}


proc doPingStats {} {
  global totalPings totalPingDrops PING_DEBUG 

#dump ping statistics
#        puts "Ping:  total sent:  $totalPings ;  total dropped: $totalPingDrops "
#        set lossRate  1.1
#puts "what is :  $lossRate"
        set lossRate [expr $totalPingDrops * 1.0 / $totalPings * 1.0]
        puts "Ping:  total sent:  $totalPings;  total dropped: $totalPingDrops;  loss rate percentage: [expr $lossRate * 100] percent"
}


Agent/Ping instproc recv {from snum rtt} {
   global ns lastPingReceived p1 totalPingDrops PING_DEBUG

    if {$PING_DEBUG == 1} {
      puts "Ping:recv([$ns now]): entered with  snum:   $snum and rtt: $rtt"
    }

#
   set pingtrace [open ping1.out a]

   if  { $snum > 0} {
   if  { [expr $lastPingReceived + 1]  != $snum } {
    set DIFF  [expr $snum - $lastPingReceived -1]
    incr totalPingDrops
    if {$PING_DEBUG == 1} {
      puts "Ping:recv([$ns now]):Dropped 1 snum:   $snum ,  lastPingReceived: $lastPingReceived (DIFF=$DIFF)"
    }
    set lastPingReceived  [expr $lastPingReceived + 1]
    puts $pingtrace "[$ns now] 0 $lastPingReceived"

    #get here if we lost 2 consecutive ping's
    if  { [expr $lastPingReceived + 1]  != $snum } {
      incr totalPingDrops
      if {$PING_DEBUG == 1} {
        puts "Ping:recv([$ns now]):Dropped 2 snum:   $snum ,  lastPingReceived: $lastPingReceived"
      }
      set lastPingReceived  [expr $lastPingReceived + 1]
      puts $pingtrace "[$ns now]   0 $lastPingReceived"

      #get here if we lost 3 consecutive ping's
      if  { [expr $lastPingReceived + 1]  != $snum } {
        if {$PING_DEBUG == 1} {
          puts "Ping:recv([$ns now]):Dropped 3 snum:   $snum ,  lastPingReceived: $lastPingReceived"
        }
        incr totalPingDrops

        set lastPingReceived  [expr $lastPingReceived + 1]
        puts $pingtrace "[$ns now]   0 $lastPingReceived"

        if  { [expr $lastPingReceived + 1]  != $snum } {
          incr totalPingDrops
          if {$PING_DEBUG == 1} {
            puts "Ping:recv:([$ns now]):Dropped 4 snum:   $snum ,  lastPingReceived: $lastPingReceived"
          }
          set lastPingReceived  [expr $lastPingReceived + 1]
          puts $pingtrace "[$ns now]   0 $lastPingReceived"
        }
      }
    }
   }
   }
   set lastPingReceived $snum

#so do the next ping right away instead of every interval
#so the ping flood mode....
#note:  I need a timeout to make this work...
#   set pingDelay .001
#   $ns at [expr [$ns now] + $pingDelay] "$p1 send"

   $self instvar node_
    puts $pingtrace "[$ns now] $rtt $lastPingReceived"
   close $pingtrace
}


#######################
# TCL routines for the Loss_mon application
########################

######################################
# Global variables 
######################################
set lastLpktReceived 0
set totalLpkts 0
set totalLpktDrops 0


####################################################################################
#function :  the two start routines for the Loss_mon application
#   This loops for each burst of packets to be sent.
#   The Loss_mon server receives the packet and then echos it back. 
#   See the recv method in ~/apps/loss_monitor.cc
####################################################################################

proc startLburstProcessORIGINAL { ns loss_mon burst_size inter_burst_delay inter_pkt_delay end_time} {
   set cur_time [expr [$ns now]]
#   puts "startLburst($cur_time) endTime:$end_time,  burstsize:$burst_size, interburstdelay:$inter_burst_delay, pktdelay:$inter_pkt_delay"
   while { $cur_time < $end_time } {

   $ns at $cur_time "startLpktProcess $ns $loss_mon $burst_size $inter_pkt_delay"
    set cur_time [expr $cur_time + $inter_burst_delay]
   }

}


#
# This proc starts loss_mon process:
#
#       This loops for each burst of packets to be sent.
#       The loss_mon server receives the packet and then echos it back.
#       See the recv method in ~/apps/loss_monitor.cc
#
#       burst-size: how many packets in a burst
#       inter_burst_delay: specifies the time between bursts
#       inter_pkt_delay: within a burst, this specifies the separation between transmissions. 
#          If set to 0, then a burst-size number of packets will be sent at effectively the same time.
#
#       This schedules the first burst transmissions. Then schedules doLburst to run later for the next burst.
#
proc startLburstProcess { ns loss_mon burst_size inter_burst_delay inter_pkt_delay end_time} {
        proc doLburst { ns loss_mon burst_size inter_burst_delay inter_pkt_delay end_time } {

                global totalLpkts

                set now_time [expr [$ns now]]
                #puts "doLburst:  ($loss_mon, $now_time) burstsize: $burst_size, burst_delay: $inter_burst_delay"

                set burst_time [expr $now_time + 0.00000000001]
                for {set x 0} {$x < $burst_size} {incr x} {

                        #puts "doLburst: Loss_mon($loss_mon, $now_time): Scheduling a packet transmission, total Lpkts: $totalLpkts "

                        $ns at $burst_time "$loss_mon send"
                        incr totalLpkts

                        set burst_time [expr $burst_time + $inter_pkt_delay]
                }

                if {$now_time < $end_time} {
                        $ns at [expr $now_time + $inter_burst_delay] "doLburst $ns $loss_mon $burst_size $inter_burst_delay $inter_pkt_delay $end_time"
                }
        }

        $ns at 0.0 "doLburst $ns $loss_mon $burst_size $inter_burst_delay $inter_pkt_delay $end_time"
        #set now_time [expr [$ns now]]
        #puts "startLburstProcess curr_time: $now_time;  endTime:$end_time,  burstsize:$burst_size, interburstdelay:$inter_burst_delay, pktdelay:$inter_pkt_delay"
}




####################################################################################
#function :   This loops for each packet in a burst.
####################################################################################
proc startLpktProcessORIGINAL { ns loss_mon burst_size inter_pkt_delay } {
   global totalLpkts
#   puts "startLpktProcess([$ns now]) burstsize:$burst_size, pktdelay:$inter_pkt_delay"
   set cur_time [expr [$ns now]]
    for {set x 0} {$x < $burst_size} {incr x} {
#      puts "Loss_mon([$ns now]): Scheduling a packet transmission, total Lpkts:  $totalLpkts "

      $ns at $cur_time "$loss_mon send"
      incr totalLpkts
      set cur_time [expr $cur_time + $inter_pkt_delay]
    }
}

Agent/VOIP_mon instproc recv {from snum rtt ID} {
   global ns lastLpktReceived totalLpktDrops

  set cur_time [expr [$ns now]]

#   puts "Loss_mon($cur_time))($ID): Received snum :   $snum"
  if { $ID == 1 } {
     set Lpkttrace [open LMpingUS.out a]

#   puts "Loss_mon($cur_time)($ID): Received snum :   $snum"
#    puts "Loss_mon($cur_time): Received snum :   $snum"

   if  { [expr $lastLpktReceived + 1]  != $snum } {
    incr totalLpktDrops
#    puts "Loss_mon:Dropped first snum :   $snum"
    set lastLpktReceived  [expr $lastLpktReceived + 1]
       puts $Lpkttrace "[$ns now] 0 $lastLpktReceived $ID"

    #get here if we lost 2 consecutive Lpkt's
    if  { [expr $lastLpktReceived + 1]  != $snum } {
      incr totalLpktDrops
#       puts "Loss_mon:Dropped second snum:   $snum"
      set lastLpktReceived  [expr $lastLpktReceived + 1]
       puts $Lpkttrace "[$ns now]   0 $lastLpktReceived $ID"

      #get here if we lost 3 consecutive Lpkt's
      if  { [expr $lastLpktReceived + 1]  != $snum } {
#       puts "Loss_mon:Dropped third snum:   $snum"
        set lastLpktReceived  [expr $lastLpktReceived + 1]
         puts $Lpkttrace "[$ns now]   0 $lastLpktReceived $ID"
      }
    }

   }
   set lastLpktReceived $snum
   $self instvar node_
     puts $Lpkttrace "[$ns now] $rtt $lastLpktReceived $ID"
     close $Lpkttrace
  }

  if { $ID == 2 } {
     set Lpkttrace [open LMpingDS.out a]

    set cur_time [expr [$ns now]]
#   puts "Loss_mon($cur_time)($ID): Received snum :   $snum"
#    puts "Loss_mon($cur_time): Received snum :   $snum"

   if  { [expr $lastLpktReceived + 1]  != $snum } {
    incr totalLpktDrops
#    puts "Loss_mon:Dropped first snum :   $snum"
    set lastLpktReceived  [expr $lastLpktReceived + 1]
       puts $Lpkttrace "[$ns now] 0 $lastLpktReceived $ID"

    #get here if we lost 2 consecutive Lpkt's
    if  { [expr $lastLpktReceived + 1]  != $snum } {
      incr totalLpktDrops
#       puts "Loss_mon:Dropped second snum:   $snum"
      set lastLpktReceived  [expr $lastLpktReceived + 1]
       puts $Lpkttrace "[$ns now]   0 $lastLpktReceived $ID"

      #get here if we lost 3 consecutive Lpkt's
      if  { [expr $lastLpktReceived + 1]  != $snum } {
#       puts "Loss_mon:Dropped third snum:   $snum"
        set lastLpktReceived  [expr $lastLpktReceived + 1]
         puts $Lpkttrace "[$ns now]   0 $lastLpktReceived $ID"
      }
    }

   }
   set lastLpktReceived $snum
   $self instvar node_
     puts $Lpkttrace "[$ns now] $rtt $lastLpktReceived $ID"
     close $Lpkttrace
  }
}



