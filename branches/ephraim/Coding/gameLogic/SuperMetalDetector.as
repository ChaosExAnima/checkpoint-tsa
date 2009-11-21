package gameLogic {
	import gameData.*
	/* Encapsulates the Super Metal Detector and implements InstaDetect */
	public class SuperMetalDetector extends MetalDetector{
		
		
		public function SuperMetalDetector() {
			super(XMLmachineData.getXML("SuperMetalDetector","name"),
				  Number(XMLmachineData.getXML("SuperMetalDetector","moodChange","1")), 
				  Number(XMLmachineData.getXML("SuperMetalDetector","price","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","sellFor","1")),
				  [new Bomb(), new Knife(), new Gun()],
				  Number(XMLmachineData.getXML("SuperMetalDetector","accuracyMin","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","accuracyMax","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","speedMin","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","speedMax","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","speedUpGuardPrice","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","speedUpGuardSpeed","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetector","powerUpGunPrice","1")),
				  Number(XMLmachineData.getXML("SuperMetalDetecter","powerUpAccuracyMin","1"))
				  ); //READ IN FROM XML:
				  //instaDetect = true;
		}
	}
}