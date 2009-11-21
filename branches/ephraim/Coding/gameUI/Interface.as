package gameUI {
	import gameControl.*;
	import gameData.*
	import gameLogic.*;
	import gameGraphics.*;
	import utilities.*;
	import flash.events.TimerEvent;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.ui.Mouse;

	
	public class Interface extends MovieClip {
		private var uiAirport:AirportG = new AirportG();
		public var stations:Array; //Array containing lines
		private var whichStation:int = -1;
		public var gSecCheckUnit:SecurityCheckUnitG;
		public var lineOutline:selected_station;
		private var _menus:Menus;
		private var passPercent:int = 20;
		
		public function Interface():void {
			Globals.UI = this;
			this.addChild(uiAirport);
						
			var sX:int = 1220;
			var sY:int = 340;
			
			lineOutline = new selected_station();
			this.addChild(lineOutline);
			lineOutline.alpha = 0;
			lineOutline.addEventListener(MouseEvent.MOUSE_OVER, lineShow);
			lineOutline.addEventListener(MouseEvent.MOUSE_OUT, lineHide);
			addStation();
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, onGameTik);
			
		}
		
		
		private function onGameTik(e:TimerEvent):void {
			var rand:int = Utilities.randRange(0, 99);
			
			if (rand < passPercent) {
				uiAirport.addPass();
			}
			
			if(XMLgameData.gameXML)
			{
				var maxPass:int = XMLgameData.gameXML.game.(@level == TheGame.getLevel()).passengers.text();
				
				if (TheGame.getNumPass() > maxPass) 
				{
					uiAirport.clearPasses();
					_menus.winMenu();
				}
			}
			
			if ((TheGame.getReputation() <= 0) || (TheGame.getMoney() <= 0)) {
				uiAirport.clearPasses();
				_menus.loseMenu();
			}
		}
		
		public function getNumStations():int {
			return (stations.length);
		}
				
		private function lineShow(e:MouseEvent):void {
			lineOutline.alpha = 1;
		}
		
		private function lineHide(e:MouseEvent):void {
			lineOutline.alpha = 0;
		}
		
		public function addStation():void {
			uiAirport.addLine();
			stations = uiAirport.lines;
			
			lineOutline.x = 1220+(108*stations.length);
			lineOutline.y = 340+(56*stations.length);
			lineOutline.alpha = 0;
			if (stations.length == 5) {
				this.removeChild(lineOutline);
			}
		}
		
		public function resetStation():void {
			lineOutline.x = 1220+108;
			lineOutline.y = 340+56;
		}
			
		// Shows stations to place units. 
		public function showStations():void {
			for each(var line:StationG in stations) {
				line.showSpots();
				line.addEventListener(MouseEvent.MOUSE_OVER, getStationNum);
				line.addEventListener(MouseEvent.MOUSE_OUT, offStation);
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
				num = whichStation;
			}
			return(stations[num-1]);
		}
		
		// Gets current station number
		private function getStationNum(e:MouseEvent):void {
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
		
		public function get menus():Menus {
			return (_menus);
		}
		
		public function set menus(val:Menus):void {
			_menus = val;
		}
		
		public function get airport():AirportG {
			return uiAirport;
		}
	}
}