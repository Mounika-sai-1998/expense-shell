#!/bin/bash
 
USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Enter DB password : "
read mysql_root_password

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

mkdir -p /app &>>$LOGFILE
# here p is for if there is no directort it create... if  there it does not show any error 
Validate $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
Validate $? "downlading backend file"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
Validate $? "Unzipping backend file"

npm install &>>$LOGFILE
Validate $? "install nodejs dependencies"


cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
Validate $? "copying backend file"

systemctl daemon-reload &>>$LOGFILE
Validate $? "daemon reload"

systemctl start backend &>>$LOGFILE
Validate $? "starting service"

systemctl enable backend &>>$LOGFILE
Validate $? "enabling service"

dnf install mysql -y &>>$LOGFILE
Validate $? "installing client"

mysql -h db.mounikasai.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
Validate $? "loading schema"

systemctl restart backend &>>$LOGFILE
Validate $? "restarting the service"






