package gameUI {
	import gameData.*;
	import gameSound.SoundManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class Menus extends MovieClip {
		private var _machineData:XMLmachineData = new XMLmachineData();
		private var _gameDataXML:XMLgameData = new XMLgameData();
		private var _UI:Interface;
		private var _curMenu:MovieClip; // Current menu clip
		private var _remainingUses:int = 3; //Remaining uses for hot-cold game
		private var _cursor:MovieClip = null; //Custom cursor clip
		private var _sndManager:SoundManager;
		
		public function Menus(inter:Interface, sound:SoundManager):void {
			_UI = inter;
			_sndManager = sound;
			_curMenu = new UnselectedMenu(this);
			_curMenu.init();
			this.addChild(_curMenu);
			this.addChild(new InfoBox(this));
		}
		
		// Swaps current menu for new one
		internal function setMenu(menu:MovieClip):void {
			this.removeChild(_curMenu);
			_curMenu.cleanUp();
			_curMenu = menu;
			this.addChild(_curMenu);
			_curMenu.init();
		}
		
		// Plays button press sound
		internal function playClick():void {
			_sndManager.playSound("sounds/fx/Click_1.mp3");
		}

//------------------------------------CUSTOM CURSOR FUNCTIONS----------------------//
		
		// Creates listeners- call after Menus is added to the display list!
		public function createListeners():void {
			MovieClip(root).addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}

		// Triggered when over the menu
		private function overMenu():void {
			Mouse.hide();
			if (!_cursor) {
				Mouse.show();
			} else {
				MovieClip(root).addChild(_cursor);
			}
		}
		
		// Triggered when over the game field
		private function overGame():void {
			if (_cursor) {
				clearCursor();
				Mouse.show();
			}
		}
		
		// Removes cursor movieclip
		internal function clearCursor():void {
			try {
				MovieClip(root).removeChild(_cursor);
			} catch(e:Error) {}
		}
		
		// Updates position on mouse move
		private function moveHandler(e:MouseEvent):void {
			if (_cursor) {
				_cursor.x = MovieClip(root).mouseX;
				_cursor.y = MovieClip(root).mouseY;
				if (mouseY < 600) {
					overMenu();
				} else {
					overGame();
				}
			}
		}
		
		
// -------------------------------- GETTERS AND SETTERS-------------------//

		internal function get UI():Interface {
			return _UI;
		}
		
		internal function get machineData():XMLmachineData {
			return _machineData;
		}
		
		internal function get gameData():XMLgameData {
			return _gameDataXML;
		}
		
		internal function get remainingUses():int {
			return _remainingUses;
		}
		
		internal function set remainingUses(num:int):void {
			_remainingUses = num;
		}

		internal function set cursor(cur:MovieClip):void {
			_cursor = cur;
			clearCursor();
			if (_cursor) {
				MovieClip(root).addChild(_cursor);
			}
		}
		
		internal function get cursor():MovieClip {
			return (_cursor);
		}
		
		internal function get sndManager():SoundManager {
			return (_sndManager);
		}
	}
}