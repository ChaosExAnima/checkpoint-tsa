package gameLogic {
	import gameControl.TheGame;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	
	/* This class contanins all the information a specific passenger has,
		including whether he or she carries a prohibited object, mood,
		concealment, time to departure.
	*/

	public class Passenger extends EventDispatcher {
	
		private var mood:Number; //[0..125] 125 is best, 0 worst
		private var moodCoeff:Number; //[1.0..2.0]
		private var concealment:int; //[0..100] 100 is best concealment, 0 worst
		private var timeLeft:Number; //fictional time for the passenger in minutes. Is reduced according to gametiks in gameTikHandler
		private var gotoStation:Station; //station where passenger is heading for
		private var stationRedirected:Boolean = false; //if user has redirected passenger to go to a certain station. False at the beginning.
		private var prohibObj:ProhibitedObject = null; //the prohibited Object the passenger is carrying. Null if none.
		private var line:Line = null; //stores the line, the passenger is in, if any.
		private var secCheck:SecurityCheckUnit = null; //stores the security check unit, the passenger is in, if any.
		public static const OUTOFMOOD:String = "out of mood";
		public static const OUTOFTIME:String = "out of time";
		public static const MOVEON:String = "move on";
		public static const CAUGHT:String = "caught";
		
		public function Passenger(initTemp:int, tInc:int, initTimeLeft:int, conc:int, prObj:ProhibitedObject, gStation:Station):void {
			mood = initTemp;
			moodCoeff = tInc;
			timeLeft = initTimeLeft;
			concealment = conc;
			prohibObj = prObj;
			gotoStation = gStation;
			
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, gameTikHandler);
		}
		
		//Tells the passenger that he is now in this line.
		public function inLine(line:Line):void {
			this.line = line;
		}
		
		//Tells the passenger that he is now in this security check unit.
		public function intoSecurityCheckUnit(secCheck:SecurityCheckUnit):void {
			this.line = null;
			this.secCheck = secCheck;
		}
		
		//Changes mood and timeLeft each game ticket according to where they are.
		//Mood can change in Line and in SecurityCheckUnit.
		//Time decreases from the moment they are created
		private function gameTikHandler(e:TimerEvent):void {
			timeLeft = timeLeft - TheGame.gameToMinTime(1);
			
			if (line != null) {
				mood = mood - moodCoeff*line.getMoodDecrease();
			}
			else if (secCheck != null) {
				mood = mood - secCheck.getMood()/secCheck.getSpeed();
			}
			if(timeLeft <= 0) {
				leaveAirport(Passenger.OUTOFTIME);
			}
			else if (mood <=0) {
				leaveAirport(Passenger.OUTOFMOOD);
			}
		}
		
		//PRE: Mood or time are up
		//POST: Stops timing, subtracts reputation.
		private function leaveAirport(reason:String):void {
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, gameTikHandler);
		
			//JUST TO TEXT TEST:
			trace("I am so fed up, I gonna leave the airport");
			//END TEXT TEST
			line = null;
			
			if(reason == OUTOFMOOD) {
				TheGame.subtractReputation(1); //change to 0.5!!! (=> change to var in TheGame!!!!) VAR!
			}
			else if (reason == OUTOFTIME) {
				TheGame.subtractReputation(1); // store in VAR!!!
			}
			
			dispatchEvent(new Event(reason));
		}
		
		//PRE: Last security check unit checked passenger
		//POST: Stop timing, add or subtract reputation or money,
		//      depending on whether he came through smuggling something and if based on that an incident occures.
		//		If the person finishes with mood below 25, repective reputation value is subtracted.
		public function goToPlane():void {
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, gameTikHandler);
			secCheck = null;
			
			//We get money for every passenger checked, whether we let him through with an prohibited object or not.
			TheGame.addMoney(1); //store in variable!!!
			if(mood <25) TheGame.subtractReputation(1); //store in VAR
			
			if(prohibObj != null) {
				//Incident based loss and missing based loss of reputation does not add
				if(prohibObj.incidentHappens()) {
					TheGame.subtractReputation(prohibObj.getIncidentRepLoss());
				}
				else {
					TheGame.subtractReputation(prohibObj.getMissingRepLoss());
				}
			}
			
			
			//JUST TO TEXT TEST:
			trace("Hey, cool. I can go to the plane!");
			//END TEXT TEST
		}
		
		//PRE: Passenger got caught, so prohibObj is NOT null
		//POST: Stops timing, adds reputation and money
		public function gotCaught():void {
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, gameTikHandler);
			secCheck = null;
			
			//add reputation and money for catching specified prohibited object
			TheGame.addReputation(prohibObj.getCatchingRepGain());
			TheGame.addMoney(prohibObj.getCatchingMoneyGain());
			//-------------------------------------------------------
			this.dispatchEvent(new Event(CAUGHT));
			//JUST TO TEXT TEST:
			trace("Oh, damn I got caught!");
			//END TEXT TEST
		}
		
		
		public function getMood():int {
			return Math.round(mood);
		}
		
		//Post: Returns the prohibited Object the passenger is carrying
		public function carriesWhat():ProhibitedObject {
			return prohibObj;
		}
	
		public function carryingSomething():String {
			if (prohibObj == null) return "Nothing illegal";
			else return prohibObj.getKindOfObj()+": "+prohibObj.getKindOfKindOfObj();
		}
		
		//Pre: station must exist in the airport
		//Post: passenger is redirected to the station, marks as user interaction
		public function redirectTo(station:Station):void {
			gotoStation = station;
			stationRedirected = true;
		}
		
		public function getTimeLeft():int {
			return Math.round(timeLeft);
		}
		
		public function getGotoStationNr():int {
			return gotoStation.getNumber();
		}
		
		public function getConcealment():int {
			return concealment;
		}
		
		//JUST TO TEXT TEST:
		public function testWhere():String {
			if(line!=null) return "in Line";
			//else if (secCheck != null) return "in Security Check Unit" + secCheck.position;
			else return "nowhere";
		}
		//END TEXT TEST
	}
}