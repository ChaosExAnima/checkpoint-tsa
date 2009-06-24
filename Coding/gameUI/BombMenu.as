package gameUI {
	import gameGraphics.PassengerG;
	import gameControl.*;
	import flash.display.MovieClip;
	import flash.events.*;
    import flash.utils.Timer;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	
    public class BombMenu extends MovieClip implements IMenu {
		private const NUM_STEPS:int = 47; // Value reflects amount of frames in meter animation.
		private const MAX_DETECT_DISTANCE:int = 150; // Max distance to detect violators
		private const LENGTH_OF_USE:int = 20; // Number of seconds that game lasts. Must divide into 40!
		
		private var _timer:Timer;
		private var _menu:Menus;
		
		public function BombMenu(menu:Menus):void {
			_menu = menu;
			t_time.text = String(LENGTH_OF_USE);
			icon_time.gotoAndStop(LENGTH_OF_USE*(40/LENGTH_OF_USE));
		}
		
		// Initializes hot-cold game
		public function init():void {
			_menu.cursor = new cur_bomb1();
			
			meter_knife.addEventListener(Event.ENTER_FRAME, meterNoise);
			meter_knife.lastNoise = 0;
			meter_knife.gotoAndStop(0);
			meter_gun.addEventListener(Event.ENTER_FRAME, meterNoise);
			meter_gun.lastNoise = 0;
			meter_gun.gotoAndStop(0);
			meter_drug.addEventListener(Event.ENTER_FRAME, meterNoise);
			meter_drug.lastNoise = 0;
			meter_drug.gotoAndStop(0);
			meter_bomb.addEventListener(Event.ENTER_FRAME, meterNoise);
			meter_bomb.lastNoise = 0;
			meter_bomb.gotoAndStop(0);
		
			cancel.addEventListener(MouseEvent.CLICK, onButtonStop);
			
			_menu.remainingUses--;
				
			_timer = new Timer(1000, LENGTH_OF_USE);
				
           	_timer.addEventListener(TimerEvent.TIMER, onTick);
          	_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
				
			_timer.start();
			
			var time:Timer = TheGame.getGameTik();
			time.addEventListener(TimerEvent.TIMER, update);
			
			if (_menu.remainingUses < 0) {
				_menu.setMenu(new UnselectedMenu(_menu));
			}
			
			Globals.soundManager.hotColdMusic();
		}
		
		// Cleans up
		public function cleanUp():void {
			_menu.clearCursor();
			_menu.cursor = null;
			Mouse.show();
			meter_knife.removeEventListener(Event.ENTER_FRAME, meterNoise);
			meter_gun.removeEventListener(Event.ENTER_FRAME, meterNoise);
			meter_drug.removeEventListener(Event.ENTER_FRAME, meterNoise);
			meter_bomb.removeEventListener(Event.ENTER_FRAME, meterNoise);
			
			cancel.removeEventListener(MouseEvent.CLICK, onButtonStop);
			_timer.removeEventListener(TimerEvent.TIMER, onTick);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			_timer.stop();
			TheGame.getGameTik().removeEventListener(TimerEvent.TIMER, update);
			
			for each (var pass:PassengerG in Globals.airport.afloor.passengerArray) {
				pass.removeEventListener(MouseEvent.CLICK, arrestPass);
			}
			
			for each (var passa:PassengerG in Globals.airport.preline.passengerArray) {
				passa.removeEventListener(MouseEvent.CLICK, arrestPass);
			}
		}
		
		// Runs every gameTik to set meters
		private function update(e:TimerEvent):void {
			ResetMeters();
			for each (var pass:PassengerG in Globals.airport.afloor.passengerArray) {
				CheckPassengerViolation(pass);
				pass.addEventListener(MouseEvent.CLICK, arrestPass);
				pass.noRedirect();
				//trace("Pass in afloor");
			}
			
			for each (var passa:PassengerG in Globals.airport.preline.passengerArray) {
				CheckPassengerViolation(passa);
				passa.addEventListener(MouseEvent.CLICK, arrestPass);
				passa.noRedirect();
				//trace("Pass in preline");
			}
		}
		
		// Triggered when game is canceled
		private function onButtonStop(e:MouseEvent):void {
			_menu.playClick();
			_menu.setMenu(new UnselectedMenu(_menu));
		}
		
		// Triggered when game timeout occurs
		private function timerHandler(e:TimerEvent):void {
			_menu.setMenu(new UnselectedMenu(_menu));
		}
		
		// Updates timer text
		private function onTick(event:TimerEvent):void {
			this.t_time.text = String(LENGTH_OF_USE-event.target.currentCount);
			this.icon_time.gotoAndStop((LENGTH_OF_USE-event.target.currentCount)*(40/LENGTH_OF_USE))
		}
		
		// Sets cursor movieclip and resets meter
		private function ResetMeters():void {
			var maxCurrViolation = Math.max(this.meter_knife.currentFrame,this.meter_gun.currentFrame,
									this.meter_drug.currentFrame,this.meter_bomb.currentFrame);
			
			if(maxCurrViolation > 43)
			{
				if (!(_menu.cursor is cur_bomb3)) {
					_menu.clearCursor();
					_menu.cursor = new cur_bomb3();
				}
			}
			else if(maxCurrViolation > 36)
			{
				if (!(_menu.cursor is cur_bomb2)) {
					_menu.clearCursor();
					_menu.cursor = new cur_bomb2();
				}
			}
			else {
				if (!(_menu.cursor is cur_bomb1)) {
					_menu.clearCursor();
					_menu.cursor = new cur_bomb1();
				}
			}
			
			meter_knife.gotoAndStop(0);
			meter_gun.gotoAndStop(0);
			meter_drug.gotoAndStop(0);
			meter_bomb.gotoAndStop(0);
		}
		
		// checks individual and adds violation to culmative effect
		private function CheckPassengerViolation(passG:PassengerG):void {
			var prohibObj = passG.logic.carriesWhat();
			
			if(prohibObj)
			{
				var newFrame;
				var percent = PassengerConcealPercent(passG);
				var frameChange:int = 0+ NUM_STEPS * percent / 100;
				
				switch(prohibObj.getKindOfObj())
				{
					case "bomb":
						newFrame = Math.min(NUM_STEPS, this.meter_bomb.currentFrame + frameChange);
						this.meter_bomb.gotoAndStop(newFrame);
						break;
					case "drugs":
						newFrame = Math.min(NUM_STEPS, this.meter_drug.currentFrame + frameChange);
						this.meter_drug.gotoAndStop(newFrame);
						break;
					case "gun":
						newFrame = Math.min(NUM_STEPS, this.meter_gun.currentFrame + frameChange);
						this.meter_gun.gotoAndStop(newFrame);
						break;
					case "knife":
						newFrame = Math.min(NUM_STEPS, this.meter_knife.currentFrame + frameChange);
						this.meter_knife.gotoAndStop(newFrame);
						break;
				}
			}
		}
		
		// Calculates the detection percent for a given passenger
		private function PassengerConcealPercent(passG:PassengerG):Number {
			var passDistance = int(Math.sqrt(Math.pow(Globals.airport.afloor.mouseX-passG.x,2)+Math.pow(Globals.airport.afloor.mouseY-passG.y,2)));
			

			if(passDistance > MAX_DETECT_DISTANCE) {
				return 0;
			}
			var passConceal = passG.logic.getConcealment();
			// the lower the concealment the farther away from the passenger
			// the meter maxes out.
		
			var radiusForMaxMeter = MAX_DETECT_DISTANCE * passConceal / 100;
	
			if(passDistance <= radiusForMaxMeter)
				return 100;
	
			return 100-((passDistance-radiusForMaxMeter)/MAX_DETECT_DISTANCE*100);
		}

		// Arrests the passenger
		private function arrestPass(e:Event):void {
			trace("Pass arrested!");
			var pass:PassengerG = e.currentTarget as PassengerG;
			if (pass.logic.carriesWhat()) {
				pass.logic.gotCaught();
			} else {
				TheGame.subtractReputation(10);
			}
			var ref:int = Globals.airport.afloor.isPassHere(pass);
			if (ref != -1) {
				Globals.airport.afloor.killPass(ref);
			} else {
				ref = Globals.airport.preline.isPassHere(pass);
				if (ref != -1) {
					Globals.airport.preline.killPass(ref);
				} else {
					trace("Something really wierd is going on...");
				}
			}
			TheGame.incrementNumPass();
			TheGame.incrementArrests();
		}
		
		// Adds some noise to the meters
		private function meterNoise(event:Event):void {
			var thisMC:MovieClip = event.target as MovieClip;
				  
			var noise = Math.round(Math.random()*(2))-1; // get a number from -1 to 1
			if(noise == thisMC.lastNoise || noise == 0)
				return;
			
			if(noise == 1 && thisMC.currentFrame != thisMC.totalFrames)
				thisMC.nextFrame();
			else if (noise == -1 && thisMC.currentFrame > 0)
				thisMC.prevFrame();
				
			thisMC.lastNoise = noise;	
		} 
	}
}
