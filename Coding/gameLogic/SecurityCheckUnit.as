package gameLogic {

import gameControl.TheGame;	
import gameData.XMLmachineData;
import flash.events.TimerEvent;
import flash.events.Event;
//try
import gameGraphics.SecurityCheckUnitG;
//out

/*	A SecurityCheckUnit models any kind of a Security Check unit, 
	which can be either a metal detector, X-ray machine, sniffing dogs or security personnel
*/
	public class SecurityCheckUnit {
		
		//This determines the NAME of the Unit, ie. BagChecker, BombCanine, DrugCanine, MetalDetector, etc.
		protected var unitName:String; 	
		//This determines the LEVEL OF ACCURACY that the Unit will have to find a prohibited object, this value is an integer set from 0 - 80
		protected var accuracy:int; 	
		//This determines the number of game tiks a unit needs to process a passenger.
		protected var speed:Number;		
		//This is a positive number determining the negative effect that this unit has on the passenger's mood being checked. (For Mood units negative number!)
		protected var mood:Number;
		//This determines the PRICE of the Unit that the Player BUYs for the game
		protected var price:int;		
		//This determines the PRICE of the Unit that the Player SELLs for the game
		protected var sellFor:int;		
		//The station the Security check unit belongs to.
		protected var station:Station; //assignment is done when Unit is being created in the Station class.
		//stores all prohibited Objetcts the Security check unit is looking for
		protected var prohObjs:Array; //<ProhibitedObject>
		
		//This is the number of game tiks a passenger has been in the security check unit.
		private var passInUnit:Number=0;
		//The current passenger in the unit
		private var pass:Passenger=null;
		//This stores, whether the Security Check unit has finished checking the passenger. (This can be true, but the passenger can still be in the Security Check Unit!)
		private var finished:Boolean=true;
		//This value stores, in what position this Security Check Units sits, ranges from 1-5
		private var position:int;
		
		//Stores, whether instaDetect is available or not
		protected var instaDetect:Boolean=false;
		//Used for instaDetect.
		private var beingCaught:Boolean=false;
		
		//try
		private var secCheckG:SecurityCheckUnitG;
		//out
		
		private var taken:Boolean = false;
		
		public function SecurityCheckUnit(unitName:String, accuracy:int, speed:Number, mood:Number, price:int, sellFor:int, prohObjs:Array) {
			this.unitName = unitName;
			this.accuracy = accuracy;
			this.speed = TheGame.minToGameTime(speed); //converted from spec seconds into game tiks
			this.mood = mood;
			this.price = price;
			this.sellFor = sellFor;
			this.prohObjs = prohObjs;
			this.price = price;
			
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, progressTime);
		}
		
		public function buy(val:int = 0):void {
			if (val == 0)
				val = price;
			TheGame.subtractMoney(val);
		}
		
		/*
		PRE: pObj is prohibited object or null, if passenger does not carry prohibited object
		PostCondition: The function returns false if the SecurityCheckUnits does not detect the prohibitedObject,
		and true if it does. (It returns also false, if it is not looking for the Input type of the prohibitedObject).
		E.g., if accuracy is 10%, there shall be a 10% chance of the prohibited object being found.
		If the prohibited Object is null, then it does not detect anything.
		*/
		protected function isCaught(pObj:ProhibitedObject):Boolean 
		{
			if(pObj == null) return false;
			if (prohObjs.some(testKindProhObjs)) 
			{
				var chance:Number = Math.random();
				if (chance<((accuracy * Airport.getSecurityAlertLevelMultiplier())/100)) 
					return true;
			}
			return false;					
			
			function testKindProhObjs(item:*, index:int, array:Array):Boolean {
				var elem:ProhibitedObject=item;
				return (elem.getKindOfObj() == pObj.getKindOfObj())
			}
		}
		
		// Sets machine is full
		public function isTaken():void {
			taken = true;
		}
		

		//PRE: Security Check Unit is empty.
		public function checkPassenger(passIn:Passenger):void {
			var tempPass:Passenger=passIn;
			finished = false;
			
			//try
			secCheckG.checking();
			//out
			
			tempPass.intoSecurityCheckUnit(this);
			tempPass.addEventListener(Passenger.OUTOFTIME, removePassenger);
			tempPass.addEventListener(Passenger.OUTOFMOOD, removePassenger);
			beingCaught=isCaught(tempPass.carriesWhat());
			passInUnit = 0;
			pass = tempPass;
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, progressTime);
			
			taken = true;
		}
		
		private function removePassenger(e:Event) {
			pass.removeEventListener(Passenger.OUTOFTIME, removePassenger);
			pass.removeEventListener(Passenger.OUTOFMOOD, removePassenger);
			pass = null;
			station.passOnPassenger(null, position);
			
			//try
			secCheckG.idle();
			//out
			taken = false;
		}
		
		//Simulates the progress of time in the Security check unit when checking a passenger.
		//Responsible for passing on passenger.
		private function progressTime(e:TimerEvent):void {
			if(pass!=null) {
				passInUnit++;
				
				if(finished != true && instaDetect == true && beingCaught == true) {
					finished = true;
					passCaught();
				}
				
				if(finished!=true&&passInUnit>=speed) {
					finished = true;
					if(instaDetect == false && beingCaught==true) {
						passCaught();
					}
					//try
					else {
						secCheckG.go();
					}
					//out
				}
				
				if(finished==true&&station.nextFree(position)) {
					var tempPass:Passenger = pass;
					
					station.passOnPassenger(tempPass, position);
					pass = null;
					taken = false;
					//trace (position + " (in progressTime): " + pass);
					TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, progressTime);
				}		
			}
		}
		
		
		private function passCaught():void {
			pass.removeEventListener(Passenger.OUTOFTIME, removePassenger);
			pass.removeEventListener(Passenger.OUTOFMOOD, removePassenger);
			pass.gotCaught();
			pass = null;
			
			station.passOnPassenger(null, position);
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, progressTime);
			//try
			secCheckG.caught();
			//out
			taken = false;
		}
		
		public function getAccuracy():int {
			return accuracy*Airport.getSecurityAlertLevelMultiplier();
		}
		
		//PRE: Only to be set by station. 1 <= position <= 5
		internal function setStationPosition(station:Station, position:int):void {
			this.station = station;
			this.position = position;
		}
		
		public function getSpeed():Number {
			return TheGame.gameToMinTime(speed*Airport.getSecurityAlertLevelMultiplier());
		}
	
		public function getMood():Number {
			return mood;
		}
		
		public function getSellFor():Number {
			return sellFor;
		}
		
		public function getName():String {
			return unitName;
		}
		
		//What happens to a passenger in it?
		public function sellIt():void {
			TheGame.addMoney(sellFor);
			station.removeSecurityCheckUnit(this);
		}	
		
		public function getProhObjs():Array {
			return prohObjs;
		}
		
		public function isFree():Boolean {
			return (!taken);
		}
		
		public function setSecCheckG(secCheckG:SecurityCheckUnitG) {
			this.secCheckG = secCheckG;
		}
	}
}