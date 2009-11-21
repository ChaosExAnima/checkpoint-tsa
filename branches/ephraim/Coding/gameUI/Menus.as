package gameUI {
	import gameData.*;
	import gameUI.*;
	import gameSound.SoundManager;
	import gameControl.*;
	import gameGraphics.PassengerG;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.ui.Keyboard;
	import fl.controls.Button;
	
	public class Menus extends MovieClip {
		private var _machineData:XMLmachineData = new XMLmachineData();
		private var _gameDataXML:XMLgameData = new XMLgameData();
		private var _UI:Interface;
		private var _curMenu:MovieClip; // Current menu clip
		private var _remainingUses:int = 3; //Remaining uses for hot-cold game
		private var _cursor:MovieClip = null; //Custom cursor clip
		private var _sndManager:SoundManager;
		public static var _infoBox:InfoBox;
		private var _options:Options;
		private var _winMenu:MovieClip = new menu_win();
		private var _loseMenu:MovieClip = new menu_lose();
		
		public function Menus(inter:Interface, sound:SoundManager):void {
			_UI = inter;
			_sndManager = sound;
			_curMenu = new UnselectedMenu(this);
			_curMenu.init();
			this.addChild(_curMenu);
			_infoBox = new InfoBox(this);
			this.addChild(_infoBox);
			Globals.menus = this;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createListeners);
		}
		
		// Creates listeners- call after Menus is added to the display list!
		private function createListeners(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, optionsHandler);
			_UI.lineOutline.addEventListener(MouseEvent.CLICK, newLineHandler);
		}
		
		// Swaps current menu for new one
		public function setMenu(menu:MovieClip):void {
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
		
//----------------------------------POPUP DIALOG BOXES-------------------------------//
		public function winMenu():void {
			TheGame.pauseGame();
			
			_winMenu.x = stage.stageWidth/2;
			_winMenu.y = stage.stageHeight/2;
			_winMenu.btn_continue.addEventListener(MouseEvent.CLICK, resumeGameHandler);
			_winMenu.btn_quit.addEventListener(MouseEvent.CLICK, quitGameHandler);
			this.addChild(_winMenu);
		}
		
		private function resumeGameHandler(e:MouseEvent):void
		{
			playClick();
			TheGame.setLevel(TheGame.getLevel()+1);
			TheGame.resetNumPass();
			TheGame.resetArrests();
			TheGame.startGame();
			this.removeChild(_winMenu);
		}

		public function loseMenu():void {
			TheGame.pauseGame();
			_loseMenu.x = stage.stageWidth/2;
			_loseMenu.y = stage.stageHeight/2;
			
			
			_loseMenu.btn_reset.addEventListener(MouseEvent.CLICK, restartGameHandler);
			_loseMenu.btn_quit.addEventListener(MouseEvent.CLICK, quitGameHandler);
			
			this.addChild(_loseMenu);
		}
		
		private function restartGameHandler(e:MouseEvent):void {
			playClick();
			TheGame.pauseGame();
			TheGame.resetGame();
			Globals.airport.resetLines();
			TheGame.startGame();
			this.removeChild(_loseMenu);
		}
		
		private function quitGameHandler(e:MouseEvent):void {
			playClick();
			try {
				TheGame.pauseGame();
				Globals.airport.clearPasses();
				Globals.soundManager.stopSound();
				Load.gameLoader.quitGame();
			} catch (e:Error) {
				trace("Can't quit game!");
			}
		}
			
		private function newLineHandler(e:MouseEvent):void {
			var newLineBox:MovieClip = new menu_newline();
			newLineBox.x = stage.stageWidth/2;
			newLineBox.y = stage.stageHeight/2;
			this.addChild(newLineBox);
			
			/*var b_confirm:Button = new Button();
			b_confirm.setStyle("upSkin", new Button_confirmUpSkin());
			b_confirm.setStyle("downSkin", new Button_confirmDownSkin());
			b_confirm.setStyle("overSkin", new Button_confirmOverSkin());
			b_confirm.label = "";
			b_confirm.x = 125;
			b_confirm.y = -25;*/
			
			//newLineBox.addChild(b_confirm);
			
			var price:int = Math.pow(2, _UI.getNumStations())*100;
			newLineBox.t_price.text = "Buy a new line for $"+price+"?";
			
			if (!TheGame.affordable(price)) {
				newLineBox.b_confirm.enabled = false;
			} else {
				newLineBox.b_confirm.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) { 
																					playClick();
																					_UI.addStation();
																				   	e.target.parent.parent.removeChild(newLineBox);});
			}
			
			newLineBox.b_cancel.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) {playClick();e.target.parent.parent.removeChild(newLineBox);});
		}
		
//----------------------------------OPTIONS MENU FUNCTIONS------------------------//

		// Displays Options menu
		public function showOptions():void {
			if (!_options) {
				_options = new Options(this, _sndManager);
				_options.x = 500;
				_options.y = 375;
				this.addChild(_options);
			}
		}
		
		// Removes Options menu
		public function hideOptions():void {
			if (_options) {
				this.removeChild(_options);
				_options = null;
			}
		}
		
		// Handles calling up options by hitting ESC key
		private function optionsHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				if (!_options) {
					showOptions();
				} else {
					hideOptions();
				}
			}
		}
		
//------------------------------------CUSTOM CURSOR FUNCTIONS----------------------//

		// Triggered when over the menu
		private function overMenu():void {
			Mouse.hide();
			if (!_cursor) {
				Mouse.show();
			} else {
				_cursor.mouseChildren = false;
				_cursor.mouseEnabled = false;
				stage.addChild(_cursor);
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
				stage.removeChild(_cursor);
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
		
		public function get gameData():XMLgameData {
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
				stage.addChild(_cursor);
				_cursor.mouseChildren = false;
				_cursor.mouseEnabled = false;
			}
		}
		
		internal function get cursor():MovieClip {
			return (_cursor);
		}
		
		internal function get sndManager():SoundManager {
			return (_sndManager);
		}
		
		public function get infoBox():InfoBox {
			return (_infoBox);
		}
	}
}