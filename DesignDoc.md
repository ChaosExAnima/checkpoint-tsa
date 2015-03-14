# Game Design Document #

---

## Security Levels ##
Green, blue, yellow, orange, red
  * Yellow default setting
  * Increases security each level improves accuracy 10% of original value, decreases speed 10% of original value
  * vice versa for decreasing security

## Resources ##
### Reputation ###
  * Start with 50 reputation
  * Max 100 reputation
  * Min 0 reputation (lose the game)
#### Reputation Gain & Loss ####
  * Knife getting past -1 rep
    * 10% chance of incident when gets past
    * Knife incident - 5 rep
  * Gun getting past -5 rep
    * 10% chance of incident when gets past
    * Gun incident -15 rep
  * Bomb getting past -10 rep
    * 90% chance of incident when gets past
    * Bomb incident -30 rep

  * Person missing plane -0.5 rep
  * Person with mood below 25 when finished with line -1 rep

  * Making a bad bust -10 rep

  * Security catching knife +1 rep
  * Security catching gun +5 rep
  * Security catching bomb +25 rep
  * Security catching drugs +10 rep
  * Player caught above offense 150% of above

### Money ###
Start with $50

#### Money Gain & Loss ####
  * Each passenger who makes it through on time +$1
  * Catching knife +$10
  * Catching gun +$50
  * Catching bomb +$75
  * Catching drugs +$100
  * Sell equipment at 50% original cost
  * Each level 1$ for each 1 point rep bonus

  * Buying equipment
  * Policy editor changes dog and guard ongoing cost (and effectiveness)

## Lines ##
  * Players can add up to 5 security equipment (6 with special super-xray machine feature).
  * Lines can be set so that passengers won't enter them unless player manually directs them to the line.


## Purchasables ##
### Security Equipment ###
#### Buying a new line ####
  * Players start with 1 line
  * Player can buy up to 5 line
  * Fewer lines = longer lines
  * 2nd line costs $200
  * 3rd line costs $400
  * 4th line costs $800
  * 5th line costs $1600

#### Bag checker security guard ####
  * starting 60% chance of finding everything at yellow
  * 10 seconds per person
  * Mood coefficient of -2
  * Purchase cost $20
  * Power-ups
    * Level 2 training
      * increase to 80% accuracy at finding offenses
      * $40
      * Increases efficiency
    * Level 3 training
      * decrease time to 7 seconds per person
      * $80
      * Increases speed
  * Sell for $0
#### Wand waver security guard ####
Medium chance of finding guns & knives
  * starting 60% chance of finding offenses at yellow
  * 6 seconds per person
  * Mood coefficient of -1.5
  * Purchase cost $20
  * Power-ups
    * Level 2 training
      * increase to 80% accuracy at finding offenses
      * $40
    * Level 3 training
      * decrease time to 4 seconds per person
      * $80
  * Sell for $0
#### Guard with drug canine ####
  * $50 to buy
  * Relatively low chance of detection
  * Mood coefficient of -1.5
  * Start out as beagles
    * 20% chance of finding offenses at yellow
    * 4 seconds per person
  * Power-ups
    * German Shepherds
      * 40% chance of finding offenses at yellow
      * 4 seconds per person
      * $100
    * Pigs
      * 50% chance of finding offenses at yellow
      * 4 seconds per person
      * $200
  * Sell for $0
#### Guard with bomb canine ####
Takes an equipment slot in security line. Detects bombs. Not available until bombs show up in game.
  * $70 to buy
  * Relatively low chance of detection
  * Mood coefficient of -1.5
  * Start out as beagles
    * 40% chance of finding offenses at yellow
    * 4 seconds per person
  * Power-ups
    * German Shepherds
      * 60% chance of finding offenses at yellow
      * 4 seconds per person
      * $140
    * Pigs
      * 70% chance of finding offenses at yellow
      * 4 seconds per person
      * $280
  * Sell for $0
