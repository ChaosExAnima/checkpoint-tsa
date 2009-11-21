package gameGraphics {
	
	import gameLogic.SuperMetalDetector;
	import gameLogic.MetalDetector;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	
	/* Encapsulates the graphical representation of a Super Metal Detector. */
	
	public class SuperMetalDetectorG extends MetalDetectorG {
		
		public function SuperMetalDetectorG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new SuperMetalDetector(), new GSuperMetalDetector());
			behindSprite =  new GSuperMetalDetectorBack();
			this.addChild(behindSprite);
			this.addChild(unitForm);
		}
		
		public override function upgrade(type:Boolean = false):void {
			addGuard();
			upgradeAcc[0] = MetalDetector(secCheck).guardAcc;
			upgradeType[0] = "speed";
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			
			var descrText:String = XMLmachineData.getXML("SuperMetalDetector", "description");
			
			var results:Array = descrText.split("|");
			Globals.infoBox.addText(results[1]);
		}
		// Overwrite isCaught in logical super metal detector!
	}
}