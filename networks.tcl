proc AgentTraceThroughput { ns  AgentSrc interval fname } {

set x [ $AgentSrc set agentSinkThroughput ]
puts "AgentTrace is  $x"


	proc AgentThroughputdump { ns newsrc interval fname } {
set x [ $newsrc set agentSinkThroughput ]
puts "AgentTrace: agentSinkThroughput  is  $x"
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "AgentThroughputdump $ns $newsrc $interval $fname"
          puts [$ns now]/throughput-bytes=[$newsrc set agentSinkThroughput]
#          puts [ns now]/throughput=[expr ( ([$newsrc set agentSinkThroughput]/ $interval) * 8) ]
           set mythroughput [expr ( ([$newsrc set agentSinkThroughput]/ $interval) * 8) ]
#          puts "TraceThroughput:  [$ns now]  $mythroughput"
           puts $f "[$ns now]  $mythroughput"
          flush $f
#JJM          $newsrc set agentSinkThroughput 0
          close $f
	}
	$ns at 0.0 "AgentThroughputdump $ns $AgentSrc $interval $fname"


}

proc UDPTraceThroughput { ns  AgentSrc interval fname } {

	proc UDPThroughputdump { ns newsrc interval fname } {
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "UDPThroughputdump $ns $newsrc $interval $fname"
#          puts [$ns now]/throughput-bytes=[$newsrc set UDPSinkThroughput]
#          puts [ns now]/throughput=[expr ( ([$newsrc set UDPSinkThroughput]/ $interval) * 8) ]
           set mythroughput [expr ( ([$newsrc set UDPSinkThroughput]/ $interval) * 8) ]
#          puts "TraceThroughput:  [$ns now]  $mythroughput"
           puts $f "[$ns now]  $mythroughput"
          flush $f
          $newsrc set UDPSinkThroughput 0
          close $f
	}
	$ns at 0.0 "UDPThroughputdump $ns $AgentSrc $interval $fname"
}

#same as TCPTraceSendRate, just doesnt need the ns param
proc TraceTCPSendRate { AgentSrc interval fname } {

        set ns [Simulator instance]
	proc TraceTCPSendRatedump { newsrc interval fname } {
          set ns [Simulator instance]
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "TraceTCPSendRatedump $newsrc $interval $fname"
#          puts [$ns now]/sendbytes=[$newsrc set TCPSendBytes]
#          puts [ns now]/sendrate=[expr ( ([$newsrc set TCPSendBytes]/ $interval) * 8) ]
           set bytesSent [$newsrc set TCPSendBytes]
           set mythroughput [expr ( ($bytesSent/ $interval) * 8) ]
#           set mythroughput [expr ( ([$newsrc set TCPSendBytes]/ $interval) * 8) ]
#          puts "TraceTCPSendrate:  [$ns now]  $mythroughput"
           puts $f "[$ns now]  $mythroughput $bytesSent"
          flush $f
          $newsrc set TCPSendBytes 0
          close $f
	}
	$ns at 1.0 "TraceTCPSendRatedump $AgentSrc $interval $fname"
}


proc TCPTraceSendRate { ns  AgentSrc interval fname } {

	proc TCPSendRatedump { ns newsrc interval fname } {
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "TCPSendRatedump $ns $newsrc $interval $fname"
#          puts [$ns now]/sendbytes=[$newsrc set TCPSendBytes]
#          puts [ns now]/sendrate=[expr ( ([$newsrc set TCPSendBytes]/ $interval) * 8) ]
           set bytesSent [$newsrc set TCPSendBytes]
           set mythroughput [expr ( ($bytesSent/ $interval) * 8) ]
#           set mythroughput [expr ( ([$newsrc set TCPSendBytes]/ $interval) * 8) ]
#          puts "TraceTCPSendrate:  [$ns now]  $mythroughput"
           puts $f "[$ns now]  $mythroughput $bytesSent"
          flush $f
          $newsrc set TCPSendBytes 0
          close $f
	}
	$ns at 0.0 "TCPSendRatedump $ns $AgentSrc $interval $fname"
}

