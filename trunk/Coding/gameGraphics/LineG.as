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
				//this.addChild(Utilities.addMark(pX, pY)); // TEMP
				pX += 40;
				pY -= 20;
			}
			
			spaceW = xTrav/passArray.length;
			spaceH = yTrav/passArray.length;
			
			xSpeed = speed*(xTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			ySpeed = speed*(yTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
		
		
		
		// Moves passengers along
		private function frameEntered(e:Event):void {
			// Waiting in line section
			var person:PassengerG;
			for(var i:int = 0; i < passArray.length; i++) {
				if (passArray[i]) {
					passArray[i].tStep();
					if (passArray[i].obsolete == true) { // No more targets!
						passArray[i].stopWalk();
						if (i == maxInLine-1) { // At the head of line
							if ((station.getFirst(0) == -1)||(station.spotArray[station.getFirst(0)].logic.oncoming == false)) { // Next machine is free
								moveOn(passArray[i]); // Moves pass onto machines
								passArray[i] = null; // Removes ref to pass in line
							}
						} else if (!passArray[i+1]) { // Look for empty spots ahead and moves pass up
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
				if (unitArray[i]) { // If not null...
					unitArray[i].tStep(); // Walk
					if (unitArray[i].obsolete) { // No more waypoints
						var unit:SecurityCheckUnit = station.spotArray[i].logic;
						if (unit.isFree()) { // Is machine free?
							unitArray[i].stopWalk(); // Stop
							unit.checkPassenger(unitArray[i].logic); // Scan me
						}
					}
				}
			}
			
			// Leaving airport
			for (i = 0; i < movingOn.length; i++) {
				if (movingOn[i]) {
					person = movingOn[i];
					person.tStep();

					if (person.obsolete) {
						TheGame.incrementNumPass();
						this.addChild(person);
						this.removeChild(person);
						person.logic.goToPlane();
						movingOn[i] = null;
					}
				}
			}
		}
		
			
		// Moves passenger on to next available machine
		private function gotoNext(index:uint):void {
			var pass:PassengerG = unitArray[index];
						
			if (station.getNext(index) == -1) { // No more machines...
				exitAirport(pass); // Exit the airport
				unitArray[index] = null;
			} else if (station.spotArray[station.getNext(index)].logic.isFree()) { // Next machine exists and is free
				var unit:SecurityCheckUnitG = station.spotArray[station.getNext(index)]; // Get next machine
				pass.setTarg(unit.x, unit.y);
				pass.startWalk();
				unitArray[station.getNext(index)] = pass;
				unitArray[index] = null;
			}
		}
	
		// Scans with machines
		protected override function moveOn(pass:PassengerG):Boolean {
			var index:int = getPassNum(passArray, pass); // Finds index to pass in line
			
			if (station.logic.firstSecurityCheckUnitEmpty()) { // If the first machine is free...
				var units:Sprite = station.spotArray[station.getFirst(0)]; // Get the spot of the first machine
				pass.setTarg(units.x, units.y); // And set the person to walk to it
				pass.startWalk();
				pass.logic.addEventListener(Passenger.CAUGHT, arrestHandler); // Handle being caught and being passed 
				pass.logic.addEventListener(Passenger.MOVEON, moveOnHandler);
				unitArray[station.getFirst(0)] = pass; // Puts pass in unitArray
				station.spotArray[station.getFirst(0)].logic.oncoming = true; // Tells the pass to stop walking
				passArray[index] = null;
			} else if (station.getFirst(0) == -1) { // No machines?
				exitAirport(pass); // Exit the airport!
				passArray[index] = null;
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
						this.addChild(unitArray[i]);
						this.removeChild(unitArray[i]);
						TheGame.incrementNumPass();
						TheGame.incrementArrests();
						unitArray[i] = null;
					}
				}
			}
		}
		
		// Sends passenger to exit
		private function exitAirport(pass:PassengerG):void {
			var units:Sprite = station.spotArray[4];
			movingOn.push(pass);
			pass.removeEventListener(Passenger.OUTOFTIME, passHandler);
			pass.removeEventListener(Passenger.OUTOFMOOD, passHandler);
			pass.logic.removeEventListener(Passenger.CAUGHT, arrestHandler); // Handle being caught and being passed 
			pass.logic.removeEventListener(Passenger.MOVEON, moveOnHandler);
			pass.setTarg(units.x+108, units.y-56);
			pass.startWalk();
		}
		
		// Removes passenger from line
		private function removePass(pass:PassengerG):void {
			var spot:int;
			if (getPassNum(passArray, pass) != -1) {
				spot = getPassNum(passArray, pass);
				this.addChild(passArray[spot]);
				this.removeChild(passArray[spot]);
				passArray[spot] = null;
			} else if (getPassNum(unitArray, pass) != -1) {
				spot = getPassNum(unitArray, pass);
				this.addChild(unitArray[spot]);
				this.removeChild(unitArray[spot]);
				unitArray[spot] = null;
			} else if (getPassNum(movingOn, pass) != -1) {
				spot = getPassNum(movingOn, pass);
				this.addChild(movingOn[spot]);
				this.removeChild(movingOn[spot]);
				movingOn[spot] = null;
			} else {
				trace ("ERROR! Passenger not found!");
			}
		}
		
		// Handles when passenger runs out of time/mood
		private function passHandler(e:Event):void {
			e.target.removeEventListener(Passenger.OUTOFTIME, passHandler);
			e.target.removeEventListener(Passenger.OUTOFMOOD, passHandler);

			for (var i:int = 0; i < passArray.length; i++) {
				if (passArray[i]) {
					if (passArray[i].logic == e.target) {
						removePass(passArray[i]);
						TheGame.incrementNumPass();
					}
				}
			}
			
			for (i = 0; i < unitArray.length; i++) {
				if (unitArray[i]) {
					if (unitArray[i].logic == e.target) {
						removePass(unitArray[i]);
						TheGame.incrementNumPass();
					}
				}
			}
			
			for (i = 0; i < movingOn.length; i++) {
				if (movingOn[i]) {
					if (movingOn[i].logic == e.target) {
						removePass(movingOn[i]);
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
				
				pass.mouseEnabled = false;
				pass.mouseChildren = false;
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
					this.addChild(passArray[i]);
					this.removeChild(passArray[i]);
					removeListeners(passArray[i]);
					passArray[i] = null;
				}
			}
			for(i = 0; i < unitArray.length; i++) {
				if (unitArray[i] != null) {
					unitArray[i].killMe();
					this.addChild(unitArray[i]);
					this.removeChild(unitArray[i]);
					removeListeners(unitArray[i]);
					unitArray[i] = null;
				}
			}
			for(i = 0; i < movingOn.length; i++) {
				if (movingOn[i] != null) {
					movingOn[i].killMe();
					this.addChild(movingOn[i]);
					this.removeChild(movingOn[i]);
					removeListeners(movingOn[i]);
					movingOn[i] = null;
				}
			}
		}
		
		private function removeListeners(pass:PassengerG):void {
			pass.removeEventListener(Passenger.OUTOFTIME, passHandler);
			pass.removeEventListener(Passenger.OUTOFMOOD, passHandler);
			pass.logic.removeEventListener(Passenger.CAUGHT, arrestHandler); // Handle being caught and being passed 
			pass.logic.removeEventListener(Passenger.MOVEON, moveOnHandler);
		}
		
		// Gets line number
		public function getNum():uint {
			return myNum;
		}
		
		public function disableMouseTarget():void
		{
			var i:int = 0;
			for(i = 0; i<passArray.length; i++)
			{
				if(passArray[i])
				{
					passArray[i].mouseEnabled = false;
					passArray[i].mouseChildren = false;
				}
			}
			for(i = 0; i<unitArray.length; i++)
			{
				if(unitArray[i])
				{
					unitArray[i].mouseEnabled = false;
					unitArray[i].mouseChildren = false;
				}
			}
		}
		
		public function enableMouseTarget():void
		{
			var i:int = 0;
			for(i = 0; i<passArray.length; i++)
			{
				if(passArray[i])
				{
					passArray[i].mouseEnabled = true;
					passArray[i].mouseChildren = true;
				}
			}
			for(i = 0; i<unitArray.length; i++)
			{
				if(unitArray[i])
				{
					unitArray[i].mouseEnabled = true;
					unitArray[i].mouseChildren = true;
				}
			}
		}
	}
}