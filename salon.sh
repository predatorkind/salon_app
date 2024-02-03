#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Hair Salon and Barber ~~~~~"
PRINT_SERVICES() {
  SERVICES=$($PSQL "SELECT service_id, name FROM services;")

  echo -e "\nHere are our services:"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

while :
do
  PRINT_SERVICES
  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  if [[ $SERVICE_NAME ]]
  then
    break
  fi
done

# ask for phone number CUSTOMER_PHONE
echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
# if does not exist ask for name CUSTOMER_NAME
if [[ -z $CUSTOMER_NAME ]]
then
  # register new user
  echo -e "\nPlease enter your name:"
  read CUSTOMER_NAME
  ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
fi
echo Customer name: $CUSTOMER_NAME
# get CUSTOMER_ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME';")
echo Customer ID: $CUSTOMER_ID
# ask for SERVICE_TIME
echo -e "\nPlease enter time for your appointment:"
read SERVICE_TIME

# create appointment
CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
# output appointment summary
if [[ $CREATE_APPOINTMENT == 'INSERT 0 1' ]]
then
  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