proc UDPTraceSendRate { ns  AgentSrc interval fname } {

	proc UDPSendRatedump { ns newsrc interval fname } {
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "UDPSendRatedump $ns $newsrc $interval $fname"
#          puts [$ns now]/sendbytes=[$newsrc set UDPSendBytes]
#          puts [ns now]/sendrate=[expr ( ([$newsrc set UDPSendBytes]/ $interval) * 8) ]
           set mythroughput [expr ( ([$newsrc set UDPSendBytes]/ $interval) * 8) ]
#          puts "TraceUDPSendrate:  [$ns now]  $mythroughput"
           puts $f "[$ns now]  $mythroughput"
          flush $f
          $newsrc set UDPSendBytes 0
          close $f
	}
	$ns at 0.0 "UDPSendRatedump $ns $AgentSrc $interval $fname"
}




proc GetErrorModuleBytes { ns  ErrorModule interval fname } {

	proc ErrorModuleDump { ns Module interval fname } {
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "ErrorModuleDump $ns $Module $interval $fname"
#          puts [$ns now]/ErrorModulebytes=[$Module set totalBytes]
#          puts [ns now]/sendrate=[expr ( ([$Module set totalBytes]/ $interval) * 8) ]
           set  totalBytes [$Module set totalBytes]
           puts $f "$totalBytes"
#           puts $f "[$ns now]  $totalBytes"
          flush $f
          $Module set totalBytes 0
          close $f
	}
	$ns at 0.0 "ErrorModuleDump $ns $ErrorModule $interval $fname"
}

proc TraceErrorModuleUtilization { ns ErrorModule interval linkID stoptime} {

	proc ErrorModuleUtilizationDump { ns Module interval } {
#          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "ErrorModuleUtilizationDump $ns $Module $interval"
           set totalBytes [$Module set totalBytes]

           set totalOnCount [$Module set totalOnCount]
           set totalOffCount [$Module set totalOffCount]
#          puts "[$ns now]/onCount = $onCount"
#          puts "[$ns now]/offCount = $offCount"
#          puts "[$ns now]/totalOnCount = $totalOnCount"
#          puts "[$ns now]/totalOffCount = $totalOffCount"
#           set  totalUsage [expr $onCount+ $offCount]
#           set  utilSample  [expr $onCount/$totalUsage]
#           puts $f "$utilSample"
#           puts $f "[$ns now]  $utilSample"
#           puts "[$ns now]  $utilSample"
#          flush $f
          if {$totalBytes == 0} {
            $Module set totalOffCount [expr $totalOffCount + 1]
          } else {
            $Module set totalOnCount [expr $totalOnCount + 1]
            $Module set totalBytes 0
          }
#          close $f
	}
	$ns at 0.0 "ErrorModuleUtilizationDump $ns $ErrorModule $interval "
        $ns at $stoptime "ComputeModuleUtilization $ns $ErrorModule $linkID "
}

proc ComputeModuleUtilization { ns ErrorModule linkID} {

           set totalOnCount  [$ErrorModule set totalOnCount]
           set totalOffCount [$ErrorModule set totalOffCount]
           set sum [expr $totalOnCount+$totalOffCount]
           set totalOnCount  [expr $totalOnCount * 100]
           set util  0.001
           if {$sum > 0 } {
            set util [expr $totalOnCount / $sum]
            puts "Utilization ($linkID): $util% ($totalOnCount / $sum)"
           } else {
            puts "Utilization ($linkID):  ERROR,  zero sum ????"
           }
}



####################################################################################
#function : TraceThroughput
# 
#  Simply gets and clears TCPSink variables ...
#
#  Dumps the throughput in bytes per second
#
####################################################################################

