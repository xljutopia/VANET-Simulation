BEGIN {send = 0; receive = 0;}
 $1~/s/ && /_0_/&& /AGT/ && /tcp/  { send ++ }
 $1~/r/ && /_1_/&&/AGT/&& /tcp/ { receive ++ }
 END {  print ( send, receive, receive/send) }
