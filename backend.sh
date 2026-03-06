#!/bin/bash
 
USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

Validate(){
    if [ $1 -eq 0 ]
    then 
        echo -e "$2 is $G .....SUCCESS $N"
    else
        echo -e "$2 is $R .....FAILURE $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "please run run with root user"
    exit 1
else
    echo "it is a super user"
fi

dnf module disable nodejs -y &>>$LOGFILE
Validate $? "disabiling default nodejs"

dnf module enable nodejs:24 -y &>>$LOGFILE
Validate $? "enabling latest nodejs"

dnf install nodejs -y &>>$LOGFILE
Validate $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    Validate $? "craete expense user"
else 
    echo -e "user is already created $Y ......SKIPPING $N"
fi
