#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  # if no arguments
  echo "Please provide an element as an argument."
else
  # if $1 number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get atomic_number
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number = $1;")
  elif [[ $(echo $1 | wc -m) -le 3 ]]
  then
    # if $1 2 characters string
    # get atomic number
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$1';")
  else
    # if $1 >2 characters string
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name = '$1';")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    # if element not found
    echo "I could not find that element in the database."
  else
    ELEMENT_DETAILS=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements full join properties using(atomic_number) full join types using(type_id) where atomic_number = $ATOMIC_NUMBER;")
    ARR=($(echo $ELEMENT_DETAILS | sed 's/|/ /g'))
    
    echo "The element with atomic number ${ARR[0]} is ${ARR[2]} (${ARR[1]}). It's a ${ARR[3]}, with a mass of ${ARR[4]} amu. ${ARR[2]} has a melting point of ${ARR[5]} celsius and a boiling point of ${ARR[6]} celsius."
  fi
  
  
fi
