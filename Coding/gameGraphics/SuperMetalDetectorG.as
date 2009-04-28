package gameGraphics {
	
	import gameLogic.SuperMetalDetector;
	import gameLogic.MetalDetector;
	
	/* Encapsulates the graphical representation of a Super Metal Detector. */
	
	public class SuperMetalDetectorG extends MetalDetectorG {
		
		public function SuperMetalDetectorG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new SuperMetalDetector(), new GSuperMetalDetector());
		}
		
		public override function upgrade(type:Boolean = false):void {
			addGuard();
			upgradeAcc[0] = MetalDetector(secCheck).guardAcc;
			upgradeType[0] = "speed";
		}
		
		// Overwrite isCaught in logical super metal detector!
	}
}