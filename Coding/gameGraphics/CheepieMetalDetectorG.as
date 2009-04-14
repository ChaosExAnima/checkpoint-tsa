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
				guard.x = 73.9;
				guard.y = 108.7;
				this.addChild(guard);
			}
		}
	}
}