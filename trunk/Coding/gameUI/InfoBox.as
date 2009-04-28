package gameUI {
	import gameControl.TheGame;
	import gameData.XMLgameData;
	import gameUI.Interface;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class InfoBox extends MovieClip {
		private var _menu;
		private var _buffer:Array = new Array();		
		
		private static var _maxPass:int = 0;
		private static var _curPass:int = 0;
		private static var _maxArrest:int = 0;
		private static var _curArrest:int = 0;
		
		private const MESSAGE_LIFE:int = 5; //Time until message starts to fade out
		private const ALPHA_DELTA:int = 20;
		
		public function InfoBox(menu:Menus):void {
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, updateStats);
			_menu = menu;
			
			message_1.text = "";
			message_2.text = "";
			message_3.text = "";
		}
		
		// Updates everything per game tick
		private function updateStats(e:TimerEvent):void {
			updateMoney();
			updateRep();
			dispText();
			
			InfoBox._maxArrest = _menu.gameData.getLevel(TheGame.getLevel(), "minViolations")
			InfoBox._maxPass = _menu.gameData.getLevel(TheGame.getLevel(), "passengers");
			t_passengers.text = TheGame.getNumPass()+"/"+InfoBox.maxPass+" passengers";
			t_arrests.text = TheGame.getArrests()+" arrests";
		}
		
		// Sets the money on the UI
		private function updateMoney():void {
			t_money.text = "$"+TheGame.getMoney().toString();
			if (TheGame.getMoney() < 0) {
				t_money.textColor = 0xFF0000;
			} else {
				t_money.textColor = 0xFFFFFF;
			}
		}
		
		// Sets the reputation on the UI
		private function updateRep():void {
			t_rep.text = TheGame.getReputation().toString()+" Rep";
		}		
		
// --------------------------- MESSAGE BOX FUNCTIONS
		
		// Function to add a text notification
		public function addText(info:String):void {
			if (_buffer.length == 3) {
				_buffer.pop();
			}
			
			_buffer.unshift(new Array(info, MESSAGE_LIFE));
			message_3.alpha = message_2.alpha;
			message_2.alpha = message_1.alpha;
			message_1.alpha = 1;
			
			if(_buffer.length > 0)
			{
				message_1.text = _buffer[0][0];
			}
			
			if(_buffer.length > 1)
			{
				message_2.text = _buffer[1][0];
			}
			
			if(_buffer.length > 2)
			{
				message_3.text = _buffer[2][0];
			}
		}		
		
		// Updates text every game tick
		private function dispText():void {
			for (var i = 0; i < _buffer.length; i++) {
				_buffer[i][1]--;
				
				var aTxt:TextField;
				
				if(_buffer[i][1] <= 0) {
					switch(i) {
						case 0:
							aTxt = message_1;
							break;
						case 1:
							aTxt = message_2;
							break;
						case 2:
							aTxt = message_3;
							break;
					}
				
					aTxt.alpha -= ALPHA_DELTA / 100;
					
					if(aTxt.alpha <= 0)
					{
						_buffer.pop();
						aTxt.text = "";
						aTxt.alpha = 1;
					}
				}
			}
		}

// ---------------------------------- SETTERS AND GETTERS
		
		// Gets the current passenger count
		public static function get curPass():int {
			return (InfoBox._curPass);
		}
		
		// Sets the current passenger count. Call without () to just increment
		public static function set curPass(num:int):void {
			InfoBox._curPass = InfoBox._curPass + num;
		}
						
		// Gets the maximum passenger count
		public static function get maxPass():int {
			return (InfoBox._maxPass);
		}

		// Gets the current arrest count
		public static function get curArrests():int {
			return (InfoBox._curArrest);
		}
		
		// Sets the current arrest count. Call without () to just increment
		public static function set curArrests(num:int):void {
			InfoBox._curArrest = InfoBox._curArrest + num;
		}
						
		// Gets the maximum arrest count
		public static function get maxArrests():int {
			return (InfoBox._maxArrest);
		}
		
		// Returns security slider level
		public function get secLevel():int {
			return slider.getSliderVal();
		}
	}
}