#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [ $# == 0 ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

input=$1

lookup_by_number() {
  atomic_number=$1
  result=$($PSQL "SELECT EXISTS (SELECT 1 FROM properties WHERE atomic_number = $atomic_number)")
  if [[ $result == 'f' ]]; then
    echo "I could not find that element in the database."
  else
    element_data=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
                          FROM elements 
                          JOIN properties ON elements.atomic_number = properties.atomic_number 
                          JOIN types ON properties.type_id = types.type_id 
                          WHERE elements.atomic_number = $atomic_number")

    IFS='|' read -r atomic_number symbol name atomic_mass melting_point_celsius boiling_point_celsius type <<< "$element_data"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
}

lookup_by_symbol() {
  symbol=$1
  result=$($PSQL "SELECT EXISTS (SELECT 1 FROM elements WHERE symbol = '$symbol')")
  if [[ $result == 'f' ]]; then
    echo "I could not find that element in the database."
  else
    element_data=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
                          FROM elements 
                          JOIN properties ON elements.atomic_number = properties.atomic_number 
                          JOIN types ON properties.type_id = types.type_id 
                          WHERE elements.symbol = '$symbol'")

    IFS='|' read -r atomic_number symbol name atomic_mass melting_point_celsius boiling_point_celsius type <<< "$element_data"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
}

lookup_by_name() {
  name=$1
  result=$($PSQL "SELECT EXISTS (SELECT 1 FROM elements WHERE name = '$name')")
  if [[ $result == 'f' ]]; then
    echo "I could not find that element in the database."
  else
    element_data=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
                          FROM elements 
                          JOIN properties ON elements.atomic_number = properties.atomic_number 
                          JOIN types ON properties.type_id = types.type_id 
                          WHERE elements.name = '$name'")

    IFS='|' read -r atomic_number symbol name atomic_mass melting_point_celsius boiling_point_celsius type <<< "$element_data"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
}

if [[ $input =~ ^[0-9]+$ ]]; then
  lookup_by_number $input
elif [[ $input =~ ^[A-Z][a-z]?$ ]]; then
  lookup_by_symbol $input
else
  lookup_by_name $input
fi
