﻿package gameLogic {
public class Gun extends ProhibitedObject {
	private static var kindOfGuns:Array = ["pistol", "machine gun"];
	private static var probOfGuns:Array = [0.6, 0.4]; //Probabilites must add up to 1
	
	public function Gun() {
		//assign kind of gun with a specified probability
		super("gun",
			 chooseKindOfKindOfObj(kindOfGuns, probOfGuns),
			 15,
			 5,
			 5,
			 50,
			 0.1);
	}
	
	public override function incidentMsg():String {
		return "A passenger was seen carrying a firearm aboard one of the planes!";
	}
}
}