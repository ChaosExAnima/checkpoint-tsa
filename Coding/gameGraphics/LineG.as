﻿package gameGraphics {
	import utilities.*;
	import gameGraphics.PassengerG;
	import gameGraphics.StationG;
	import gameLogic.*;	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;

	
	public class LineG extends Sprite {
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
			
			var pX:int = -(maxInLine*40);
			var pY:int = (maxInLine*20);
			
			for(var i:int = 0; i<maxInLine; i++) {
				passArray.push(null);
				spotArray.push(new Point(pX, pY));
				addMark(pX, pY); // TEMP
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
			for(var i:int = 0; i < passArray.length; i++) {
				if (passArray[i] != null) {
					passArray[i].tStep();
					if (passArray[i].obsolete == true) { // No more targets!
						passArray[i].stopWalk();
						if (i == maxInLine-1) { // At the head of line
							moveOn(maxInLine-1);
						} else if (!passArray[i+1]) { // Look for empty spots ahead
							passArray[i].setTarg(spotArray[i+1].x, spotArray[i+1].y);
							passArray[i].startWalk();
							passArray[i+1] = passArray[i];
							passArray[i] = null;
						}
					}
				}
			}
			
			for (i = 0; i < unitArray.length; i++) {
				if (unitArray[i]) {
					unitArray[i].tStep();
					if (unitArray[i].obsolete) {
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
			
			for (i = 0; i < movingOn.length; i++) {
				if (movingOn[i]) {
					movingOn[i].tStep();
					if (movingOn[i].obsolete) {
						trace("Left the airport!");
						this.removeChild(movingOn[i]);
						movingOn[i] = null;
					}
				}
			}
		}
		
		// Moves passenger on to next available machine
		private function gotoNext(index:uint):void {
			var pass:PassengerG = unitArray[index];
			var unit:SecurityCheckUnitG = station.spotArray[station.getFirst(index)];
			trace("Next free: "+station.getFirst(index));
			if (station.getFirst(index) == -1) {
				exitAirport(pass);
				unitArray[index] = null;
			} else if (unit.logic.isFree()) {
				pass.setTarg((unit.x+(unit.width/2)), (unit.y+(unit.height/2)));
				pass.startWalk();
				unitArray[station.getFirst(index)] = pass;
				unitArray[index] = null;
			}
		}
	
		// Scans with machines
		private function moveOn(index:uint):void {
			var pass:PassengerG = passArray[index];
			
			if (station.logic.firstSecurityCheckUnitEmpty()) {
				trace("Target station: "+station.getFirst(0));
				var units:Sprite = station.spotArray[station.getFirst(0)];
				pass.setTarg((units.x+(units.width/2)), (units.y+(units.height/2)));
				pass.startWalk();
				pass.logic.addEventListener(Passenger.CAUGHT, arrestHandler);
				pass.logic.addEventListener(Passenger.MOVEON, moveOnHandler)
				unitArray[station.getFirst(0)] = pass;
				passArray[index] = null;
			} else if (station.getFirst(0) == -1) {
				exitAirport(pass);
				passArray[index] = null;
			} else {
				trace("Station full!");
			}
		}
		
		// Moves on to next empty spot
		private function moveOnHandler(e:Event):void {
			trace("MOVEON triggered!");
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
			trace("CAUGHT!");
			for (var i:int = 0; i < unitArray.length; i++) {
				if (unitArray[i]) {
					if (unitArray[i].logic == e.target) {
						this.removeChild(unitArray[i]);
						unitArray[i] = null;
					}
				}
			}
		}
		
		// Sends passenger to exit
		private function exitAirport(pass:PassengerG):void {
			//TEMP
			var units:Sprite = station.spotArray[4];
			trace("Leaving airport!");
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
					}
				}
			}
		}
		
		// Receives a passenger and adds it to the line
		public function receivePass(pass:PassengerG):Boolean // returns false if there is no space in line
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
				passArray[spot] = pass;
				logic.pushPassenger(pass.logic);
				pass.logic.addEventListener(Passenger.OUTOFTIME, passHandler);
				pass.logic.addEventListener(Passenger.OUTOFMOOD, passHandler);
				return true;
			}else{
				return false;
			}
		}
		
		// Gets the last free place in the line
		private function getLastFree():int {
			for (var i:int = 0; i < maxInLine; i++) {
				if (passArray[i] != null && i != 0) {
					return (i-1);
				}
			}
			trace("returning start of line");
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
		}
		
		// Gets line number
		public function getNum():uint {
			return myNum;
		}
	}
}