proc TraceThroughput { ns  tcpsinkSrc interval fname } {
#puts "We will open TraceThroughput file $fname"

	proc Throughputdump { ns src interval fname } {
          set f [open $fname a]
          $ns at [expr [$ns now] + $interval] "Throughputdump $ns $src $interval $fname"
#          puts [$ns now]/throughput-bytes=[$src set sinkThroughput]
#          puts [ns now]/throughput=[expr ( ([$src set sinkThroughput]/ $interval) * 8) ]
           set mythroughput [expr ( ([$src set sinkThroughput]/ $interval) * 8) ]
#          puts "TraceThroughput:  [$ns now]  $mythroughput"
#To see just bps throughput..
#           puts $f "[$ns now]  $mythroughput"
#to see bits per second AND bytes
           set tmpBytes [$src set sinkThroughput]
           puts $f "[$ns now]  $mythroughput $tmpBytes"
          flush $f
          $src set sinkThroughput 0
          close $f
	}
	$ns at [$ns now] "Throughputdump $ns $tcpsinkSrc $interval $fname"
#	$ns at 0.0 "Throughputdump $ns $tcpsinkSrc $interval $fname"
}

#Trace tcp cx things periodically 
proc TraceTCP { ns  tcp interval fname  } {

	proc TCPdump { ns src interval fname } {
         set tmpwnd [$src set window_]
         set tmpcwnd [$src set cwnd_]
#         puts "JJM:  tmpwnd is $tmpwnd, cwnb is $tmpcwnd  "
         set f [open $fname a]
         $ns at [expr [$ns now] + $interval] "TCPdump $ns $src $interval $fname"
         puts $f "[$ns now]  $tmpwnd $tmpcwnd"
         flush $f
         close $f
	}
	$ns at 0.0 "TCPdump $ns $tcp $interval $fname"
}

#given a link, we need to get queue data ...
# this is a pain-  see ns-lib.tcl for the helper routines that do this
proc TraceQueueSize { ns label node1 node2 interval fname} {

  proc queuedump {ns mylabel node1 node2 myinterval fname } {
    set f [open $fname a]
    $ns at [expr [$ns now] + $myinterval] "queuedump $ns $mylabel $node1 $node2 $myinterval $fname"

    set cur_bytes [$ns get-queue-size $node1 $node2]
    set cur_pkts [$ns get-queue-length $node1 $node2]  
    set max_cur_bytes [$ns get-max-bytes $node1 $node2]  
    set min_cur_bytes [$ns get-min-bytes $node1 $node2]  
    set max_cur_pkts [$ns get-max-packets $node1 $node2]  
    set min_cur_pkts [$ns get-min-packets $node1 $node2]  
#    puts "link $mylabel cur_bytes:  $cur_bytes, cur_pkts: $cur_pkts"
#    puts "link $mylabel max_cur_bytes:  $max_cur_bytes, min_cur_bytes: $min_cur_bytes"
#    puts "link $mylabel max_cur_pkts:  $max_cur_pkts, min_cur_pkts: $min_cur_pkts"
    $ns set-max-packets $node1 $node2  $cur_pkts
    $ns set-min-packets $node1 $node2  $cur_pkts
#Because of the hack for TraceQueueDistribution,  don't modify the max-bytes or min-bytes
#    $ns set-max-bytes $node1 $node2  $cur_bytes
#    $ns set-min-bytes $node1 $node2  $cur_bytes
    puts $f "[$ns now]  $max_cur_pkts  $min_cur_pkts"
    close $f
  }
  $ns at 0.0 "queuedump $ns $label $node1 $node2  $interval $fname"
}

#trace the total bytes that leaves a queue, and calculate the utilization
#we assume the duration is current test time
proc TraceQueueTraffic { ns label node1 node2 interval fname linkspeed} {

  proc queuetrafficdump {ns mylabel node1 node2 myinterval fname mylinkspeed} {
    set f [open $fname a]
    $ns at [expr [$ns now] + $myinterval] "queuetrafficdump $ns $mylabel $node1 $node2 $myinterval $fname $mylinkspeed"

#    set curTime [$ns now]
    set curTime $myinterval
    if { $curTime != 0 } {
     set cur_bytes_in [$ns get-total-in $node1 $node2]
     set cur_bytes_out [$ns get-total-out $node1 $node2]
#     puts "TraceQueueTraffic: curTime is $curTime , cur bytes out = $cur_bytes_out"
     set max_out [expr $mylinkspeed * $curTime / 8.0]
     set util [expr $cur_bytes_out / $max_out + 0.0]
     set util [expr $util * 100]
#do the following if you want to reset the total out count.  Do this
#if measuring utilization on a period basis....
     $ns set-total-out $node1 $node2 0
#     puts "TraceQueueTraffic: max out is $max_out and util is $util"
     puts $f "[$ns now]  $cur_bytes_out $util%"
     close $f
    }
  }
  $ns at 0.0 "queuetrafficdump $ns $label $node1 $node2  $interval $fname $linkspeed"
}

