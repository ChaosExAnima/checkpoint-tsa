package gameUI {
	import gameUI.Menus;
	import gameGraphics.*;
	import gameControl.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	
	public class SelectedMenu extends MovieClip implements IMenu {
		private var _menu:Menus;
		private var _button1:Button;
		private var _button2:Button;
		private var _cancel:Button;
		private var _machine:SecurityCheckUnitG;
		private var _delay:Boolean = false;
		
		public function SelectedMenu(menu:Menus, machine:SecurityCheckUnitG):void {
			_menu = menu;
			_machine = machine;
		}
		
		public function init():void {
			showButtons();
			showUpgrades();
			_menu.UI.parent.addEventListener(MouseEvent.CLICK, deselect);
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, update);
			setStats();
			if (_machine is SliderMachineG) {
				slider.setSliderVal((_machine.logic as SliderMachine).getSlideVal());
				slider.registerAlert(updateStats);
			} else {
				slider.visible = false;
				icon_speed.visible = false;
				icon_defense.visible = false;
			}
		}
		
		public function cleanUp():void {
			_menu.UI.parent.removeEventListener(MouseEvent.CLICK, deselect);
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, update);
		}
			
			
		private function update(e:TimerEvent):void {
			setStats();
		}
		
		private function setStats():void {
			t_name.text = _machine.logic.getName();
			t_percent.text = String(_machine.logic.getAccuracy())+"% vs";
			t_time.text = String(Math.round(_machine.logic.getSpeed()));
			_cancel.label = "Sell for $"+String(_machine.logic.getSellFor());
			icon_time.gotoAndStop(Math.min(Math.round(_machine.logic.getSpeed()), 40));
			
			if (_machine is MoodUnitG) {
				t_percent.text = "";
				t_time.text = "";
				icon_time.visible = false;
			}
			
			setUpgradeStats();
			showOffenseIcons(_machine.logic.getProhObjs());
			pickPicture();
		}
		
		private function updateStats(val:int):void {
			(_machine.logic as SliderMachine).accSpeedSlide(val);
		}
		
		// Updates upgrade stats
		private function setUpgradeStats():void {
			if (_machine.upgradeAcc[0]) {
				t_upgrade1.text = "+"+String(_machine.upgradeAcc[0])+"% vs";
			} else {
				t_upgrade1.text = "";
			}
			if (_machine.upgradeAcc[1]) {
				t_upgrade2.text = "+"+String(_machine.upgradeAcc[1])+"% vs";
			} else {
				t_upgrade2.text = "";
			}
			icon_upgrade1.gotoAndStop(_machine.upgradeType[0]);
			icon_upgrade1a.gotoAndStop(_machine.upgradeType[1]);
			icon_upgrade2.gotoAndStop(_machine.upgradeType[2]);
			icon_upgrade2a.gotoAndStop(_machine.upgradeType[3]);
			
			if (!TheGame.affordable(_machine.logic.getUpgradePrice())) {
				_button1.enabled = false;
				if (_button2) {
					_button2.enabled = false;
				}
				if (_machine is SnifferMachineG) {
					_button1.enabled = true;
				}
			} else if (_machine.logic.getUpgradePrice() != 0) {
				_button1.enabled = true;
				if (_button2) {
					_button2.enabled = true;
				}
			}
		}
				
		// Shows picture of machine
		private function showPicture(obj:MovieClip):void {
			if (icon_picture.numChildren == 2) {
				icon_picture.removeChild(icon_picture.getChildAt(1));
			}
			icon_picture.addChild(obj);
			obj.width = 80;
			obj.height = 80;
			obj.x = 0;
			obj.y = 5;
		}
		
		// Sets the appropriate icon for the offenses.
		private function showOffenseIcons(oList:Array, obj:MovieClip= null):void {
			if (!obj) {
				obj = this;
			}
			// Tries to set icons for everything, and stops when array is done.
			// Probably should be done with ifs or something, but this is cooler.
			if (oList[0]) {
				obj.icon_1.gotoAndStop(oList[0].getKindOfObj());
				scaleIcons(obj.icon_1, obj);
			} else {
				obj.icon_1.gotoAndStop(1);
			}
			if (oList[1]) {
				obj.icon_2.gotoAndStop(oList[1].getKindOfObj());
				scaleIcons(obj.icon_2, obj);
			} else {
				obj.icon_2.gotoAndStop(1);
			}
			if (oList[2]) {
				obj.icon_3.gotoAndStop(oList[2].getKindOfObj());
				scaleIcons(obj.icon_3, obj);
			} else {
				obj.icon_3.gotoAndStop(1);
			}
			if (oList[3]) {
				obj.icon_4.gotoAndStop(oList[3].getKindOfObj());
				scaleIcons(obj.icon_4, obj);
			} else {
				obj.icon_4.gotoAndStop(1);
			}
		}
		
		private function scaleIcons(ico:MovieClip, obj:MovieClip):void {
			if ((obj != this)&&(ico.width == 26)) {
				ico.width = ico.width/2;
				ico.height = ico.height/2;
			}
		}
				
		private function showButtons():void {
			var format:TextFormat = new TextFormat();
			format.font = "Helvetica";
			format.size = 16;
			format.color = 0xFFFFFF;
		
			_cancel = new Button();
			with (_cancel) {
				x = 380;
				y = 680;
				height = 50;
				width = 110;
				label = "";
				setStyle("textFormat", format);
				setStyle("downSkin", new Button_cancelDownSkin());
				setStyle("upSkin", new Button_cancelUpSkin());
				setStyle("overSkin", new Button_cancelOverSkin());
				addEventListener(MouseEvent.CLICK, sellHandler);
				addEventListener(MouseEvent.MOUSE_OVER, sellOver);
				addEventListener(MouseEvent.MOUSE_OUT, upgradeOut);
			}
			this.addChild(_cancel);
			
			_button1 = new Button();
			with (_button1) {
				x = 380;
				y = 620;
				height = 50;
				width = 110;
				label = "";
				addEventListener(MouseEvent.CLICK, upgrade1Handler);
				addEventListener(MouseEvent.MOUSE_OVER, upgrade1Over);
				addEventListener(MouseEvent.MOUSE_OUT, upgradeOut);
			}
			this.addChild(_button1);
			
			var upgradeText:MovieClip;
			if (((_machine is CheepieMetalDetectorG) && ((_machine.logic as MetalDetector).isGuard())) ||
					(_machine is CheepieXRayMachineG) || (_machine is SuperXRayMachineG) ||
					(_machine is SnifferMachineG && (_machine.logic as SnifferMachine).upgraded == false)) {
				upgradeText = new upgradeTwo();
				// Add function for setting text here
				_button1.width = 50;
				_button1.setStyle("icon", upgradeText);
				
				upgradeText = new upgradeTwo();
				// Add function call for setting text here
				_button2 = new Button();
				with (_button2) {
					x = 440;
					y = 620;
					height = 50;
					width = 50;
					label = "";
					addEventListener(MouseEvent.CLICK, upgrade2Handler);
					addEventListener(MouseEvent.MOUSE_OVER, upgrade2Over);
					addEventListener(MouseEvent.MOUSE_OUT, upgradeOut);
					setStyle("icon", upgradeText);
				}
				this.addChild(_button2);
			} else {
				upgradeText = new upgradeOne();
				_button1.setStyle("icon", upgradeText);
				_button2 = null;
			}
		}
		
		private function showUpgrades():void {
			var targ:Array = _machine.logic.getProhObjs();
			var bObj1:MovieClip = _button1.getStyle("icon") as MovieClip;
			var bObj2:MovieClip;
			if (_button2) {
				bObj2 = _button2.getStyle("icon") as MovieClip;
			}
			
			bObj1.t_upgrade.text = "+"+String(_machine.logic.getUpgradeAccuracy())+"%";
			bObj1.t_price.text = "$"+String(_machine.logic.getUpgradePrice());

			if (bObj2) {
				bObj2.t_upgrade.text = "+"+String(_machine.logic.getUpgradeAccuracy())+"%";
				bObj2.t_price.text = "$"+String(_machine.logic.getUpgradePrice());
				/*if (!bObj1.icon_upgrade1)
					return;*/
					
				bObj1.icon_upgrade1.gotoAndStop(1);
				bObj2.icon_upgrade1.gotoAndStop(1);
			}
			
			if ((_machine is MetalDetectorG) && !((_machine.logic as MetalDetector).isGuard())) {
				bObj1.icon_1.gotoAndStop("speed");
				bObj1.icon_2.gotoAndStop("1");
				bObj1.icon_3.gotoAndStop("1");
				bObj1.icon_4.gotoAndStop("1");
			} else if (_machine is XRayMachineG) {
				bObj1.icon_upgrade.gotoAndStop("gun");
				bObj1.icon_upgrade1.gotoAndStop("knife");
				bObj2.icon_upgrade.gotoAndStop("bomb");
				bObj2.t_upgrade.text = String(_machine.logic.getUpgradeAccuracy())+"%";
				bObj2.t_price.text = "$"+String(_machine.logic.getUpgradePrice());
			} else if ((_machine is CheepieMetalDetectorG) && ((_machine.logic as MetalDetector).isGuard())) {
				bObj1.icon_upgrade.gotoAndStop("gun");
				bObj2.icon_upgrade.gotoAndStop("knife");
				bObj2.t_upgrade.text = "+"+String(_machine.logic.getUpgradeAccuracy())+"%";
				bObj2.t_price.text = "$"+String(_machine.logic.getUpgradePrice());
			} else if ((_machine is SnifferMachineG && (_machine.logic as SnifferMachine).upgraded == false)) {
				bObj2.icon_upgrade.gotoAndStop("speed");
				swapSnifferIcon();
			} else if (_machine is SnifferMachineG) {
				swapSnifferIcon();
			} else {
				showOffenseIcons(targ, bObj1);
			}
			
			if (_machine.logic.getUpgradePrice() == 0 && !(_machine is SnifferMachineG)) {
				_button1.enabled = false;
				with (bObj1) {
					t_upgrade.text = "";
					t_price.text = "";
					if (bObj1.icon_upgrade) {
						icon_upgrade.gotoAndStop("1");
						icon_upgrade1.gotoAndStop("1");
					} else {
						icon_1.gotoAndStop("1");
						icon_2.gotoAndStop("1");
						icon_3.gotoAndStop("1");
						icon_4.gotoAndStop("1");
					}
				}
				if (_button2) {
					_button2.enabled = false;
					with (bObj2) {
						t_upgrade.text = "";
						t_price.text = "";
						icon_upgrade.gotoAndStop("1");
						icon_upgrade1.gotoAndStop("1");
					}
				}
			}
		}
		
		private function swapSnifferIcon():void {
			var button:MovieClip = new upgradeSniffer();
			var ico:MovieClip = button.icon;
			if ((_machine.logic.getProhObjs()[0].getKindOfObj()) == "bomb") {
				ico.gotoAndStop("drugs");
			} else {
				ico.gotoAndStop("bomb");
			}
			//ico.height = 40;
			//ico.width = 40;
			_button1.setStyle("icon", button);
		}
		
		// Picks what picture a machine has
		private function pickPicture():void {
			if (_machine is BagCheckerG) {
				showPicture(new icon_bagchecker());
			} else if (_machine is CheepieXRayMachineG) {
				showPicture(new icon_xray());
			} else if (_machine is DrugCanineG) {
				switch((_machine.logic as Canine).getLevel()) {
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
			} else if (_machine is BombCanineG) {
				switch((_machine.logic as Canine).getLevel()) {
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
			} else if (_machine is WandWaiverG) {
				showPicture(new icon_wandwaver());
			} else if (_machine is CheepieMetalDetectorG) {
				showPicture(new icon_metaldetector());
			} else if (_machine is SuperMetalDetectorG) {
				showPicture(new icon_supermetaldetector());
			} else if (_machine is SuperXRayMachineG) {
				showPicture(new icon_superxray());
			} else if (_machine is SnifferMachineG) {
				showPicture(new icon_sniffer());
			} else if (_machine is ClownG) {
				showPicture(new icon_clown());
			} else if (_machine is EntertainmentDisplayG) {
				showPicture(new icon_video());
			}
		}
		
		/*--------------------------------------- HANDLERS ---------------------------------*/
		
		private function sellHandler(e:MouseEvent):void {
			_menu.playClick();
			_machine.logic.sellIt();
			var stationG:StationG = _machine.parent as StationG;
			stationG.removeSecurityCheckUnitG(_machine.spot);
			_menu.setMenu(new UnselectedMenu(_menu));
		}
		
		private function upgrade1Handler(e:MouseEvent):void {
			_menu.playClick();
			_machine.upgrade(false);
			this.removeChild(_button1);
			this.removeChild(_cancel);
			showButtons();
			showUpgrades();
		}
		
		private function upgrade2Handler(e:MouseEvent):void {
			_menu.playClick();
			_machine.upgrade(true);
			showButtons();
			showUpgrades();
			// second upgrade code
		}
		
		private function upgrade1Over(e:MouseEvent):void {
			_machine.showUpgradeInfoText(false);
		}
		
		private function upgrade2Over(e:MouseEvent):void {
			_machine.showUpgradeInfoText(true);
		}
		
		private function upgradeOut(e:MouseEvent):void {
			Globals.infoBox.clearText();
		}
			
		private function sellOver(e:MouseEvent):void {
			Globals.infoBox.addText(_machine.sellText());
		}
		
		private function deselect(e:MouseEvent):void {
			if (!_delay) {
				_delay = true;
			} else {
				_menu.setMenu(new UnselectedMenu(_menu));
			}
		}
	}
}