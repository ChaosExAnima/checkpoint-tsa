package gameGraphics {
	
	import gameLogic.BombCanine;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	
	public class BombCanineG extends CanineG {
		
		public function BombCanineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new BombCanine(), new GCanineBeagle(),2);
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			var info:String;
			
			if (level == 1) {
				info = XMLmachineData.getXML("BombCanine", "description", "2");
			} else if (level == 2) {
				info = XMLmachineData.getXML("BombCanine", "description", "3");
			}
			
			Globals.infoBox.addText(info);
		}
	}
}