#given a link, we need to get queue data ...
#JJM:  12/18/2002:  this is a better version of my old TraceQueueSize
# This operates on the Integral object that is the queue mon bytes integral monitor
# This computes the avg queue size  in bytes and the avg delay
proc TraceQueueMonSize { ns integ link label interval fname} {

  proc queuemondump {ns integ link mylabel  myinterval fname } {
    set f [open $fname a]
    $ns at [expr [$ns now] + $myinterval] "queuemondump $ns $integ $link $mylabel  $myinterval $fname"

    set qsize [$integ set sum_]
#    puts "qsize is $qsize"
    set delay [expr 8 * $qsize / [[$link link] set bandwidth_]]
#   puts "[$ns now] delay=$delay"

    if {$myinterval != 0} {
      puts $f "[$ns now]  [expr $qsize / $myinterval] $delay"
    } else {
       puts  " error"
    }
#    puts $f "[$ns now]  $qsize $delay"


#reset sum_
    $integ set sum_ 0.0

    close $f
  }
  $ns at 0.0 "queuemondump $ns $integ $link $label  $interval $fname"
}



proc printutilization { linkid qmon linkspeed duration packetsize} {

    set departures [$qmon set pdepartures_]
    set maxdeparts [expr $linkspeed *  $duration / $packetsize + 0.0]
puts "departures = $departures"
puts "maxdeparts = $maxdeparts"
    set util [expr $departures * 100 + 0.00]
    set util [expr $util / $maxdeparts +  0.00]

    puts "link $linkid link utilization is $util% "
}


#To get the % of protocols at a link...
#Turn on MONITOR in drop-tail.cc.
#we overload the following variables (i.e., we hack it):
# Note:  make sure that the TCP constructor issues a set_pkttype(PT_DCA)
#       of (PT_VEGAS).
#
#  qSize : # DCA flows
#  qLength : #Other TCP flows
#  maxQSize : # UDP
#  minQSize : # other flows
#
proc TraceQueueDistribution { ns label node1 node2 interval fname} {

  proc queuedistdump {ns mylabel node1 node2 myinterval fname } {
    set f [open $fname a]
    $ns at [expr [$ns now] + $myinterval] "queuedistdump $ns $mylabel $node1 $node2 $myinterval $fname"

    set cur_bytes [$ns get-queue-size $node1 $node2]
    set cur_pkts [$ns get-queue-length $node1 $node2]  
    set max_cur_bytes [$ns get-max-bytes $node1 $node2]  
    set min_cur_bytes [$ns get-min-bytes $node1 $node2]  

    $ns set-max-bytes $node1 $node2  0
    $ns set-min-bytes $node1 $node2  0
    $ns set-queue-size $node1 $node2 0
    $ns set-queue-length $node1 $node2  0
    puts $f  "$mylabel: [$ns now] $cur_bytes  $max_cur_bytes  $min_cur_bytes"
    close $f
  }
  $ns at 0.0 "queuedistdump $ns $label $node1 $node2  $interval $fname"
}



#########################################################################################
# GetLossModuleStats
#
#  This function gets the loss module's actual loss rate
#
#########################################################################################
#given a link, we need to get queue data ...
# this is a pain-  see ns-lib.tcl for the helper routines that do this
proc GetLossModuleStats { ns label loss} {

  set totalPkts [$loss set totalPkts]
  set totalDrops [$loss set totalDrops]
  set dropRate [expr $totalDrops / $totalPkts]
  puts "for Link $label, the packet loss rate was $dropRate "

}



