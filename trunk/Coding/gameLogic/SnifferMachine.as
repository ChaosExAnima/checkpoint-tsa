package gameLogic {
	/* Encapsulates a sniffer machine, which besides efficiency slider,
		has the ability of an upgrade and has to be set to sniff either for bombs or for drugs.
	*/
	import gameData.XMLmachineData;
	
	public class SnifferMachine extends SliderMachine {
		
		//stores what are the Min and Max values to be set for accuracy
		private static var accuracyMin:int;
		private static var accuracyMax:int;
		
		//stores what are the Min and Max values to be set for speed
		private static var speedMin:int;
		private static var speedMax:int;
		
		private static var priceUpgrade:int;
		private static var speedUpgradeMin:int;
		private static var speedUpgradeMax:int;
		private var upgraded:Boolean;
		
		
		public function SnifferMachine() {
			super(XMLmachineData.getXML("SnifferMachine","name"),
				  Number(XMLmachineData.getXML("SnifferMachine","moodChange","1")), 
				  Number(XMLmachineData.getXML("SnifferMachine","price","1")),
				  Number(XMLmachineData.getXML("SnifferMachine","sellFor","1")),
				  [new Bomb()],
				  Number(XMLmachineData.getXML("SnifferMachine","accuracyMin","1")),
				  Number(XMLmachineData.getXML("SnifferMachine","accuracyMax","1")),
				  Number(XMLmachineData.getXML("SnifferMachine","speedMin","1")),
				  Number(XMLmachineData.getXML("SnifferMachine","speedMax","1")),
				  Number(XMLmachineData.getXML("SnifferMachine","powerUpPrice","1")),
				  Number(XMLmachineData.getXML("SnifferMachine","powerUpSpeedMin","1")));
		}

		//PRE: proObj must either be bomb or drugs
		//POST: Sets sniffingAt correspondingly.
		public function changeSniffingAt(proObj:ProhibitedObject) {
			prohObjs = null;
			prohObjs.push(proObj);
		}		
		
		//TODO:
		//PRE: upgraded is false.
		//POST: Upgrade is in place and details are set correctly.
		public function upgrade() {
			
		}
	}
	
}