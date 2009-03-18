package gameUI {
	import gameControl.TheGame;
	import gameData.*
	import gameLogic.*;
	import gameGraphics.*;
	import flash.events.TimerEvent;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.ui.Mouse;

	
	public class Interface extends MovieClip {
		public var uiAirport:AirportG = new AirportG();
		public static var GAMELEVEL:Number = 6;//GAMELEVEL should have dynamic input from XMLgameData.
		public var stations:Array; //Array containing lines
		private var whichStation:int = -1;
		public var gSecCheckUnit:SecurityCheckUnitG;
		
		public function Interface():void {
			this.addChild(uiAirport);
						
			var sX:int = 1220;
			var sY:int = 340;
			var uiStation1:StationG = new StationG(1);
			var uiStation2:StationG = new StationG(2);
			var uiStation3:StationG = new StationG(3);
			var uiStation4:StationG = new StationG(4);
			var uiStation5:StationG = new StationG(5);
			stations = new Array(uiStation1, uiStation2, uiStation3, uiStation4, uiStation5);

			for each (var station:StationG in stations) {
				station.x = sX;
				station.y = sY;
				station.hideSpots();
				sX += 108;
				sY += 56;
				uiAirport.addChild(station);
			}
		}
		
		// Shows stations to place units. 
		public function showStations():void {
			for each(var station:StationG in stations) {
				station.showSpots();
				station.addEventListener(MouseEvent.MOUSE_OVER, getStationNum);
				station.addEventListener(MouseEvent.MOUSE_OUT, offStation);
			}
		}
		
		// Hides stations
		public function hideStations():void {
			for each (var station:StationG in stations) {
				station.hideSpots();
				station.removeEventListener(MouseEvent.MOUSE_OVER, getStationNum);
				station.removeEventListener(MouseEvent.MOUSE_OUT, offStation);
			}
		}
		
		// Gets a reference to a station. With no arguements, it returns the current station.
		public function getStation(num:int = -1):StationG {
			if (num == -1) {
				num = whichStation-1;
			}
			return(stations[num]);
		}
		
		// Gets current station number
		private function getStationNum(e:MouseEvent):void
		{
			var targetStation:StationG = e.currentTarget as StationG;
			whichStation = targetStation.whichStationNum();
		
			if (gSecCheckUnit) {
				if (targetStation.getspotSprite(targetStation.getspotNum()) is GSpot) {
					var spot:Sprite = targetStation.getspotSprite(targetStation.getspotNum());
					with (gSecCheckUnit) {
						stopDrag();
						transform.colorTransform = new ColorTransform(.8,.8,0.8,0.5,0,100,0,0);
						x = spot.x;
						y = spot.y;
					}
					targetStation.addChild(gSecCheckUnit);
				} else {
					trace("Not a GSpot!");
				}
			}
		}
		
		// Clears current station number
		private function offStation(e:MouseEvent):void
		{
			var targetStation:StationG = e.currentTarget as StationG;
			
			if (gSecCheckUnit) {
				addChild(gSecCheckUnit);
				gSecCheckUnit.startDrag(true);
				gSecCheckUnit.transform.colorTransform = new ColorTransform(.8,.8,0.8,0.5,100,0,0,0);
			}
		}
	}
}