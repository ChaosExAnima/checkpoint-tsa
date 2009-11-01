package gameGraphics {
	
	import gameLogic.BagChecker;
	import gameData.XMLmachineData;
	import gameControl.Globals;

	/* Encapsulates the graphical representation of a bag checker. */
	
	public class BagCheckerG extends GuardG {
		
		public function BagCheckerG(xLoc:Number, yLoc:Number){
			super(xLoc, yLoc, new BagChecker(), new GBagChecker());
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			var info:String;
			
			if (getLevel() == 1) {
				info = XMLmachineData.getXML("BagChecker", "description", "2");
			} else if (getLevel() == 2) {
				info = XMLmachineData.getXML("BagChecker", "description", "3");
			}
			
			Globals.infoBox.addText(info);
		}
	}
}