#Helper  function to output link utilization and bw estimate
#2/18/99: Currently not working...
proc trace-util {ns linkhandle interval f} {
	if { $f != "" } {
         set l-est [$linkhandle load-est];
         set l-utl [$linkhandle link-utlzn];
         puts $f "[$ns now] $l-est  $l-utl" 
	}
	$ns at [expr [$ns now]+$interval] "trace-util $ns $linkhandle $interval $f" 
}

proc finish_new_run {file  fname } {


        exec rm -f temp.out
	set f [open temp.out w]
	puts $f "TitleText: $file"
	puts $f "Device: Postscript"
	puts $f \"throughput
	flush $f
	exec cat $fname >@ $f
	close $f
#        exec xgraph -bb -x time -y throughput temp.out 

}


proc dumpTCPStats {label tcp tcpsink outputFile} {
  set f [open $outputFile a]
  set bytesDel  [$tcpsink set numberBytesDelivered]
  set notimeouts   [expr [$tcp set nTimeouts_] + 0.0]
  set lossno [ expr [$tcp set nRexmits_] +  0.0]
  set drops [expr $lossno * 100]
  set arrivals [expr [$tcp set ack_] + $lossno + 0.0]
  if {$arrivals > 0} {
     set dropRate [expr $drops / $arrivals + 0.00]
   } else { 
     set dropRate 0
   }
   set toFreq 0.0
   if {$lossno > 0.0} {
#puts "notimeouts is $notimeouts and lossno is $lossno"
     set timeoutdrops [expr $notimeouts * 100]
     set toFreq [expr $timeoutdrops / $lossno + 0.00] 
   }
#   puts "$label $bytesDel $arrivals $lossno $dropRate $notimeouts $toFreq"
   puts $f "$label $bytesDel $arrivals $lossno $dropRate $notimeouts $toFreq"
   flush $f
   close $f
}


proc dumpFinalTCPStats {label starttime tcp tcpsink outputFile} {
  set f [open $outputFile a]
  set ns [Simulator instance]
  set bytesDel  [$tcpsink set numberBytesDelivered]
  set tmpTime [expr [$ns now] - $starttime] 
  set thruput [expr $bytesDel*8.0/$tmpTime + 0.0]
# puts "dumpFinalTCPStats: bytesDel is $bytesDel, tmpTime is $tmpTime and thruput is $thruput"
  set notimeouts   [expr [$tcp set nTimeouts_] + 0.0]
  set lossno [ expr [$tcp set nRexmits_] +  0.0]
  set drops [expr $lossno * 100]
  set arrivals [expr [$tcp set ack_] + $lossno + 0.0]
  if {$arrivals > 0} {
     set dropRate [expr $drops / $arrivals + 0.00]
   } else { 
     set dropRate 0
   }
   set toFreq 0.0
   if {$lossno > 0.0} {
#puts "notimeouts is $notimeouts and lossno is $lossno"
     set timeoutdrops [expr $notimeouts * 100]
     set toFreq [expr $timeoutdrops / $lossno + 0.00] 
   }
  set meanSampleCounter  [$tcp set FinalLossRTTMeanCounter]
  set TotalRTTSamples  [$tcp set FinalRTT]
  if {$meanSampleCounter > 0} {
    set meanRTT [expr $TotalRTTSamples / $meanSampleCounter + 0.00]
   } else { 
     set meanRTT 0
   }
#   puts "$label $bytesDel $arrivals $lossno $dropRate $meanRTT $notimeouts $toFreq $thruput  0 0 0"
#make the number of fields the same as with dumpFinalTFRC.... DO NOT CHANGE!!!! MATLAB needs this.
   puts $f "$label $bytesDel $arrivals $lossno $dropRate $notimeouts $toFreq $meanRTT $thruput 0 0 0"
   flush $f
   close $f

}

