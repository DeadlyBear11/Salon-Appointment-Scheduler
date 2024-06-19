#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT * FROM services")

echo -e "\nWelcome to my Salon."

MAIN_MENU() {
echo -e "\nSelect a service:"

echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
do
  ID=$(echo $SERVICE_ID | sed 's/ //g')
  echo "$ID) $SERVICE"
done

read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  [1-3]) SERVICE_PICKED ;;
      *) MAIN_MENU ;;
esac
}

SERVICE_PICKED() {
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
CUSTOMER_NAME=$(echo $NAME | sed 's/ //g')
if [[ -z $NAME ]]
then
  echo -e "\nI don't have that phone number, what's your name?"
  read CUSTOMER_NAME
  NAME=$(echo $NAME | sed 's/ //g')
  SAVED_TO_TABLE_CUSTOMERS=$($PSQL "INSERT INTO customers(name,phone) VALUES('$NAME','$CUSTOMER_PHONE')")
fi
  
GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
SERVICE_NAME=$(echo $GET_SERVICE_NAME| sed 's/ //g')
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
SAVED_TO_TABLE_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
if [[ $SAVED_TO_TABLE_APPOINTMENTS == "INSERT 0 1" ]]
then
  echo -e "\nThis is your confirmation for $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}

MAIN_MENU