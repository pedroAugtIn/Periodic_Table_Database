#!/bin/bash

PSQL="psql --username=postgres --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]; then
    echo -e "Please provide an element as an argument."
    exit 
elif [[ "$1" =~ ^[1-9]$|^10$ ]]; then
    ATOMIC_NUMBER=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
       properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
        FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number
        LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = '${1}';")
    
    if [ -z "$ATOMIC_NUMBER" ]; then
        echo "I could not find that element in the database."
        exit
    fi
    
    IFS='|' read -ra INFO_ARRAY <<< "$ATOMIC_NUMBER"
    
    OUTPUT="The element with atomic number ${INFO_ARRAY[0]} is ${INFO_ARRAY[1]} (${INFO_ARRAY[2]}). It's a ${INFO_ARRAY[3]}, with a mass of ${INFO_ARRAY[4]} amu. ${INFO_ARRAY[1]} has a melting point of ${INFO_ARRAY[5]} celsius and a boiling point of ${INFO_ARRAY[6]} celsius."
    
    echo "$OUTPUT"

elif [[ "$1" =~ ^[A-Za-z]{1,2}$ ]]; then
    ATOMIC_NUMBER=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
       properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
        FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number
        LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '${1}';")
    
    if [ -z "$ATOMIC_NUMBER" ]; then
        echo "I could not find that element in the database."
        exit
    fi

    IFS='|' read -ra INFO_ARRAY <<< "$ATOMIC_NUMBER"
    
    OUTPUT="The element with atomic number ${INFO_ARRAY[0]} is ${INFO_ARRAY[1]} (${INFO_ARRAY[2]}). It's a ${INFO_ARRAY[3]}, with a mass of ${INFO_ARRAY[4]} amu. ${INFO_ARRAY[1]} has a melting point of ${INFO_ARRAY[5]} celsius and a boiling point of ${INFO_ARRAY[6]} celsius."
    
    echo "$OUTPUT"

elif [[ "$1" =~ ^(Hydrogen|Beryllium|Boron|Carbon|Nitrogen|Oxygen|Helium|Lithium|Fluorine|Neon)$ ]]; then
    ATOMIC_NUMBER=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
       properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
        FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number
        LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.name = '${1}';")
    
    if [ -z "$ATOMIC_NUMBER" ]; then
        echo "I could not find that element in the database."
        exit
    fi

    IFS='|' read -ra INFO_ARRAY <<< "$ATOMIC_NUMBER"
    
    OUTPUT="The element with atomic number ${INFO_ARRAY[0]} is ${INFO_ARRAY[1]} (${INFO_ARRAY[2]}). It's a ${INFO_ARRAY[3]}, with a mass of ${INFO_ARRAY[4]} amu. ${INFO_ARRAY[1]} has a melting point of ${INFO_ARRAY[5]} celsius and a boiling point of ${INFO_ARRAY[6]} celsius."
    
    echo "$OUTPUT"

else
    echo "I could not find that element in the database."
fi
