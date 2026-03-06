#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d  "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "ENTER YOUR PASSWORD :"
read mysql_root_password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILURE...$N"
        exit 1
    else
        echo -e "$2 is $G SUCCESS....$N"
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

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting my sql"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "Setting password"

mysql -h db.mounikasai.shop -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [$? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else
    echo "Password is already setup $Y .......SKIPPING"
fi
    