#### Metal Detectors ####
Detects guns & knives
  * Cheapie metal detector
    * Mood coefficient of -0.5
    * starting 55% chance of finding offenses at yellow
    * $200 to buy
    * Slider for efficiency / speed
      * ranges accuracy +/- 10 % points (45%, 65%)
      * ranges time 2-6 seconds
    * Power-ups
      * Add guard to speed up detector
        * Speeds up by 1 second
        * $50
      * Power-up for gun specialization. Can't have both this & knife specialization.
        * Increase base detection by 10% (for guns only) (55%, 75%)
        * $30
        * Increase gun detection
      * Power-up for knife specialization. Can't have both this & gun specialization
        * Increase base detection by 10% (for knives only) (55%, 75%)
        * $30
        * Increase knife detection
    * Sell for 50% of total cost except cost for guard

  * Super metal detector
    * $600 to buy
    * Mood coefficient of -0.5
    * Detects guns & knives
    * Comes with Insta-Detect(tm)
      * Detects violations at 0 seconds (as opposed to after finishing with the passenger)
    * Slider for efficiency / speed
      * Accuracy (60%, 80%)
      * Ranges time 1-3 seconds
    * Power-ups
      * Add guard to speed up detector by 0.5 sec
      * $75
    * Sell for 50% of total cost except cost for guard

#### Ticket checker security guard ####
Adds a barrier between lobby & machines so that passengers must flow through single choke point.
  * $300 to buy
  * can only buy at the beginning of a level
  * 0.25 sec per passenger
  * Guard sends each passenger to a random security line. Equal chance for each line.
  * Power-up
    * Send each passenger to shortest line
    * $600
  * Sell for $0

#### X-Ray Machines ####
Detects guns, knives, bombs
Not as efficient as metal detectors & sniffers

  * Cheapie x-ray
    * $400 to buy
    * Mood coefficient of -0.75
    * Slider for accuracy / speed
    * 4-10 sec, (30%, 50%)
    * Power-ups
      * Power-up for gun & knife specialization. Can't have both this & bomb specialization.
        * $50
        * Increase gun & knife detection
        * Increases by 10 points (40%, 60%)
      * Power-up for bomb specialization. Can't have both this and knife & gun specialization
        * $50
        * Increase bomb detection
        * Increases by 10 points (40%, 60%)
    * Sell for 50% total cost

  * Super x-ray
    * $800 to buy
    * 2-6 sec, (30%, 50%)
    * Mood coefficient of -0.75
    * Comes with Insta-Detect(tm)
    * Adds an adjacent spot that can be used for a drug canine, bomb canine, wand waver, or bag checker
      * Add time, mood, accuracy per above
    * Slider for accuracy / speed
    * Power-ups
      * Power-up for gun & knife specialization. Can't have both this & bomb specialization.
        * $100
        * Increase gun & knife detection
        * Increases to (50%, 70%)
      * Power-up for bomb specialization. Can't have both this and knife & gun specialization
        * $100
        * Increase bomb detection
        * Increases to (50%, 70%)
      * Sell for 50% total cost
#### Sniffer machine ####
Detects bombs & drugs. Expensive to buy
  * $1800 to buy
  * Mood coefficient of -1
  * Slider for efficiency / speed
  * 4-6 sec, (60%, 80%)
  * Radio button for detection set to bombs or drugs
  * Power-ups
    * Processor upgrade for analysis speed
    * Changes speed to 2-5 sec
    * $1000 to buy
  * Sell for 50% total cost
#### Entertainment video display ####
  * Goes into a security slot
  * Maximum of 1 per line
  * $300
  * Doesn't slow down people
  * Improves 0.2 per time for people in that line
#### Clowns ####
  * Goes into the security slot
  * Maximum of 1 per line
  * $1250
  * Improves 0.5 per time for people in that line
