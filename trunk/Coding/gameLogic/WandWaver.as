package gameLogic {
	import gameData.*;
/*	A SecurityCheckUnit models either any kind of a Security Check unit, 
	which can be either a metal detector, X-ray machine, sniffing dogs or security personnel
*/	
	public class WandWaver extends Guard{		

		public function WandWaver(){
			super(XMLmachineData.getXML("WandWaver","name"),
				  Number(XMLmachineData.getXML("WandWaver", "moodChange","1")),
				  Number(XMLmachineData.getXML("WandWaver", "accuracy","1")),
				  Number(XMLmachineData.getXML("WandWaver", "speed","1")),
				  Number(XMLmachineData.getXML("WandWaver", "price", "1")),
				  Number(XMLmachineData.getXML("WandWaver", "sellFor", "1")),
				  [new Bomb(), new Knife(), new Gun()],
				  Number(XMLmachineData.getXML("WandWaver", "price", "2")),
				  Number(XMLmachineData.getXML("WandWaver", "accuracy","2")),
				  Number(XMLmachineData.getXML("WandWaver", "speed","2")),
				  Number(XMLmachineData.getXML("WandWaver", "moodChange","2")),
				  Number(XMLmachineData.getXML("WandWaver", "price", "3")),
				  Number(XMLmachineData.getXML("WandWaver", "accuracy","3")),
				  Number(XMLmachineData.getXML("WandWaver", "speed","3")),
				  Number(XMLmachineData.getXML("WandWaver", "moodChange","3"))				  
				  ); //READ IN FROM XML:
		}	
	}
}
