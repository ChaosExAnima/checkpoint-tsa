package gameUI {
	import gameControl.TheGame;
	import gameGraphics.*;
	import gameLogic.*;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	
	public class UnselectedMenu extends MovieClip implements IMenu {
		private var _menu:Menus;
		private var _mMenu:unselected_machine = new unselected_machine();
		private var _pMenu:unselected_person = new unselected_person();
		private var _icon:MovieClip;
		private var _subX:Number = 148;
		private var _subY:Number = 628;
		
		private static var _object; // Var that triggers which menu to show
		
		public function UnselectedMenu(menu:Menus):void {
			_menu = menu;
		}
		
		// Initializes menu
		public function init():void {
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, update);
			
			b_build.addEventListener(MouseEvent.CLICK, buildHandler);
			b_hotCold.addEventListener(MouseEvent.CLICK, hotColdHandler);
			b_options.addEventListener(MouseEvent.CLICK, optionsHandler);
		}
		
		// Cleans up listeners prior to removal
		public function cleanUp():void {
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, update);
			b_build.removeEventListener(MouseEvent.CLICK, buildHandler);
			b_hotCold.removeEventListener(MouseEvent.CLICK, hotColdHandler);
			b_options.removeEventListener(MouseEvent.CLICK, optionsHandler);
		}
		
		// Clears self and shows new build menu
		private function buildHandler(e:MouseEvent):void {
			_menu.playClick();
			_menu.setMenu(new BuildMenu(_menu));
		}		
		
		// Clears self and shows hot cold game
		private function hotColdHandler(e:MouseEvent):void {
			_menu.playClick();
			_menu.setMenu(new BombMenu(_menu));
		}
		
		// Shows options (TO DO)
		private function optionsHandler(e:MouseEvent):void {
			_menu.playClick();
			_menu.showOptions();
		}
		
		// Updating function that determines what is rolled over
		private function update(e:TimerEvent):void {
			var obj = _object;
			if (obj is SecurityCheckUnitG) {
				showMachine(obj as SecurityCheckUnitG);
			} else if (obj is PassengerG) {
				showPerson(obj as PassengerG);
			} else {
				showBlank();
			}
		}
		
		// Shows current machine stats
		private function showMachine(machine:SecurityCheckUnitG):void {
			showBlank();
			this.addChild(_mMenu);
			with (_mMenu) {
				x = _subX;
				y = _subY;
				t_name.text = machine.logic.getName();
				t_percent.text = String(machine.logic.getAccuracy())+"%";
				t_speed.text = String(machine.logic.getSpeed());
				icon_speed.visible = true;
				icon_speed.gotoAndStop(Math.min(machine.logic.getSpeed(), 40));
			}
			
			if(machine.logic.getSpeed() == 0) {
				_mMenu.t_speed.text = "";
				_mMenu.t_percent.text = "";
				_mMenu.icon_speed.visible = false;
			}
			setUpgradeStats(machine);
			pickPicture(machine);
			showOffenseIcons(machine.logic.getProhObjs());		
		}
		
		// Updates upgrade stats
		private function setUpgradeStats(machine:SecurityCheckUnitG):void {
			if (machine.upgradeAcc[0]) {
				_mMenu.t_upgrade1.text = "+"+String(machine.upgradeAcc[0])+"% vs";
			} else {
				_mMenu.t_upgrade1.text = "";
			}
			if (machine.upgradeAcc[1]) {
				_mMenu.t_upgrade2.text = "+"+String(machine.upgradeAcc[1])+"% vs";
			} else {
				_mMenu.t_upgrade2.text = "";
			}
			_mMenu.icon_upgrade1.gotoAndStop(machine.upgradeType[0]);
			_mMenu.icon_upgrade1a.gotoAndStop(machine.upgradeType[1]);
			_mMenu.icon_upgrade2.gotoAndStop(machine.upgradeType[2]);
		}
		
		// Sets the appropriate icon for the offenses.
		private function showOffenseIcons(oList:Array):void {
			// Tries to set icons for everything, and stops when array is done.
			// Probably should be done with ifs or something, but this is cooler.
			if (oList[0]) {
				_mMenu.icon_1.gotoAndStop(oList[0].getKindOfObj());
			} else {
				_mMenu.icon_1.gotoAndStop(1);
			}
			if (oList[1]) {
				_mMenu.icon_2.gotoAndStop(oList[1].getKindOfObj());
			} else {
				_mMenu.icon_2.gotoAndStop(1);
			}
			if (oList[2]) {
				_mMenu.icon_3.gotoAndStop(oList[2].getKindOfObj());
			} else {
				_mMenu.icon_3.gotoAndStop(1);
			}
			if (oList[3]) {
				_mMenu.icon_4.gotoAndStop(oList[3].getKindOfObj());
			} else {
				_mMenu.icon_4.gotoAndStop(1);
			}
		}
		
		// Picks what picture a machine has
		private function pickPicture(machine:SecurityCheckUnitG):void {
			if (machine is BagCheckerG) {
				showPicture(new icon_bagchecker());
			} else if (machine is CheepieXRayMachineG) {
				showPicture(new icon_xray());
			} else if (machine is DrugCanineG) {
				switch((machine.logic as Canine).getLevel()) {
					case 1:
						showPicture(new icon_drugdog());
						break;
					case 2:
						showPicture(new icon_drugbigdog());
						break;
					case 3:
						showPicture(new icon_drugpig());
						break;
				}
			} else if (machine is BombCanineG) {
				switch((machine.logic as Canine).getLevel()) {
					case 1:
						showPicture(new icon_bombdog());
						break;
					case 2:
						showPicture(new icon_bombbigdog());
						break;
					case 3:
						showPicture(new icon_bombpig());
						break;
				}
			} else if (machine is WandWaiverG) {
				showPicture(new icon_wandwaver());
			} else if (machine is CheepieMetalDetectorG) {
				showPicture(new icon_metaldetector());
			} else if (machine is SuperMetalDetectorG) {
				showPicture(new icon_supermetaldetector());
			} else if (machine is SuperXRayMachineG) {
				showPicture(new icon_superxray());
			} else if (machine is SnifferMachineG) {
				showPicture(new icon_sniffer());
			} else if (machine is ClownG) {
				showPicture(new icon_clown());
			} else if (machine is EntertainmentDisplayG) {
				showPicture(new icon_video());
			}
		}
		
		// Shows picture of machine
		private function showPicture(obj:MovieClip):void {
			if (_mMenu.picture.numChildren == 2) {
				_mMenu.picture.removeChild(_mMenu.picture.getChildAt(1));
			}
			_mMenu.picture.addChild(obj);
			obj.width = 80;
			obj.height = 80;
			obj.x = 0;
			obj.y = 5;
		}		

		// shows current person stats
		private function showPerson(person:PassengerG):void {
			var mood:int = person.logic.getMood();
			var time:int = person.logic.getTimeLeft()/3;

			showBlank();
			this.addChild(_pMenu);
			with (_pMenu) {
				x = _subX;
				y = _subY;
				t_name.text = person.name;
			}
			
			if (time > 40) {
				time = 40;
			}
			_pMenu.icon_time.gotoAndStop(time);
			
			if (mood <= 25) {
				_pMenu.icon_mood.gotoAndStop(4);
			} else if (mood <= 50) {
				_pMenu.icon_mood.gotoAndStop(3);
			} else if (mood <= 75) {
				_pMenu.icon_mood.gotoAndStop(2);
			} else if (75 < mood) {
				_pMenu.icon_mood.gotoAndStop(1);
			}
			
			//_menu.sndManager.playSound(person.sound);
		}
			
		// Clears menu
		private function showBlank():void {
			if (this.contains(_mMenu)) {
				this.removeChild(_mMenu);
			} else if (this.contains(_pMenu)) {
				this.removeChild(_pMenu);
			}
		}
		
		// Call if 
		public static function setMachine(type:SecurityCheckUnitG):void {
			_object = type;
		}
		
		public static function setPerson(type:PassengerG):void {
			_object = type;
		}
		
		public static function setBlank():void {
			_object = null;
		}
	}
}