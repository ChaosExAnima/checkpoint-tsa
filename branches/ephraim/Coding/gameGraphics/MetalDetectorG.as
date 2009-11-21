 package gameGraphics {

	import gameLogic.MetalDetector;
	import flash.display.MovieClip;
	
	/* This class contains all variables and methods common to each graphical representation of a MetalDetector,
	   like the ability in the UI to add a guard. */
	   
	public class MetalDetectorG extends SliderMachineG {
		protected var _guard:MovieClip = new guard_idle();
		
		public function MetalDetectorG(xLoc:Number, yLoc:Number, secCheck:MetalDetector, metalDetector:MovieClip) {
			super(xLoc, yLoc, secCheck, metalDetector);
		}
		
		// Handles the ability in the UI of adding a guard.
		public function addGuard():void {
			MetalDetector(secCheck).addGuard();
			var curFrame:int = unitForm.currentFrame;
	
			if (curFrame <= 2) {
				newGuard(new guard_idle());
			} else if (curFrame == 3) {
				newGuard(new guard_pass());
			} else if (curFrame == 4) {
				newGuard(new guard_arrest());
			}
		}
				
		protected function newGuard(guard:MovieClip):void {
			if (MetalDetector(secCheck).isGuard()) {
				if (this.contains(_guard)) {
					this.removeChild(_guard);
				}
				_guard = guard;
				_guard.x = 30;
				_guard.y = -65;
				this.addChild(_guard);
			}
		}
								  
		public override function caught():void {
			unitForm.gotoAndStop(4);
			newGuard(new guard_arrest());
		}
		
		public override function go():void {
			unitForm.gotoAndStop(3);
			newGuard(new guard_pass());
		}
		
		public override function checking():void {
			unitForm.gotoAndStop(2);
			newGuard(new guard_idle());
		}
		
		public override function idle():void {
			unitForm.gotoAndStop(1);
			newGuard(new guard_idle());
		}
		
		
	}
}