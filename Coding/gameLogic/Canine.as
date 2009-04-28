package gameLogic {
/* This class generalizes the idea of having a DOG. This will be exploited by BombCanine and DrugCanine for instance.
	*/
	public class Canine extends SecurityCheckUnit{
		
		//Levels go from 1 to 3
		protected var level:int = 1;		
		//This is level 2
		protected var priceGermanShepherd:int;
		//This is level 2
		protected var germanShepherdAccuracy:int;
		//This is level 3
		protected var pricePig:int;		
		//This is level 3
		protected var pigAccuracy:int;
						
		public function Canine(unitName:String, mood:Number, speed:int, accuracy:int, price:int, sellFor:int, prohObjs:Array, level2Price:int, level2Accuracy:int, level3Price:int, level3Accuracy:int) {
			super(unitName, accuracy, speed, mood, price, sellFor, prohObjs, level2Price, level2Accuracy);
			
			priceGermanShepherd = level2Price;
			germanShepherdAccuracy = level2Accuracy;
			pricePig = level3Price;
			pigAccuracy = level3Accuracy;
		}
		
		//PRE: level=1 and must have enough money
		//POST: Upgrades to German Shepherd.
		public function germanShepherdUpgrade():void {
			buy(priceGermanShepherd);
			level = 2;
			accuracy = germanShepherdAccuracy;
			upgradePrice = pricePig;
			upgradeAccuracy = pigAccuracy;
		}
	
		//PRE: level=2 and must have enough money
		//POST: Upgrades to Pig
		public function pigUpgrade():void {
			buy(pricePig);
			level = 3;
			accuracy = pigAccuracy;
			upgradePrice = 0;
			upgradeAccuracy = 0;
		}
		
		public function getLevel():int {
			return level;
		}
	}
}
