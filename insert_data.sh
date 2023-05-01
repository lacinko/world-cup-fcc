#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" ]]
then
  TEAM_ID="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
  if [[ -z $TEAM_ID ]]
  then
    INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted $WINNER successfully!
    else 
      echo failed to insert $WINNER!
    fi
  else
    echo $WINNER already exists
  fi
    TEAM_ID="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
  if [[ -z $TEAM_ID ]]
  then
    INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted $OPPONENT successfully!
    else
      echo Failed to insert $OPPONENT!
    fi
  else
    echo $OPPONENT already exists
  fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
  if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
  then
    echo Game data inserted Successfully!
  else
    echo Failed to insert game data!
  fi
fi
done