# Smogon Stats Data Visualisation

[Shiny App HERE](https://timlxq.shinyapps.io/smogon_viz_project/)

## About the data
Smogon is a competitive Pokemon community that hosts a popular online Pokemon
battle simulator. Every matchmade game played on the servers is logged, and a
few community members pre-process the data and publish it monthly to provide
information on trends in tactics.

This data can be found at https://www.smogon.com/stats/. It consists mostly of
text files, formatted to be viewed by the general public, but there is a JSON
for those acquainted with JSON parsing techniques to get access to more data.

The stats allow users to see trends in builds and gameplay in competitive
Pokemon games played on the Smogon servers. This supplements their own
experience in helping them improve their team and decisions during games. The
aim (I presume) is aligned with everything else the Smogon community  sinks time
into doing: To improve the community and foster higher quality competitive
Pokemon play.

## About the project
This project is personal - I just wanted to get more practice with data
wrangling and visualisation in R, using a dataset I liked and knew what I wanted
out of. In addition, it helps me make up 1 credit for my degree ~~(actually more
like the visa that was needed for the degree, which is now redundant since the
coronavirus torpedoed international travel)~~, and feel less bad when I end up
playing a game (or three) on the Smogon servers.

I set the following goals for myself:
*	Refine skills in data wrangling of .json, text, and potentially web data
* Refine skills in Data Visualisation and Exploration, particularly with R and
RShiny
*	Learn to draw applicable, meaningful insights from processing of large datasets
*	Practice data wrangling and inference skills related to social network
analysis with a large dataset
*	Learn to work with data where information and documentation about the data is
scarce

For myself and the viewing public, the project intends to provide a more
intuitive viewing experience to the data found at the site above. Looking through
The text files with `Ctrl + F` is tedious. Pretty interactive graphs and tables
with drop down bars is much better. It is hoped that presenting the data in a
nicer format helps users with teambuilding and gameplay.

Specifically, I hope that they help users gain insights with regards to
these and other questions that are important in playing Pokemon competitively
more easily than they would with the text files:

At various levels of gameplay...
*	What are the most common Pokemon used?
*	What are the most common types of Pokemon used?
*	How these have changed over time given rule changes, bans, or evolution in
tactics?
*	What are the most used items for a Pokemon
*	What are the most used moves for a Pokemon
* Which Pokemon tend to be used together, or tend to face-off against each other?
*	What/Are there team compositions that pose a significant threat to your team?
*	Which Pokemon is a player likely to switch into to counter a play?

## Progress
**Done:**
1. Import and adapt full dex to provide type and stat data for Pokemon
2. Interactive dashboard for Usage Statistics documents
  * Graph for Usage by types
  * Table for raw usage % data
3. Create FAQ

**To do for MVP:**
1. Dashboard to access basic metagame data
2. Adapt Usage statistics dashboard to provide more specific access to monotype
data

**Stretch Goals:**
1. Provide network visualisation and statistics based on checks/counters data
2. Provide ability to visualise usage trends over time

## Links
* [Smogon Stats](https://www.smogon.com/stats/)
* [The latest Smogon Usage Statistics Discussion Thread](https://www.smogon.com/forums/threads/gen-8-smogon-university-usage-statistics-discussion-thread.3657197/)
  - The posts in threads are most of what we have in understanding what the
  numbers found in the stats files even mean. Older threads can be found by
  googling for "Smogon Stats Discussion". If you can't find an answer and want
  one, post in the latest thread.
* [Play Pokemon on Smogon's servers - PokemonShowdown](https://play.pokemonshowdown.com/)
* [Github Repo for the Smogon Usage Stats](https://github.com/Antar1011/Smogon-Usage-Stats)
