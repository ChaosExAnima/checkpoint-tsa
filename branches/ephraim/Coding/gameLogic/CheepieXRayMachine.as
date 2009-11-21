package gameLogic {
	
	import gameData.*;
	/* Encapsulates the CheepieXrayMachine. */
	
	//This is Xray Level 1 in XMLmachineData
	
	public class CheepieXRayMachine extends XRayMachine {
		
		
		public function CheepieXRayMachine() {
			super(XMLmachineData.getXML("CheepieXrayMachine","name"),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","moodChange","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","price", "1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","sellFor", "1")),
				  [new Bomb(), new Knife(), new Gun()],
				  Number(XMLmachineData.getXML("CheepieXrayMachine","accuracyMin","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","accuracyMax","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","speedMin","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","speedMax","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","powerUpGunKnifePrice","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","powerUpBombPrice","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","powerUpAccuracyMin","1")),
				  Number(XMLmachineData.getXML("CheepieXrayMachine","powerUpAccuracyMax","1"))
				  ); //READ IN FROM XML:
			//trace("CONSTR(CheepieXRay): " +  Number(XMLmachineData.getXML("Xray","moodChange","1")));
		}
	}
}