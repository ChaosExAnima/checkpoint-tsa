package gameLogic {
public class Bomb extends ProhibitedObject {
	private static var kindOfBombs:Array = ["little bomb", "A-bomb"];
	private static var probOfBombs:Array = [0.6, 0.4]; //Probabilites must add up to 1
	
	public function Bomb() {
		//assign kind of bomb with a specified probability
		super ("bomb",
				chooseKindOfKindOfObj(kindOfBombs, probOfBombs),
				30,
				10,
				25,
				75,
				0.9);
	}
	
	public override function incidentMsg():String {
		return "An explosive device was found on a passenger on one of the airplanes!";
	}
}
}