#!/bin/bash
#script should be execute with sudo/root access
if [["${UID}" -ne 0 ]]
then 
    echo 'please run with sudo or root.'
    exit 1
fi

#user should provide atleast one arguement as username else guide him
if [[ "${#}" -lt 1 ]]
then
    echo "usage: ${0} USER_NAME[COMMENT]..."
    echo 'create a user with name USER_NAME and comments field of COMMENT'
    exit
fi

#store 1st arguement as user name
USER_NAME="${1}"

#Incase of more than one arguement store it as a comment
shift
COMMENT="${@}"

#create a password
PASSWORD=$(date +%s%N)
echo $PASSWORD

#create a user
useradd -c $COMMENT -m $USER_NAME

#check if a user is successfully created or not
if [[ $? -ne 0 ]]
then
      echo 'The Account could not be created'
      exit 1
fi

#set the passowrd for the user
echo $PASSWORD |passwd --stdin $USER_NAME

#check if the password is successfully set or not
if [[ $? -ne 0 ]]
then
    echo 'Password could not be set'
    exit 1
fi

#Force a  password change on first login
passwd -e $USER_NAME

#Display the username , password and the host from which the user was created
echo
echo"username: $USER_NAME"
echo
echo"password: $PASSWORD"
echo
echo $(hostname)