## Time ##
  * Each passenger is created with time until plane takes off
  * Range of 240 - 60 seconds (bell curve with the concentration definable per level)
  * When the passenger is within 5 seconds of missing flight, mood indicator changes to unhappy (though the mood level isn't actually adjusted)
  * When the passenger is within 5 seconds of missing flight, another graphical indication (e.g., looks at watch)
  * When time run out the passenger leaves game and the player's reputation is lowered per above

## Mood ##
  * Each passenger has a mood rating
  * Mood goes from 125 (very happy) to 0
    * Any passenger finishing security line with 25 or lower mood decreases player's rep by 1 point
    * Passengers with a mood <= 25 have some graphical indication (e.g., black cloud over their head, or cursing %!@)
  * Passengers are created with a minimum of 25 up to a 100, weighted per level
    * Done as a bell curved with the concentration specified per level
  * Passengers have a change coefficient ranging from 1.0 to 2.0
  * When in line the mood is lowered by 0.5 **passenger's change coefficient per game tic (1 second?)
  * Security equipment have a change coefficient is multiplied to the passengers' change coefficient to increase or decrease the mood change per game tic**

## Security Alerts ##
  * Occasional messages indicating a narrative of a threat (perhaps 0-3 per level)
  * Threats exist for every offending type
    * "We are conducting a test of the security system today. A mock bomb will be sent through to test the security accuracy. Please treat it as a real threat."
    * "The local police have alerted us that a large cache of drugs will be smuggled through the airport today. Stay alert"
    * "There is a knife show in town... be alert for folks trying to bring knives on-board"
    * etc.
  * The Passenger Factory will determine when an alert happens.
    * The Factory will create a passenger of the correct violation type. An alert will be issued 0-5 seconds after the passenger is created.

## Hot/Cold Tool ##
  * Every level the player can go use the "hot/cold" tool 3 times per level.
  * When activated, a panel pops up with meters for guns, knives, bombs, & drugs
    * As the player moves cursor around, the meters respond in reporting the nearby threat detection
  * The tool lasts 20 seconds and then can't be used for 60 seconds
  * While the tool is engaged, the player can continue to direct passengers to lines, buy equipment, sell equipment, & modify equipment
  * Passengers who are offenders have a "concealment" property ranging from 0 - 100
    * The better the concealment, the wider the detection radius and the less the differentiation in meter level when getting close to the offender
  * Left clicking on a person gives the player the option of arresting the person (in addition the standard directing the person to a particular line)
    * Arresting the person results in either a "bad bust" (hurts reputation) or "good bust" helps reputation.

## Line Assignment Tool ##
  * When player clicks on a passenger not already in line, the player can indicate which line the passenger enters. This overrides the ticket checker and the initial line assignment the passenger was created with.
  * Passengers who have been manually assigned a line should have some sort of feedback indicating which line they are assigned to.
  * Player can change the line assignment.


## Level ##
At the beginning of each level, player can adjust security equipment. Level starts when when player presses a "go" button.

### Level 1 ###
  * 20 passengers
  * Start with $50
  * 10% chance of violation (minimum of 1 violation for level)
  * Knife offense
  * Available purchasables
    * Bag checker security guard
    * Wand waver security guard

### Level 2 ###
  * 30 passengers
  * 10% chance of violation (minimum of 2 violations for level)
  * Knife offense, drug offense
  * Available purchasables
    * Bag checker security guard
    * Wand waver security guard
    * Guard with drug canine
    * Guard with bomb canine

### Level 3 ###
  * 50 passengers
  * 10% chance of violation (minimum of 3 violations for level)
  * Knifes, drug
  * 1 security alert
  * Available purchasables
    * Bag checker security guard
    * Wand waver security guard
    * Guard with drug canine
    * Guard with bomb canine
    * New lines

### Level 4 ###
  * 60 passengers
  * 12% chance of violation (minimum of 6 violations for level)
  * Drugs, guns, & knives
  * 1-2 security alerts
  * Available purchasables
    * Bag checker security guard
    * Wand waver security guard
    * Guard with drug canine
    * Guard with bomb canine
    * New lines
    * Metal detectors

### Level 5 ###
  * 70 passengers
  * Drugs, guns, & knives
  * 1-3 security alerts
  * 15% chance of violation (minimum of 8)
  * Available purchasables
    * All

### Level 6 ###
  * 80 passengers
  * Drugs, guns, & knives
  * 1-4 security alerts
  * 20% chance of violation (minimum of 12)
  * Available purchasables
    * All

### Level 7 ###
  * 90 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 15)
  * Available purchasables
    * All

### Level 8 ###

  * 100 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 15)
  * Available purchasables
    * All

### Level 9 ###
  * 125 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 10 ###
  * 150 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 11 ###
  * 150 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 12 ###
  * 150 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 13 ###
  * 160 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 14 ###
  * 160 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 15 ###
  * 170 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 16 ###
  * 180 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 17 ###
  * 190 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 18 ###
  * 200 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 19 ###
  * 225 passengers
  * Drugs, guns, knives, & bombs
  * 1-4 security alerts
  * 25% chance of violation (minimum of 20)
  * Available purchasables
    * All

### Level 20 ###
  * 250 passengers
  * Drugs, guns, knives, & bombs
  * 25% chance of violation
  * Available purchasables
    * All


## Possible Additional Functionality ##
Here are game play elements we can consider adding if we have time and/or the game play is lacking.
  * Some passengers are slow moving through the line. The player can have the option of allowing them to hold up the line or kicking them out of the line (thus hurting reputation and income)