package gameGraphics {
	
	import gameLogic.SuperXRayMachine;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	
	
	/* Encapsulates the graphical representation of a Super X-ray machine with the possibility to fill an extra space. */
	
	public class SuperXRayMachineG extends XRayMachineG {
		
		public function SuperXRayMachineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new SuperXRayMachine(), new GSuperXRayMachine());
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			var descrText:String = XMLmachineData.getXML("SuperXrayMachine", "description");
			var results:Array = descrText.split("|");
			
			if (type == false) {
				Globals.infoBox.addText(results[1]);
			} else if (type == true) {
				Globals.infoBox.addText(results[2]);
			}
		}
	}
}