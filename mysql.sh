#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d  "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

Validate(){
    if [ $1 -eq 0 ]
    then
         echo  -e "$2 is $G SUCCESS......$N"
    else
        echo -e "$2 is $R failure.......$N"
    fi
}
if [ $USERID -ne 0 ]
then
     echo "please run with a super user"
     exit 1
else  
     echo " It is a super user"
fi

dnf install mysql-server -y &>>$LOGFILE
Validate $@  "insallation of mysql server"