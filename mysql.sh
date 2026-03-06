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

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is $G SUCCESS...$N"
    else
        echo -e "$2 is $R FAILURE....$N"
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
VALIDATE $?  "insallation of mysql server"

systemctl enable mysqld
VALIDATE $? "Enabling mysql"

systemctl start mysqld
VALIDATE $? "starting my sql"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting password"