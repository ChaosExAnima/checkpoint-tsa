package gameGraphics {
	import utilities.*;
	import gameGraphics.PassengerG;
	import gameGraphics.StationG;
	import gameLogic.*;	
	import gameControl.TheGame;
	import gameData.XMLgameData;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;

	
	public class LineG extends PassContainer {
		private var speed:Number = 5;
		private var xTrav:Number = 108;
		private var yTrav:Number = 56;
		
		private var spaceW:Number = 0;
		private var spaceH:Number = 0;
		
		private var passArray:Array = new Array();
		private var unitArray:Array = new Array();
		private var spotArray:Array = new Array();
		private var movingOn:Array = new Array();
		
		private var numInLine:Number = 0;
		private var maxInLine:Number = 5;
		
		private var displayed:Sprite = new Sprite();
		
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var myNum:uint;
		
		public var station:StationG;
		
		public var logic:Line;
		
		public function LineG(mystation:StationG):void {
			station = mystation;
			myNum = station.whichStationNum();
			logic = station.logic.getLine();
			
			var pX:int = -(maxInLine*40); //200
			var pY:int = (maxInLine*20); //100
			
			for(var i:int = 0; i<maxInLine; i++) {
				passArray.push(null);
				spotArray.push(new Point(pX, pY));
				//addMark(pX, pY); // TEMP
				pX += 40;
				pY -= 20;
			}
			
			spaceW = xTrav/passArray.length;
			spaceH = yTrav/passArray.length;
			
			xSpeed = speed*(xTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			ySpeed = speed*(yTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
		
		// Temp function to add a marker for line spots
		private function addMark(lX:int, lY:int):void {
			var mark:Shape = new Shape();
			with (mark) {
				graphics.lineStyle(2, 0xFF0000);
				graphics.moveTo(5, 5);
				graphics.lineTo(-5, -5);
				graphics.moveTo(-5, 5);
				graphics.lineTo(5, -5);
				x = lX;
				y = lY;
			}
			this.addChild(mark);
		}
		
		// Moves passengers along
		private function frameEntered(e:Event):void {
			// Waiting in line section
			for(var i:int = 0; i < passArray.length; i++) {
				if (passArray[i] != null) {
					passArray[i].tStep();
					if (passArray[i].obsolete == true) { // No more targets!
						passArray[i].stopWalk();
						if (i == maxInLine-1) { // At the head of line
							moveOn(passArray[i]);
						} else if (!passArray[i+1]) { // Look for empty spots ahead
							passArray[i].setTarg(spotArray[i+1].x, spotArray[i+1].y);
							passArray[i].startWalk();
							passArray[i+1] = passArray[i];
							passArray[i] = null;
						}
					}
				}
			}
			// Passing along machines
			for (i = 0; i < unitArray.length; i++) {
				if (unitArray[i]) {
					unitArray[i].tStep();
					if ((station.spotArray[i] is CheepieMetalDetectorG)||(station.spotArray[i] is SuperMetalDetectorG)||(station.spotArray[i] is SnifferMachineG)) {
						if (Utilities.getDist(station.spotArray[i], unitArray[i]) < 50) {
							unitArray[i].mask = station.spotArray[i].getUnitForm().person_mask;
							station.personHolder.addChild(unitArray[i]);
						} else {
							this.addChild(unitArray[i]);
							unitArray[i].mask = null;
						}
					} 
					if (unitArray[i].obsolete) { // No more waypoints
						var unit:SecurityCheckUnit = station.spotArray[i].logic;
					
						if (unit.isFree()) {
							unitArray[i].stopWalk();
							unit.checkPassenger(unitArray[i].logic);
							if (i == station.getFirst(0)) {
								passArray[maxInLine-1] = null;
							}
						}
					}
				}
			}
			
			// Leaving airport
			for (i = 0; i < movingOn.length; i++) {
				if (movingOn[i]) {
					movingOn[i].tStep();
					if (movingOn[i].obsolete) {
						TheGame.incrementNumPass();
						if(movingOn[i].parent)
							movingOn[i].parent.removeChild(movingOn[i]);
							
						movingOn[i] = null;
					}
				}
			}
			
		}
		
				
		// Moves passenger on to next available machine
		private function gotoNext(index:uint):void {
			var pass:PassengerG = unitArray[index];
			
			
			if (station.getNext(index) == -1) {
				exitAirport(pass);
				unitArray[index] = null;
			} else if (station.spotArray[station.getNext(index)].logic.isFree()) {
				var unit:SecurityCheckUnitG = station.spotArray[station.getNext(index)];
				pass.setTarg((unit.x), (unit.y));
				pass.startWalk();
				unitArray[station.getNext(index)] = pass;
				unitArray[index] = null;
			}
		}
	
		// Scans with machines
		protected override function moveOn(pass:PassengerG):Boolean {
			var index:int = getPassNum(passArray, pass);
			
			if (station.logic.firstSecurityCheckUnitEmpty()) {
				var units:Sprite = station.spotArray[station.getFirst(0)];
				pass.setTarg(units.x, units.y);
				pass.startWalk();
				pass.logic.addEventListener(Passenger.CAUGHT, arrestHandler);
				pass.logic.addEventListener(Passenger.MOVEON, moveOnHandler)
				unitArray[station.getFirst(0)] = pass;
				//passArray[index] = null;
			} else if (station.getFirst(0) == -1) {
				exitAirport(pass);
				passArray[index] = null;
			} else {
				//trace("Station full!");
			}
			return true;
		}
		
		// Gets a passenger index equal to the passanger specified
		private function getPassNum(array:Array, pass:PassengerG):int {
			for (var i:int = 0; i < array.length; i++) {
				if (array[i] == pass) {
					return i;
				}
			}
			return -1;
		}
		
		// Moves on to next empty spot
		private function moveOnHandler(e:Event):void {
			for (var i:int = 0; i < unitArray.length; i++) {
				if (unitArray[i]) {
					if (unitArray[i].logic == e.target) {
						gotoNext(i);
						break;
					}
				}
			}
		}
		
		// Removes passenger if caught
		private function arrestHandler(e:Event):void {
			for (var i:int = 0; i < unitArray.length; i++) {
				if (unitArray[i]) {
					if (unitArray[i].logic == e.target) {
						if (station.personHolder.contains(unitArray[i])) {
							station.personHolder.removeChild(unitArray[i]);
						} else {
							this.removeChild(unitArray[i]);
						}
						TheGame.incrementNumPass();
						TheGame.incrementArrests();
						unitArray[i] = null;
					}
				}
			}
		}
		
		// Sends passenger to exit
		private function exitAirport(pass:PassengerG):void {
			//TEMP
			var units:Sprite = station.spotArray[4];
			movingOn.push(pass);
			pass.removeEventListener(Passenger.OUTOFTIME, passHandler);
			pass.removeEventListener(Passenger.OUTOFMOOD, passHandler);
			pass.setTarg(units.x+108, units.y-56);
			pass.startWalk();
		}
		
		// Removes passenger from line
		private function removePass(spot:int):void {
			this.removeChild(passArray[spot]);
			passArray[spot] = null;
		}
		
		// Handles when passenger runs out of time/mood
		private function passHandler(e:Event):void {
			e.target.removeEventListener(Passenger.OUTOFTIME, passHandler);
			e.target.removeEventListener(Passenger.OUTOFMOOD, passHandler);
			
			for (var i:int = 0; i < passArray.length; i++) {
				if (passArray[i]) {
					if (passArray[i].logic == e.target) {
						removePass(i);
						TheGame.incrementNumPass();
					}
				}
			}
		}
		
		// Receives a passenger and adds it to the line
		public override function receivePass(pass:PassengerG):Boolean // returns false if there is no space in line
		{
			if(passArray[0] == null) {
				this.addChild(pass);
				pass.x = pass.x-station.x;
				pass.y = pass.y-station.y;
				numInLine++;
				
				// Shove in frame entered!
				var spot:int = getLastFree();
				pass.setTarg(spotArray[spot].x, spotArray[spot].y);
				pass.noRedirect();
				pass.speed = 5;
				passArray[spot] = pass;
				logic.pushPassenger(pass.logic);
				pass.logic.addEventListener(Passenger.OUTOFTIME, passHandler);
				pass.logic.addEventListener(Passenger.OUTOFMOOD, passHandler);
				return true;
			}else{
				return false;
			}
		}
		
		// Checks whether line is not full
		public function isNotFull():Boolean {
			return (!passArray[0]);
		}
		
		// Gets the last free place in the line
		private function getLastFree():int {
			for (var i:int = 0; i < maxInLine; i++) {
				if (passArray[i] != null && i != 0) {
					return (i-1);
				}
			}
			return maxInLine-1;
		}
		
		// Deletes all passengers
		public function clearPasses():void {	
			for(var i:int = 0; i < passArray.length; i++) {
				if (passArray[i] != null) {
					passArray[i].killMe();
					this.removeChild(passArray[i]);
					passArray[i] = null;
				}
			}
			for(i = 0; i < unitArray.length; i++) {
				if (unitArray[i] != null) {
					unitArray[i].killMe();
					this.removeChild(unitArray[i]);
					unitArray[i] = null;
				}
			}
			for(i = 0; i < movingOn.length; i++) {
				if (movingOn[i] != null) {
					movingOn[i].killMe();
					this.removeChild(movingOn[i]);
					movingOn[i] = null;
				}
			}
		}
		
		// Gets line number
		public function getNum():uint {
			return myNum;
		}
	}
}