#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# loop over games.csv and get team names
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do # do something to each line
# check winner to see if it exists
if [[ $WINNER != "winner" ]]
then
  #get team id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  echo $WINNER_ID
  # if not found, set team
  if [[ -z $WINNER_ID ]]
  then 
    # insert team
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    echo Inserted result:, $INSERT_WINNER_RESULT
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
       # log to console and get new team id
      echo Inserted winner into teams, $WINNER
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    fi
  fi
fi
# check opponent to see if it exists
if [[ $OPPONENT != "opponent" ]]
then
  #get team id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # if not found, set team
  if [[ -z $OPPONENT_ID ]]
  then 
    # insert team
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then 
      # log to console and get new team id
      echo Inserted opponent into teams, $OPPONENT
      #get team id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    fi
  fi
fi
echo winner id: $WINNER_ID opponent id: $OPPONENT_ID
# enter game results into games table
if [[ $YEAR != "year" ]] 
then
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
echo insert games result: $INSERT_GAME_RESULT
fi
done