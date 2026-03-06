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

VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo -e "$2 is $G.......SUCCESS $N"
    else
        echo -e "$2 is $R.......FAILURE $N"
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "please run with super user"
else
    echo "you are in root user"
fi

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "installing nginx"

# systemctl enable nginx &>>$LOGFILE
# VALIDATE $? "enabiling nginx"

# systemctl start nginx &>>$LOGFILE
# VALIDATE $? "Starting nginx"

# rm -rf /usr/share/nginx/html/* &>>$LOGFILE
# VALIDATE $? "Removing default content"

# curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
# VALIDATE $? "Download frontend code"

# cd /usr/share/nginx/html
# unzip /tmp/frontend.zip &>>$LOGFILE
# VALIDATE $? "Extract the frontend code"

# cp /home/ec2-user/expense-shell /etc/nginx/default.d/expense.conf &>>$LOGFILE
# VALIDATE $? "copying expense.conf"

# systemctl restart nginx &>>$LOGFILE
# VALIDATE $? "restarting nginx"