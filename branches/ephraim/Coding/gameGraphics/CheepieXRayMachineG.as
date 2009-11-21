package gameGraphics {
	
	import gameLogic.CheepieXRayMachine;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	
	
	
	/* Encapsulates the graphical representation of a Cheepie X-ray machine. */
	
	public class CheepieXRayMachineG extends XRayMachineG {
		
		public function CheepieXRayMachineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new CheepieXRayMachine(), new GCheepieXRayMachine());
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			var descrText:String = XMLmachineData.getXML("CheepieXrayMachine", "description");
			var results:Array = descrText.split("|");
			
			if (type == false) {
				Globals.infoBox.addText(results[1]);
			} else if (type == true) {
				Globals.infoBox.addText(results[2]);
			}
		}

	}
}