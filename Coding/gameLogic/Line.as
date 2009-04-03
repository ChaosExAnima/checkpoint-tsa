package gameLogic {

	import gameControl.TheGame;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	/* This class sets up a line to a station and stores passengers in the line */

	public class Line {
		private var passengers:Array = new Array() //List of passengers  in a certain line
		private var station:Station //Station that Line belongs to
		//This is a number determining the negative effect that this unit has on the passenger's mood being checked.
		//If mood units are installed, this number could become negative, which means a positive effect on the passenger's mood.
		private var moodDecrease:Number=0.1; //CHANGE SPEC!!!! moodDecrease of 0.5 is unreasonbly high for lowering every game tik!!! 
		public static const FIRST_EMPTY:uint = 0;
		public static const PASSENGER_ARRIVED:uint = 1;
		
		public function Line(station:Station) {
			this.station = station;
			//TheGame.getGameTik().addEventListener(TimerEvent.TIMER, sendFirstPassengerToStation);
		}
		
		//This function can be called f.ex. by the station, when its first security check unit has freed up;
		//or by the graphical passenger, when he actually arrived at the line 
		public function handleGameEvent(eventType:uint):void {
			switch(eventType) {
				case FIRST_EMPTY:
					if(passengers.length>0)
						station.getPassengerIntoFirstSecUnit(popPassenger());
				break;
				case PASSENGER_ARRIVED:
					if(station.firstSecurityCheckUnitEmpty())
						station.getPassengerIntoFirstSecUnit(popPassenger());
				break;
			}
		}
		/*
		private function sendFirstPassengerToStation(event:TimerEvent) {
			if(station.firstStationEmpty()&&passengers.length>0)
				station.getPassengerIntoFirstSecUnit(popPassenger());
		}*/
		
		public function increaseMood(moodIncrease:Number):void {
			moodDecrease = moodDecrease - moodIncrease;
		}
		
		public function getMoodDecrease():Number {
			return moodDecrease;
		}
		
		//Puts passenger to the end of the passengers array and
		//adds event listeners to remove the passenger, in case he runs out of time or mood.
		public function pushPassenger(pass:Passenger):void {
			passengers.push(pass);
			pass.inLine(this);
			pass.addEventListener(Passenger.OUTOFTIME, removePassenger);
			pass.addEventListener(Passenger.OUTOFMOOD, removePassenger);
			//handleGameEvent(PASSENGER_ARRIVED);
		}
		
		//Removes the passenger that triggered a RUN OUT OF TIME/MOOD event and
		//removes event listeners to that passenger.
		private function removePassenger(e:Event):void {
			trace(passengers.length);
			passengers = passengers.filter(findPass);
			trace(passengers.length);
			
			function findPass(item:*, index:int, array:Array):Boolean {
				if (e.target == item) {
					e.target.removeEventListener(Passenger.OUTOFTIME, removePassenger);
					e.target.removeEventListener(Passenger.OUTOFMOOD, removePassenger);
				}
				return (!(e.target == item))
			}
		}
		
		//Removes the first passenger on the passengers array and removes event listeners to that passenger.
		public function popPassenger():Passenger {
			var pRemove:Passenger = passengers.shift(); 
			pRemove.removeEventListener(Passenger.OUTOFTIME, removePassenger);
			pRemove.removeEventListener(Passenger.OUTOFMOOD, removePassenger);
			
			return pRemove;
		}
		
		public function getNumber():int {
			return station.getNumber();
		}
		
	}
}