proc dumpTFRCStats {label trfc trfcsink outputFile} {
  set f [open $outputFile a]
  set bytesDel  [$trfcsink set numberBytesDelivered]
  set notimeouts   [expr [$tcp set nTimeouts_] + 0.0]
  set lossno [ expr [$tcp set nRexmits_] +  0.0]
  set drops [expr $lossno * 100]
  set arrivals [expr [$tcp set ack_] + $lossno + 0.0]
  if {$arrivals > 0} {
     set dropRate [expr $drops / $arrivals + 0.00]
   } else { 
     set dropRate 0
   }
   set toFreq 0.0
   if {$lossno > 0.0} {
#puts "notimeouts is $notimeouts and lossno is $lossno"
     set timeoutdrops [expr $notimeouts * 100]
     set toFreq [expr $timeoutdrops / $lossno + 0.00] 
   }
#   puts "$label $bytesDel $arrivals $lossno $dropRate $notimeouts $toFreq"
   puts $f "$label $bytesDel $arrivals $lossno $dropRate $notimeouts $toFreq"
   flush $f
   close $f
}

proc dumpFinalTFRCStats {label starttime trfc trfcsink outputFile} {
  set ns [Simulator instance]
  set f [open $outputFile a]
  set bytesDel  [$trfcsink set numberBytesDelivered]
  set tmpTime [expr [$ns now] - $starttime] 
  set thruput [expr $bytesDel*8.0/$tmpTime]
# puts "dumpFinalTFRCStats: bytesDel is $bytesDel, tmpTime is $tmpTime and thruput is $thruput"

  set packetSent  [$trfc set totalPktsSent]
  set totalLosses  [$trfc set totalLosses]
  set totalLossEvents  [$trfc set totalLossEvents]

  set meanSampleCounter  [$trfc set FinalLossRTTMeanCounter]
  set TotalLossEventRateSamples  [$trfc set FinalLossEventRate]
  set TotalRTTSamples  [$trfc set FinalRTT]
  set numberTOs  [$trfc set totalTimeouts]

  if {$totalLosses > 0.0} {
#puts "notimeouts is $notimeouts and lossno is $lossno"
     set timeoutdrops [expr $numberTOs * 100]
     set toFreq [expr $timeoutdrops / $totalLosses + 0.00]
  }


  if {$meanSampleCounter > 0} {
    set meanLER [expr $TotalLossEventRateSamples / $meanSampleCounter + 0.00]
    set meanRTT [expr $TotalRTTSamples / $meanSampleCounter + 0.00]
   } else { 
     set meanLER 0
     set meanRTT 0
   }
  set meanLER [expr $meanLER * 100]
  set totalLossRate [expr [expr $totalLosses*1.0]*100/$packetSent + 0.0]
  set totalLossEventRate [expr [expr $totalLossEvents*1.0]*100/$packetSent + 0.0]
  
#   puts "$label $bytesDel $packetSent $totalLosses $totalLossRate $numberTOs $toFreq $totalLossEvents $totalLossEventRate $numberTOs $meanLER $meanRTT $thruput"
#   puts "$label $bytesDel $packetSent $totalLosses $totalLossRate $numberTOs $toFreq $meanRTT $thruput $totalLossEvents $totalLossEventRate $meanLER"
   puts $f "$label $bytesDel $packetSent $totalLosses $totalLossRate $numberTOs $toFreq  $meanRTT $thruput $totalLossEvents $totalLossEventRate $meanLER"
   flush $f
   close $f
}


proc printpkts { label tcp } {
	puts "tcp $label total_packets_acked [$tcp set ack_]"
}

proc printbytesdelivered { label tcpsink } {
	puts "tcpsink  $label bytes delvered   [$tcpsink set numberBytesDelivered]"
}

proc printtimeouts { label tcp } {
	puts "tcp $label total_timeouts  [$tcp set nTimeouts_]"
}
proc printretrans { label tcp } {
	puts "tcp $label total_retransmits  [$tcp set nRexmits_]"
        set lossno [$tcp set nRexmits_]
        set drops [expr $lossno * 100]
        set arrivals [expr [$tcp set ack_] + $lossno + 0.0]
	puts "tcp $label total packets sent  $arrivals"
        if {$arrivals > 0} {
          set dropRate [expr $drops / $arrivals + 0.00]
        } else { 
          set dropRate 0
        }
          puts "tcp $label pkt drop rate is $dropRate% "
}

