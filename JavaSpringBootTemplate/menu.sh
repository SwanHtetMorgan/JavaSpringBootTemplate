#!/bin/bash 

swanJavaDev(){ 
   commands=("control" "service" "openApI")
   echo "Commands supported by the library........"
   for command in "${commands[@]}"; do 
      echo "$command"
   done


   echo ""
   echo ""
   echo "" 
   echo "please make sure to run in the /src/main/java"
   echo "Follow the instruction for each commad"
   echo "____________________________________________________________________________|"
   echo "Setting System conmmand"
   echo "____________________________________________________________________________|"
   echo "MAC AND LINUX"
   echo "____________________________________________________________________________|"
   echo "chmod a+x controller.sh  \" And other package also to change file permssion |"
   echo "____________________________________________________________________________|"
   echo "Move to /usr/local/bin with sudo mv /usr/local/bin"
   echo "____________________________________________________________________________|"
   echo " user can set any command name you want with mv controller.sh control"
   
   echo "____________________________________________________________________________|"
   echo "Window  I will update later"
   
}

swanJavaDev