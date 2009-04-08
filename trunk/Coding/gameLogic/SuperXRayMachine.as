package gameLogic {
	import gameData.*;
	/* Encapsulates the SuperXRayMachine with the ability of an extra space 
		for a security check unit as well as Instant detect */
		
		//This is Xray level 2 in the XML
		
	public class SuperXRayMachine extends XRayMachine {
		
		public function SuperXRayMachine() {
			super(XMLmachineData.getXML("SuperXrayMachine","name","1"),
				  Number(XMLmachineData.getXML("SuperXrayMachine","moodChange","1")), 
				  Number(XMLmachineData.getXML("SuperXrayMachine","price","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","sellFor","1")),
				  [new Bomb(), new Knife(), new Gun()],
				  Number(XMLmachineData.getXML("SuperXrayMachine","accuracyMin","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","accuracyMax","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","speedMin","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","speedMax","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","powerUpGunKnifePrice","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","powerUpBombPrice","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","powerUpAccuracyMin","1")),
				  Number(XMLmachineData.getXML("SuperXrayMachine","powerUpAccuracyMax","1"))
				  ); //READ IN FROM XML:
				  
				  //instaDetect = true; //Needs to be defined somewhere!
		}
		
		//WILL NOT BE IMPLEMENTED
		//creates an extra space in the station and fills it with a Security Check Unit
		/*public function fillExtraSpace(secCheckUnit:SecurityCheckUnit):void {
			return null;
		}
		*/
	}
}