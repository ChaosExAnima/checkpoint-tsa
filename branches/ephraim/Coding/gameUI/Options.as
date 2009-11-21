package gameUI {
	
	import gameSound.SoundManager;
	import gameControl.*;
  	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;

	
	public class Options extends Sprite {
		private var _sndMgr:SoundManager;
		private var _menu:Menus;
		private var _strQuality:String;
		private var _main:menu_options = new menu_options();
		private var _credits:menu_credits = new menu_credits();
		private var _curr:String;
		private var _slider:MusicSlider;
		
		public function Options(menu:Menus, aSndMgr:SoundManager):void {
			_menu = menu;
			_sndMgr = aSndMgr;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// Initialization after options menu is added to stage
		private function init(e:Event):void {
			this.removeEventListener(e.type, init);

			var so:SharedObject = SharedObject.getLocal("quality");
			if(!so.size) {
				stage.quality = "MEDIUM";
				so.data.level = "MEDIUM";
				_strQuality = "MEDIUM";
			} else {
				stage.quality = so.data.level;
				_strQuality = so.data.level;
			}
			showMain();
		}
				
		// Shows the main menu
		private function showMain():void {
			_curr = "main";
			
			this.addChild(_main);
			setInfoHandlers();
			updateGraphicButton();	
			updateMuteButton();	
						
			if (!_slider) {
				_slider = new MusicSlider(_sndMgr);
				_slider.x = -5;
				_slider.y = 78;
				_main.addChild(_slider);
			}
			_main.b_new.addEventListener(MouseEvent.CLICK, onResetGame); //Doesn't work.
			_main.b_sound.addEventListener(MouseEvent.MOUSE_UP, onSoundFX);
			_main.b_graphics.addEventListener(MouseEvent.MOUSE_UP, onGraphics);
			_main.b_credits.addEventListener(MouseEvent.MOUSE_UP, onCredits);
			
			_menu.UI.parent.addEventListener(MouseEvent.CLICK, hideHandler);
		}
		
		// Either hides options menu, or goes back to main
		private function hideHandler(e:MouseEvent):void {
			if (_curr == "main") {
				_menu.hideOptions();
				_curr = "";
			} else if (_curr == "credits") {
				hideCredits(e);
			}
		}
		
		// Restarts game
		private function onResetGame(e:MouseEvent):void {
			TheGame.pauseGame();
			Globals.airport.clearPasses();
			TheGame.resetGame();
			Globals.airport.resetLines();
			TheGame.startGame();
			_menu.hideOptions();
		}
		
		// Shows credits
		private function onCredits(event:MouseEvent):void
		{
			this.removeChild(_main);
			_curr = "credits";
			this.addChild(_credits);
			_credits.addEventListener(MouseEvent.CLICK, hideCredits);
		}
		
		// Hides credits		
		private function hideCredits(e:MouseEvent):void {
			this.removeChild(_credits);
			this.removeEventListener(MouseEvent.CLICK, hideCredits);
			showMain();
		}
		
		// Sets graphics quality
		private function onGraphics(event:MouseEvent):void 
		{
			switch(_strQuality)
			{
				case "LOW":
					_strQuality = "MEDIUM";
					break;
				case "MEDIUM":
					_strQuality = "HIGH";
					break;	
				case "HIGH":
					_strQuality = "BEST";
					break;
				case "BEST":
					_strQuality = "LOW";
					break;
				default:
					_strQuality = "MEDIUM";
					break;
			}
			
			var so:SharedObject = SharedObject.getLocal("quality");
			so.data.level = _strQuality;
			stage.quality = _strQuality;
			
			updateGraphicButton();
		}
		
		// Sets graphics quality button text
		private function updateGraphicButton():void
		{
			_main.t_graphics.mouseEnabled = false;
			switch(_strQuality)
			{
				case "LOW":
					_main.t_graphics.text = "Graphics: Low";
					break;
				case "MEDIUM":
					_main.t_graphics.text = "Graphics: Medium";
					break;	
				case "HIGH":
					_main.t_graphics.text = "Graphics: High";
					break;
				case "BEST":
					_main.t_graphics.text = "Graphics: Best";
					break;

			}			
		}
		
		// Sets sound muting
		private function onSoundFX(event:MouseEvent):void 
		{
			_sndMgr.toggleMute();
	
			updateMuteButton();
		}
		
		// Sets text for sound muting button
		private function updateMuteButton():void
		{
			_main.t_sound.mouseEnabled = false;
			if(!_sndMgr.getMute())
			{
				_main.t_sound.text = "Sound Effects: On";
			}
			else
			{
				_main.t_sound.text = "Sound Effects: Off";
			}			
		}
		
		// Sets up the handlers to show text in the info box
		private function setInfoHandlers():void {
			var bArray:Array = new Array(_main.b_new, 
										 _main.b_credits, 
										 _main.b_graphics, 
										 _main.b_sound, 
										 _main.b_music);
			
			for each (var btn:Object in bArray) {
				btn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			}
		}
		
		// Shows text in info box
		private function overHandler(e:MouseEvent):void {
			var info:String = "";
			var btn:Object = e.target;
			
			if (btn == _main.b_new) {
				info = "Starts a new game.";
			} else if (btn == _main.b_load) {
				info = "Loads a previously saved game.";
			} else if (btn == _main.b_credits) {
				info = "Shows the credits.";
			} else if (btn == _main.b_graphics) {
				info = "Cycles through the graphics quality.";
			} else if (btn == _main.b_sound) {
				info = "Mutes the sound effects.";
			} else if (btn == _main.b_music) {
				info = "Sets the music volume.";
			}
			
			Globals.infoBox.addText(info);
		}
		
		// Clears the text from the display
		private function outHandler(e:MouseEvent):void {
			Globals.infoBox.clearText();
		}
	}
}