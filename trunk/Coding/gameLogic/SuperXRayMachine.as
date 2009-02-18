package gameLogic {
	import gameData.*;
	/* Encapsulates the SuperXRayMachine with the ability of an extra space 
		for a security check unit as well as Instant detect */
		
		//This is Xray level 2 in the XML
		
	public class SuperXRayMachine extends XRayMachine {
		
		public function SuperXRayMachine() {
			super("Super X-Ray Machine",
				  Number(XMLmachineData.getXML("Xray","moodChange","2")), 
				  Number(XMLmachineData.getXML("Xray","price","2")),
				  Number(XMLmachineData.getXML("Xray","sellFor","2")),
				  [new Bomb(), new Knife(), new Gun()],
				  Number(XMLmachineData.getXML("Xray","accuracyMin","2")),
				  Number(XMLmachineData.getXML("Xray","accuracyMax","2")),
				  Number(XMLmachineData.getXML("Xray","speedMin","2")),
				  Number(XMLmachineData.getXML("Xray","speedMax","2")),
				  Number(XMLmachineData.getXML("Xray","powerUpGunKnifePrice","2")),
				  Number(XMLmachineData.getXML("Xray","powerUpBombPrice","2"))); //READ IN FROM XML:
				  
				  instaDetect = true;
		}
		
		//WILL NOT BE IMPLEMENTED
		//creates an extra space in the station and fills it with a Security Check Unit
		/*public function fillExtraSpace(secCheckUnit:SecurityCheckUnit):void {
			return null;
		}
		*/
	}
}