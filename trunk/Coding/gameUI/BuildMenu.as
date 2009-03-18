package gameUI {
	import gameControl.TheGame;
	import gameData.*;
	import gameGraphics.*;
	import gameUI.Interface;
	import flash.geom.ColorTransform;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import fl.controls.Button;
	
	public class BuildMenu extends MovieClip implements IMenu {
		private var _buttons:Array = new Array(); //Array that contains all the button references
		private var _menu:Menus; //Game area interface. Contains stuff like stations, etc.
		private var _gameXML:XMLgameData;
		private var _machineXML:XMLmachineData;
		private var _UI:Interface;
		private var _money:int;
		
		//----------------------------------BUILD MENU SETUP ------------------------------------//
		
		public function BuildMenu(menu:Menus):void {
			_menu = menu;
			_gameXML = _menu.gameData;
			_machineXML = _menu.machineData;
			_UI = _menu.UI;
			_buttons.push(BagChecker, Clown, WandWaver, CheepieXrayMachine, SuperXrayMachine, CheepieMetalDetector, SuperMetalDetector, SnifferMachine, DrugCanine, BombCanine, TicketChecker, VideoDisplay);
			_money = TheGame.getMoney();
		}
		
		// Initialization
		public function init():void {
			for each (var button:Sprite in _buttons) {
				button.addEventListener(MouseEvent.MOUSE_OVER, dispMachineData);
			}
			_UI.showStations();
			showAvailableUnits();
			clearDispData();
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, update);
		}
		
		public function cleanUp():void {
			for each (var button:Sprite in _buttons) {
				button.removeEventListener(MouseEvent.MOUSE_OVER, dispMachineData);
			}
			_UI.hideStations();
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, update);
		}
		
		// Used to update button availablity if money changed
		private function update(e:TimerEvent):void {
			if (_money != TheGame.getMoney()) {
				showAvailableUnits();
			}
		}
		
		// Disables either one or all build buttons
		private function disableUnits(machine:Object = null):void {
			if (!machine) {
				machine = _buttons;
			}
			
			for each (var button:Button in machine) {
				button.enabled = false;
				if (button.hasEventListener(MouseEvent.CLICK)) {
					button.removeEventListener(MouseEvent.CLICK, createMachine);
				}
			}
		}
		
		// Converts text reference to machine button ref
		private function getMachine(machine:String):Button {
			for each (var obj:Button in _buttons) {
				if (machine == obj.name) {
					return (obj);
				}
			}
			return null;
		}
		
		// Disables any units that are either not allowed for the level or inaffordable
		private function showAvailableUnits():void {
			disableUnits();
			
			// Breaks if XMLGameData isn't loaded first!
			for each (var item:String in _gameXML.getLevel(Interface.GAMELEVEL, "items")) {
				var machine:Button;
				if (item != "NewLine") {
					machine = getMachine(item);
					if(TheGame.affordable(Number(XMLmachineData.getXML(item, "price")))) {
						machine.enabled = true;
						machine.addEventListener(MouseEvent.CLICK, createMachine);
					} else {
						disableUnits(machine);
					}
				}
			}
		}
		
		//---------------------------------- CREATES A NEW MACHINE ------------------------------------//		
		
		// Generates a machine 
		private function createMachine(e:MouseEvent):void {
			var unit:SecurityCheckUnitG;
			switch (e.target.name) {
				case "CheepieXrayMachine":
					unit = new CheepieXRayMachineG(0, 0);
					break;
				case "BagChecker":
					unit = new BagCheckerG(0, 0);
					break;
				case "BombCanine":
					unit = new BombCanineG(0, 0);
					break;
				case "CheepieMetalDetector":
					unit = new CheepieMetalDetectorG(0, 0);
					break;
				case "Clown":
					unit = new ClownG(0, 0);
					break;
				case "DrugCanine":
					unit = new DrugCanineG(0, 0);
					break;
				case "VideoDisplay":
					unit = new EntertainmentDisplayG(0, 0);
					break;
				case "SuperMetalDetector":
					unit = new SuperMetalDetectorG(0, 0);
					break;
				case "SuperXrayMachine":
					unit = new SuperXRayMachineG(0, 0);
					break;
				case "SnifferMachine":
					unit = new SnifferMachineG(0, 0);
					break;
				case "WandWaver":
					unit = new WandWaiverG(0, 0);
					break;
				default:
					trace("createMachine function passed invalid name!");
					break;
			}
			_menu.playClick();
			setUpSecCheckUnit(unit);
		}
		
		// Sets up security unit
		private function setUpSecCheckUnit(unit:SecurityCheckUnitG):void {
			disableUnits();
			var area:AirportG = _UI.uiAirport;
			area.addChild(unit);
			_UI.gSecCheckUnit = unit;
			with (unit) {
				x = area.mouseX - unit.width/2;
				y = area.mouseY - unit.height/2;
				startDrag(true);
				transform.colorTransform = new ColorTransform(.8,.8,.8,0.5,100,0,0,0);
			}
			for each (var line:StationG in _UI.stations) {
				for each (var spot:Sprite in line.spotArray) {
					if (spot is GSpot) {
						spot.addEventListener(MouseEvent.CLICK, placeMachine);
					}
				}
			}			
		}
		
		//Stops drag and plunks machine down
		private function placeMachine(event:Event):void {
			var unit:SecurityCheckUnitG = _UI.gSecCheckUnit;
			var station:StationG = _UI.getStation();

			for each (var line:StationG in _UI.stations) {
				for each (var spot:Sprite in line.spotArray) {
					if (spot is GSpot) {
						spot.removeEventListener(MouseEvent.CLICK, placeMachine);
					}
				}
			}			

			station.addSecurityCheckUnitG(unit, station.getspotNum());
			unit.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
			_UI.gSecCheckUnit = null;
			showAvailableUnits();
			_menu.setMenu(new UnselectedMenu(_menu));
		}

		//-----------------------------MACHINE INFO DISPLAY----------------------------------//
		
		// Given a string divided by offenses, then sets the appropriate icon.
		private function showOffenseIcons(oList:String):void {
			var pObjectList:Array = oList.split(',');
			
			// Tries to set icons for everything, and stops when array is done.
			// Probably should be done with if or something, but this is cooler.
			try {
				this.icon_1.gotoAndStop(pObjectList[0]);
				this.icon_2.gotoAndStop(pObjectList[1]);
				this.icon_3.gotoAndStop(pObjectList[2]);
				this.icon_4.gotoAndStop(pObjectList[3]);
			} catch(e:Error) {}
		}
		
		// Clears info box area
		private function clearDispData():void {
			this.unitName.text = "";
			this.unitPrice.text = "";
			this.unitAccuracy.text = "";
			this.icon_1.gotoAndStop(1); //Frame 1 is blank
			this.icon_2.gotoAndStop(1);
			this.icon_3.gotoAndStop(1);
			this.icon_4.gotoAndStop(1);
		}
		
		// Function to display machine info on rollover
		private function dispMachineData(e:MouseEvent):void {
			var machName:String = e.currentTarget.name; //Button instance name
			clearDispData();
			
			this.unitName.text = XMLmachineData.getXML(machName,"name");
			
			// If you can't afford the machine, set price color to red.
			var price:int;
			if (int(XMLmachineData.getXML(machName,"price")) > TheGame.getMoney()) {
				this.unitPrice.textColor = 0xFF0000;
			} else {
				this.unitPrice.textColor = 0XFFFFFF;
			}
			this.unitPrice.text = "$"+XMLmachineData.getXML(machName,"price");
			
			this.unitAccuracy.text = XMLmachineData.getXML(machName,"accuracy")+"% vs:";
			if (XMLmachineData.getXML(machName,"accuracy") == "") {
				this.unitAccuracy.text = "";
			} else {
				showOffenseIcons(XMLmachineData.getXML(machName,"offenses"));	
			}
		}
	}
}
		/**/