package gameGraphics {
	
	import gameLogic.DrugCanine;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	
	public class DrugCanineG extends CanineG {
		
		public function DrugCanineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new DrugCanine(), new GCanineBeagle(), 3);
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			var info:String;
			
			if (level == 1) {
				info = XMLmachineData.getXML("DrugCanine", "description", "2");
			} else if (level == 2) {
				info = XMLmachineData.getXML("DrugCanine", "description", "3");
			}
			
			Globals.infoBox.addText(info);
		}
	}
}