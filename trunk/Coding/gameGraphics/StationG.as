package gameGraphics {
	import flash.display.Sprite;
	import flash.display.*;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.events.*;
	import flash.display.Stage;
	import gameLogic.*;
	import gameUI.*;

	
	/* This class initially contains the empty (graphical) spots of a station, which by user interaction
	   are filled with graphical Security check units. It also contains its logical representation.
	   (A station is one(!) row of five (to six) Security Check Units.) 
	*/
	public class StationG extends Sprite {
		
		//Five spots for either a graphic symbolizing an empty spot or the graphical representation of a Security Check Unit
		private var spot1:GSpot;
		private var spot2:GSpot;
		private var spot3:GSpot;
		private var spot4:GSpot;
		private var spot5:GSpot;
		
		private var spotNum:Number = -1;
		
		private var spots:Array = new Array(5); //contains sprites! //No it doesn't!
		
		//logical representation of station
		private var stationL:Station;
		
		private var _lineG:LineG;
		private var _personHolder:Sprite = new Sprite();
		
		public function StationG(number:int) {
			stationL = Airport.addStation(number+1);
			for (var i:int=0;i<5;i++) {
				spots[i] = new GSpot();
				spots[i].x = 108*i;
				spots[i].y = 56*-i;
				addChild(spots[i]);
				spots[i].alpha=0.5;
				spots[i].addEventListener(MouseEvent.MOUSE_OVER, rollO);
				spots[i].addEventListener(MouseEvent.MOUSE_OUT, rollOt);
			}
			
			_lineG = new LineG(this);
			this.addChild(_lineG);
			this.addChild(_personHolder);
		}
		
		//Adds a security check unit to a specific spot and makes the original spots disappear
		public function addSecurityCheckUnitG(secCheckG:SecurityCheckUnitG, num:int):void {

			var newX = this.spots[num].x;
			var newY = this.spots[num].y;
			
			this.spots[num].removeEventListener(MouseEvent.MOUSE_OVER, rollO);
			this.spots[num].removeEventListener(MouseEvent.MOUSE_OUT, rollOt);
			removeChild(this.spots[num]);
			
			this.spots[num] = secCheckG;
			stationL.addSecurityCheckUnit(secCheckG.logic, num+1);
			secCheckG.spot = num;
			
			this.spots[num].x = newX;
			this.spots[num].y = newY;
			
			addChild(this.spots[num]);
			addChild(_personHolder);
			
			this.spots[num].addEventListener(MouseEvent.MOUSE_OVER, machineOver);
			this.spots[num].addEventListener(MouseEvent.MOUSE_OUT, machineOut);
			this.spots[num].addEventListener(MouseEvent.CLICK, machineSelect);
			
		}
		
		//Removes the security check unit and replaces it by the original shape in place. 
		public function removeSecurityCheckUnitG(num:int):void {
			var newX = this.spots[num].x;
			var newY = this.spots[num].y;
			
			this.spots[num].removeEventListener(MouseEvent.MOUSE_OVER, machineOver);
			this.spots[num].removeEventListener(MouseEvent.MOUSE_OUT, machineOut);
			this.spots[num].removeEventListener(MouseEvent.CLICK, machineSelect);
			removeChild(this.spots[num]);
			
			this.spots[num] = new GSpot();
			
			this.spots[num].x = newX;
			this.spots[num].y = newY;
			
			addChild(this.spots[num]);
			addChild(_personHolder);
			
			this.spots[num].alpha=0.5;
			this.spots[num].addEventListener(MouseEvent.MOUSE_OVER, rollO);
			this.spots[num].addEventListener(MouseEvent.MOUSE_OUT, rollOt);
			
			hideSpots();
		}
		
		// Gets the first available machine
		public function getFirst(num:int):int {
			for (var i:int = num; i<4; i++) {
				if (!(spots[i] is GSpot)) {
					return i;
				}
			}
			//trace("No machines found!");
			return -1;
		}
		
		// Gets next available machine
		public function getNext(num:int):int {
			for (var i:int = num+1; i<4; i++) {
				if (!(spots[i] is GSpot)) {
					return i;
				}
			}
			//trace("No machines found!");
			return -1;
		}
		
		// Checks if machine exists at a spot
		public function checkSpot(num:int):Boolean {
			return (!(spots[num] is GSpot));
		}
		
		// Returns the station number of this instance
		public function whichStationNum():Number
		{	
			return this.stationL.getNumber();
		}
		
		// Hides visible GSpots
		public function hideSpots():void {
			for each (var spot:Sprite in spots) {
				if (spot is GSpot) {
					spot.visible = false;
				}
			}
		}
		
		// Displays hidden GSpots
		public function showSpots():void {
			for each (var spot:Sprite in spots) {
				if (spot is GSpot) {
					spot.visible = true;
				}
			}
		}
		
		// Get the spot mouse is over
		public function getspotNum():Number
		{
			return spotNum;
		}
		
		// Getter for spot array
		public function get spotArray():Array {
			return spots;
		}
		
		// Returns graphical instance of a spot
		public function getspotSprite(num:int):Sprite
		{
			return spots[num];
		}
		
		// Rollover function for blank spot
		private function rollO(e:MouseEvent):Number
		{
			var spot = e.currentTarget;			
			spot.alpha = 0.75;
			for(var i:int=0;i<spots.length;i++) {
				if(spots[i]==spot)
				{	
					spotNum = i;
					return i;
				}
			}
			spotNum = -1;
			return -1;
		}

		// Rollout function for blank spot
		private function rollOt(e:MouseEvent):void
		{
			var spot = e.currentTarget;			
			spot.alpha = 0.50;	
			spotNum = -1;
		}
		
		// Triggers update of unselected UI on rollover
		private function machineOver(e:MouseEvent):void {
			UnselectedMenu.setMachine(e.currentTarget as SecurityCheckUnitG);
		}
		
		// Clears unselected UI on rollout
		private function machineOut(e:MouseEvent):void {
			UnselectedMenu.setBlank();
		}
		
		// Shows the selection menu
		private function machineSelect(e:MouseEvent):void {
			var menu:Menus = MovieClip(root).menus;
			menu.setMenu(new SelectedMenu(menu, e.currentTarget as SecurityCheckUnitG));
		}
		
		public function get logic():Station {
			return stationL;
		}
		
		public function get line():LineG {
			return _lineG;
		}
		
		public function get personHolder():Sprite {
			return _personHolder;
		}
	}	
}