#prints the final stats from the pareto generator
proc printpareto { id paretoSource } {

    set totalPackets [$paretoSource set totalPackets]
    puts "pareto $id total packets  generated = $totalPackets"
}

#see ns-compat.tcl.  We do what linkhelper did as it caught link stats..
#in ns1.4, we used the link stats qmon support.
#here, the caller passes us a qmon object, we can reequest any
#of the info described by  the QueueMonitor class
proc printdrops { linkid qmon } {
    puts "Summary of qmon drops : "
    set drops [$qmon set pdrops_]
    set drops [expr $drops * 100 + 0.00]
    set arrivals [$qmon set parrivals_]
    if {$arrivals > 0} {
      set dropRate [expr $drops / $arrivals + 0.00]
    }
    puts "link $linkid  pkt drop rate is $dropRate% "
    puts "link $linkid total_drops [$qmon set pdrops_] "
    puts "link $linkid total_packets that arrived [$qmon set parrivals_]"
    puts "link $linkid total bytes that arrived [$qmon set barrivals_]"
    puts "link $linkid total bytes currently in queue  [$qmon set size_]"
    puts "link $linkid total packets currently in queue  [$qmon set pkts_]"
 
    puts "link $linkid total packets that departed  [$qmon set pdepartures_]"

}

proc TraceQueueLossRate { ns label qmon interval fname} {

  proc queuelossrate {ns mylabel myqmon myinterval fname } {
    set f [open $fname a]
    $ns at [expr [$ns now] + $myinterval] "queuelossrate $ns $mylabel $myqmon $myinterval $fname"

    set drops [$myqmon set pdrops_]
    set drops [expr $drops * 100 + 0.00]
    set arrivals [$myqmon set parrivals_]
    set dropRate 0
    if {$arrivals > 0} {
      set dropRate [expr $drops / $arrivals + 0.00]
    }


    $myqmon set pdrops_ 0
    $myqmon set bdrops_ 0
    $myqmon set parrivals_ 0
    $myqmon set barrivals_ 0
    puts $f "[$ns now]  $dropRate"
    set drops [$myqmon set pdrops_]

    close $f
  }
  $ns at 0.0 "queuelossrate $ns $label $qmon  $interval $fname"
}

#A better version of TraceQueueLossRate 
#This dumps the loss rate, the queue level over time
proc TraceQueueStats { ns label qmon interval fname} {

  proc queuestats {ns mylabel myqmon myinterval fname } {
    set f [open $fname a]
    $ns at [expr [$ns now] + $myinterval] "queuestats $ns $mylabel $myqmon $myinterval $fname"

    set size [$myqmon set size_]
    set drops [$myqmon set pdrops_]
    set drops [expr $drops * 100 + 0.00]
    set arrivals [$myqmon set parrivals_]
    set dropRate 0
    if {$arrivals > 0} {
      set dropRate [expr $drops / $arrivals + 0.00]
    }


    $myqmon set pdrops_ 0
    $myqmon set bdrops_ 0
    $myqmon set parrivals_ 0
    $myqmon set barrivals_ 0
    puts $f "[$ns now]  $dropRate $size"
    set drops [$myqmon set pdrops_]

    close $f
  }
  $ns at 0.0 "queuestats $ns $label $qmon  $interval $fname"
}



proc printutilization { linkid qmon linkspeed duration packetsize} {

    set departures [$qmon set pdepartures_]
    set maxdeparts [expr $linkspeed *  $duration / $packetsize + 0.0]
puts "departures = $departures"
puts "maxdeparts = $maxdeparts"
    set util [expr $departures * 100 + 0.00]
    set util [expr $util / $maxdeparts +  0.00]

    puts "link $linkid link utilization is $util% "
}

