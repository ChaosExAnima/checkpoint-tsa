﻿package gameLogic {
public class Knife extends ProhibitedObject {
	private static var kindOfKnives:Array = ["knife 1", "knife 2"];
	private static var probOfKnives:Array = [0.6, 0.4]; //Probabilites must add up to 1
	
	public function Knife() {
		//assign kind of metal with a specified probability
		super ("knife",
				chooseKindOfKindOfObj(kindOfKnives, probOfKnives),
				5,
				1,
				1,
				10,
				0.1);
	}
	
	public override function incidentMsg():String {
		return "A passenger was discovered carrying a concealed knife!";
	}
}
}