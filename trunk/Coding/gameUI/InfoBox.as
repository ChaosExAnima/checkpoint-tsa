package gameUI {
	import gameControl.TheGame;
	import gameData.XMLgameData;
	import gameUI.Interface;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class InfoBox extends MovieClip {
		private static var _buffer:Array = new Array("entry1","","");
		private var _fadeTime:int = 2000; //Time until message starts to fade out
		private var _menu;
		
		private static var _maxPass:int = 0;
		private static var _curPass:int = 0;
		private static var _maxArrest:int = 0;
		private static var _curArrest:int = 0;
		
		public function InfoBox(menu:Menus):void {
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, updateStats);
			_menu = menu;
		}
		
		// Updates everything per game tick
		private function updateStats(e:TimerEvent):void {
			updateMoney();
			updateRep();
			dispText();
			
			InfoBox._maxArrest = _menu.gameData.getLevel(Interface.GAMELEVEL, "minViolations")
			InfoBox._maxPass = _menu.gameData.getLevel(Interface.GAMELEVEL, "passengers");
			t_passengers.text = InfoBox.curPass+"/"+InfoBox.maxPass+" passengers";
			t_arrests.text = InfoBox.curArrests+"/"+InfoBox.maxArrests+" violations";
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
		
		// Static function to add a text notification
		public static function addText(info:String):void {
			InfoBox._buffer.unshift(info);
			InfoBox._buffer = InfoBox._buffer.slice(0,3);
		}		
		
		// Displays text in buffer every game tick
		private function dispText():void {
			if (message_1.text != InfoBox._buffer[0]) {
				message_1.alpha = 1;
				message_1.text = InfoBox._buffer[0];
				delayFade(message_1);
			}
			if (message_2.text != InfoBox._buffer[1]) {
				message_2.alpha = 1;
				message_2.text = InfoBox._buffer[1];
				delayFade(message_2);
			}
			if (message_3.text != InfoBox._buffer[2]) {
				message_3.alpha = 1;
				message_3.text = InfoBox._buffer[2];
				delayFade(message_3);
			}
		}
		
		// Delay before text fades out
		private function delayFade(disp:TextField):void {
			var timer:Timer = new Timer(_fadeTime);
			timer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent) {
				timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
				disp.addEventListener(Event.ENTER_FRAME, fadeOut);
				timer.stop();
			});
			timer.start();
		}
		
		// Fades text out		
		private function fadeOut(e:Event):void {
			var message:TextField = e.target as TextField;
			if (message.alpha <= 0) {
				message.removeEventListener(e.type, fadeOut);
				var loc:int = InfoBox._buffer.lastIndexOf(message.text);
				InfoBox._buffer[loc] = "";
				message.text = "";
			} else {
				message.alpha = message.alpha - 0.1;
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
	}
}