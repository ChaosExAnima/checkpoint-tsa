﻿package gameLogic {
	import gameData.*;
/*	A SecurityCheckUnit models either any kind of a Security Check unit, 
	which can be either a metal detector, X-ray machine, sniffing dogs or security personnel
*/	
	public class DrugCanine extends Canine{		

		public function DrugCanine(){
			super(XMLmachineData.getXML("DrugCanine","name"),
				  Number(XMLmachineData.getXML("DrugCanine","moodChange","1")),
				  Number(XMLmachineData.getXML("DrugCanine","speed","1")),
				  Number(XMLmachineData.getXML("DrugCanine","accuracy","1")),
				  Number(XMLmachineData.getXML("DrugCanine", "price", "1")),
				  Number(XMLmachineData.getXML("DrugCanine", "sellFor", "1")),
				  [new Drugs()],
				  Number(XMLmachineData.getXML("DrugCanine", "price", "2")),
				  Number(XMLmachineData.getXML("DrugCanine","accuracy","2")),
				  Number(XMLmachineData.getXML("DrugCanine", "price", "3")),
				  Number(XMLmachineData.getXML("DrugCanine","accuracy","3"))	
				  ); //READ IN FROM XML:
		
		}		
	}
}
