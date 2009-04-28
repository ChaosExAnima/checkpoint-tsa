package gameGraphics {
	
	import gameLogic.CheepieMetalDetector;
	import gameLogic.MetalDetector;
	import flash.display.MovieClip;
	
	/* Encapsulates the graphical representation of a Cheepie Metal Detector with the power up possibilites for guns or knives */
	
	public class CheepieMetalDetectorG extends MetalDetectorG {
		
		public function CheepieMetalDetectorG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new CheepieMetalDetector(), new GCheepieMetalDetector());
		}
		
		protected override function newGuard(guard:MovieClip):void {
			if (MetalDetector(secCheck).isGuard()) {
				if (this.contains(_guard)) {
					this.removeChild(_guard);
				}
				_guard = guard;
				_guard.x = 30;
				_guard.y = -55;
				this.addChild(_guard);
			}
		}
		
		public override function upgrade(type:Boolean = false):void {
			if (!MetalDetector(secCheck).isGuard()) {
				addGuard();
				upgradeAcc[0] = MetalDetector(secCheck).guardAcc;
				upgradeType[0] = "speed";
			} else if (type == false) {
				CheepieMetalDetector(secCheck).doPowerUpKnife();
				upgradeAcc[1] = CheepieMetalDetector(secCheck).upgradeAcc;
				upgradeType[2] = "knife";
			} else if (type == true) {
				CheepieMetalDetector(secCheck).doPowerUpGun();
				upgradeAcc[1] = CheepieMetalDetector(secCheck).upgradeAcc;
				upgradeType[2] = "gun";
			}
		}
	}
}