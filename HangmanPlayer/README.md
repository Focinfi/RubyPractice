## HangManPlayer

### Introduction

This project is for playing the Hangman Game from a server through a RESTful API like.

#### Requirements
1. ruby(>= 2.0)
2. gem bundler

#### Preparation
    cd path/to/HangManPlayer
    bundle install

#### Play A Game
    cd path/to/HangManPlayer
    ruby runner.rb

#### Test
    cd path/to/HangManPlayer
    rspec

#### How it works

0. #####Project Structure

    0. `runner.rb` for run this project
    1. `Gemfile` for bundler to manage gem dependence.
    2. `Gemfile.lock` records the exact versions that were installed.
    3. `Rakefile` for rake tasks
    4. `./lib` directory contains main sources

        1. `hangman_player.rb` for class HangmanPlayer to controll the game flow.
        2. `http_accessor.rb` for class HttpAccessor who is charge of communicate with server.
        3. `process_support.rb` for support things like record log, handle expection and so on.
        4. `word_analyzer.rb` for analyze result string to decide which char next guess.
    5. `./spec` for Rspec to test each file in ./lib directory.
    6. `./log/hangman_player.log` for keep log.
    7. `./tmp` directory contains temp file.

        1. `record.tmp` contains the best score.
        2. `game_status.tmp` contains the last player's last game sesssion id if the player droped out in.
    8. `./data` directory contains words' txt and json file.

1. #####With BDD, I got more fun in coding.

    0. I try block-based design for HangmanPlayer to let my code more easily to test.
    1. Ensure HangmanPlayer's code quality.
    2. Easy to extend and refactor.

2. #####Get higher score
    1. Extract a words .txt file to json file, data structure like:

            {
              "3":
                {
                  "char_list": ["C", "E", "R", "A"],
                  "words_set": ["CAR", "ARE"]
                }
            }

        - `char_list`: chars's array ordered by chars' frequency in words_set.

        - `word_set`: words whose length of "3" in dictionary.

    2. Use the last char in the `char_list` to guess.
    3. If guess successfully, update `words_set` by matching the guessed result and reset `char_list` for the new `words_set`.

3. #####Handle Exception
    1. Log importaint infomation in log file while playing.
    2. If got any exception, has an selection to Retry or to Exit.
    3. If drop out in a game, record player's information for resuming in next time.

####Todo
    Cause time is limited, there are many things can do to prefect this project.
  	1. To get a higer score Use a bigger dictionary and optimize word_analyzer's algorithm.
  	2. Use Redis and MongoDB for data' CURD to improve performance.
  	3. Use mutil-thread to speed up processing string and arrays.

