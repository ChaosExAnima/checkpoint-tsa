package gameLogic {
	
	/* Superclass for Clown and the Entertainment display, classes that add mood to all passengers standing in the specific line*/
	public class MoodUnit extends SecurityCheckUnit{
		
		public function MoodUnit(unitName:String, accuracy:int, speed:Number, mood:Number, price:int, sellFor:int, prohObjs:Array) {
			super(unitName, accuracy, speed, mood, price, sellFor, prohObjs, 0, 0);
		}
		
		//Every specific time unit, should add mood to the people standing in the line where the mood unit belongs to 
		public function addMoodToPeopleInLine():void {
			station.getLine().increaseMood(mood);
		}
		
		//Tells whether a specific mood unit is allowed to be built in a certain line
		//Can only be built if there is not already one of the the same kind in place.
		public function permitted(line:Line):Boolean {
			//TODO:
			return true;
		}
		
	}
}