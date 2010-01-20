﻿package gameLogic {
public class Drugs extends ProhibitedObject {
	private static var kindOfDrugs:Array = ["cocaine", "ecstasy"];
	private static var probOfDrugs:Array = [0.6, 0.4]; //Probabilites must add up to 1
	
	public function Drugs() {
		//assign kind of drugs with a specified probability
		super ("drugs",
				chooseKindOfKindOfObj(kindOfDrugs, probOfDrugs),
				0, 
				0, //is that right that missing drugs does not hurt your reputation at all???
				10,
				100,
				0);
	}
	
	public override function incidentMsg():String {
		return "A passenger was caught using illegal substances about an airplane!";
	}
}
}