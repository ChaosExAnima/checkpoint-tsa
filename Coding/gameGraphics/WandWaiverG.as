package gameGraphics {
	
	import gameLogic.WandWaver;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	
	/* Encapsulates the graphical representation of a wand waiver. */
	
	public class WandWaiverG extends GuardG {
		
		public function WandWaiverG(xLoc:Number, yLoc:Number){
			super(xLoc, yLoc, new WandWaver(), new GWandWaiver());
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			var info:String;
			
			if (getLevel() == 1) {
				info = XMLmachineData.getXML("WandWaver", "description", "2");
			} else if (getLevel() == 2) {
				info = XMLmachineData.getXML("WandWaver", "description", "3");
			}
			
			Globals.infoBox.addText(info);
		}
	}
}