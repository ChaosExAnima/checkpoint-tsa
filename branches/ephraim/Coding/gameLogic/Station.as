package gameLogic {
	
	import gameControl.TheGame;
	import flash.events.Event;
	
	/* This class encapsulates a station, containing a line and security check units */
	
	public class Station {
	
		//unique number of station (1,2,3...)
		private var number:int;
		
		//securityCheckUnits which are located in this station, first security check unit is at index 0, fifth station at index 4
		private var securityCheckUnits:Array = new Array(5);
	
		//the line which belongs to the station
		private var line:Line;
		
		//prices of 1st to 5th station
		public static const prices:Array = [0,200,400,800,1600]; //int: READ IN FROM XML!!!
		
		//POST: Creates the station and adds the line to it. 
		//PRE: 1<= number <=5;
		public function Station(number:int) {
			this.number = number;
			line = new Line(this);
			TheGame.subtractMoney(prices[Airport.getNrStations()-1]);
			for(var i:int=0;i<5;i++) {
				securityCheckUnits[i] = null; 
			}
		}
		
		//PRE: 1 <= placeInStation <= 5 
		//adds a security check unit to the station
		public function addSecurityCheckUnit(secCheckUnit:SecurityCheckUnit,placeInStation:int):void {
			securityCheckUnits[placeInStation-1] = secCheckUnit;
			secCheckUnit.setStationPosition(this, placeInStation);
		}
		
		//removes a security check unit from the station
		public function removeSecurityCheckUnit(secCheckUnit:SecurityCheckUnit):void {
			for (var i:int = 0; i < securityCheckUnits.length; i++) {
				if (securityCheckUnits[i] == secCheckUnit) {
					securityCheckUnits[i] = null;
				}
			}
		}
		
		//PRE: At least one security check unit must be set up in this station.
		public function firstSecurityCheckUnitEmpty():Boolean {
			if (getNextSetPos(0) == -1) {
				return false;
			}
			return securityCheckUnits[getNextSetPos(0)].isFree();
		}
		
		//PRE: 0 <= position <= 5. (So actual position of Security Check Unit, not array position.) If position is 0, so the first Security Check
		//POST: Returns next array position, where a Security Check Unit is situtated. If none is found (so if this is the last station), it returns -1.
		//      If position is 0, so the position of the first Security Check is returned.
		private function getNextSetPos(position:int):int {
			for(var i:int=position;i<=5;i++) {
				if (securityCheckUnits[i] != null) return i;
			}
			return -1;
		}
		
		//PRE: 1 <= position <= 5. (So actual position of Security Check Unit, not array position)
		//POST: Returns true, if the next Sec Check Unit is free or if this Sec Check Unit was already the last one. 
		// 		Returns false, if the next Sec Check Unit is not free.
		public function nextFree(position:int):Boolean {
			var nextPos:int = getNextSetPos(position);
			if(nextPos == -1) return true;
			else return securityCheckUnits[nextPos].isFree();
		}
		
		//PRE: 1 <= position <= 5. (So actual position of Security Check Unit, not array position)
		//POST: Passes passenger to next security check station, or tells him he is finished if none exists.
		//		If this was the first station, then the line is told to send the next passenger.
		public function passOnPassenger(pass:Passenger, position:int):void {
			if(pass!=null) {
				var nextPos:int = getNextSetPos(position);
				pass.dispatchEvent(new Event(Passenger.MOVEON));
				if (nextPos == -1) {
					pass.goToPlane();
				}
			}
			//if((position-1)==getNextSetPos(0)) line.handleGameEvent(Line.FIRST_EMPTY);
		}
		
		public function doPassOn(pass:Passenger, nextPos:int):void {
			securityCheckUnits[nextPos].checkPassenger(pass);
		}
		
		public function getLine():Line {
			return line;
		}
		
		
		public function getPassengerIntoFirstSecUnit(pass:Passenger):void {
			trace(securityCheckUnits[getNextSetPos(0)]);
			securityCheckUnits[getNextSetPos(0)].checkPassenger(pass);
		}
		

		/* Do we need this? Checks the passenger against all security check units in the station.
		public function checkPassenger(pass:Passenger):void {
			for(var i:int=0;i<5;i++) {
				if(securityCheckUnits[i]!=null)
					securityCheckUnits[i].isCaught(pass.carriesWhat());
			}
		}*/
		
		public function getSecurityCheckUnit(position:int):SecurityCheckUnit {
			return securityCheckUnits[position-1];
		}
		
		public function getNumber():int {
			return number;
		}
		
		//PRE: 0 <= index <= 4
		//POST: True, if spot is free, false if not.
		public function spotIsFree(index:int):Boolean {
			if (securityCheckUnits[index]==null) return true;
			else return false;
		}
		
		public function removeAllPassengers():void {
			for (var i:uint = 0; i < 5; i++) {
				if (securityCheckUnits[i]) {
					securityCheckUnits[i].removePassenger(new Event(''));
				}
			}
		}
	}
}