proc printstop { stoptime } {
	puts "stop-time $stoptime"
}


#
# Dump the queueing delay on the n0->n1 link
# to stdout every second of simulation time.
# Note:  This is not correct-  I want to be able to obtain the
#        avg packet waiting time and the link utilization.... TODO
#
proc dumpqueuedelay { ns qmon integ link interval } {
	$ns at [expr [$ns now] + $interval] "dumpqueuedelay $ns $qmon $integ $link $interval"
	set delay [expr 8 * [$integ set sum_] / [[$link link] set bandwidth_]]
	puts "[$ns now] delay=$delay"

        set sample [$qmon set pkts_]
        puts "dumpqueuedelay:  pkts size is $sample "
}



proc startPingProcess { ns pinger interval} {

  proc doPing {ns  mypinger myinterval} {
    global totalPings totalPingDrops

     

#      puts "doPing: rn:$randnumber;  myinterval: $myinterval;  total sent:  $totalPings;  total dropped: $totalPingDrops"

#    set $totalPings [expr $totalPings + 1.0]
    incr totalPings
#     puts "doPing:  total sent:  $totalPings;  total dropped: $totalPingDrops"


    $mypinger send
#JJM add randomness
    $ns at [expr [$ns now]  + $myinterval + [uniform .001 .009]] "doPing $ns $mypinger  $myinterval"
  }
  $ns at 0.0 "doPing $ns $pinger $interval"
}


#See code change in tcp.cc  traceVar to dump just time and rtt
proc setupTcpTracing { tcp tcptrace { sessionFlag false } } {
	if {$tcptrace == 0} {
		return
	}
	enableTcpTracing $tcp $tcptrace
}

proc enableTcpTracing { tcp tcptrace } {
	if {$tcptrace == 0} {
		return
	}
	$tcp attach $tcptrace
	$tcp trace "tcpRTT_" 
#	$tcp trace "t_seqno_" 
#	$tcp trace "rtt_" 
#	$tcp trace "srtt_" 
#	$tcp trace "rttvar_" 
#	$tcp trace "backoff_" 
#	$tcp trace "dupacks_" 
#	$tcp trace "ack_" 
#	$tcp trace "cwnd_"
#	$tcp trace "ssthresh_" 
#	$tcp trace "maxseq_" 
#	$tcp trace "seqno_"
#	$tcp trace "exact_srtt_"
#	$tcp trace "avg_win_"
#	$tcp trace "nrexmit_"
}

proc dumpFinalUDPStats {label starttime udpsink outputFile} {
  set f [open $outputFile a]
  set ns [Simulator instance]
  set bytesDel  [$udpsink set UDPSinkNumberBytesDelivered]
  set PktsDel  [$udpsink set UDPSinkTotalPktsReceived]
  set PktsDropped  [$udpsink set UDPSinkNumberPktsDropped]
  set PktsOutOfOrder  [$udpsink set UDPSinkPktsOutOfOrder]
  set AvgJitter  [$udpsink set UDPAvgJitter]
  set AvgLatency  [$udpsink set UDPAvgLatency]
  set tmpTime [expr [$ns now] - $starttime]
  set thruput [expr $bytesDel*8.0/$tmpTime + 0.0]
#puts "dumpFinalUDPStats: bytesDel is $bytesDel, tmpTime is $tmpTime and thruput is $thruput (output file: $outputFile)"
  set tmpX [ expr $PktsDropped*1.0 + $PktsDel*1.0]
  if {$tmpX > 0} {
     set dropRate [expr $PktsDropped*1.0 / $tmpX + 0.00]
   } else {
     set dropRate 0
   }
#   puts "$label $bytesDel $arrivals $lossno $dropRate $meanRTT $notimeouts $toFreq $thruput  0 0 0"
#make the number of fields the same as with dumpFinalTFRC.... DO NOT CHANGE!!!! MATLAB needs this.
   puts $f "$label $bytesDel $PktsDel $PktsDropped $PktsOutOfOrder $dropRate $thruput $AvgJitter $AvgLatency"
   flush $f
   close $f
}

