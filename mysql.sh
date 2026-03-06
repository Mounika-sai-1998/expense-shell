#!/bin/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
     echo "please run with a super user"
else  
     echo "is a super user"
fi