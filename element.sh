#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="e.atomic_number = $1"
else
  INPUT=${1//\'/\'\'}
  CONDITION="e.symbol = '$INPUT' OR e.name = '$INPUT'"
fi

RESULT=$($PSQL -c "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE $CONDITION LIMIT 1")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r NUMBER SYMBOL NAME MASS MELTING BOILING TYPE <<< "$RESULT"

echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
