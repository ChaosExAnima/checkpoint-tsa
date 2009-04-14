package gameLogic {
/* This class generalizes the idea of having a Guard. This will be exploited by BagChecker and WandWaver for instance.
	*/
	public class Guard extends SecurityCheckUnit{
		
		protected var trainingLevel:int = 1; 
		//This determines the training level for the personnel in charge of checking bags.Range (1 - 3)
		protected var priceTraining2:int;
		//This determines the Price for Training Level 2 for the bag checker and wand waver personnel
		protected var priceTraining3:int;
		//This determines the Price for Training Level 3 for the bag checker and wand waver personnel
		protected var accuracyTraining2:int;
		//This determines the Accuracy for Training Level 2 for the bag checker and wand waver personnel
		protected var accuracyTraining3:int;
		//This determines the Accuracy for Training Level 3 for the bag checker and wand waver personnel
		protected var speedTraining2:int;
		//This determines the Speed for Training Level 2 for the bag checker and wand waver personnel
		protected var speedTraining3:int;
		//This determines the Speed for Training Level 3 for the bag checker and wand waver personnel		
		protected var moodTraining2:int;
		//This determines the Mood for Training Level 2 for the bag checker and wand waver personnel
		protected var moodTraining3:int;
		//This determines the Mood for Training Level 3 for the bag checker and wand waver personnel
						
		public function Guard(unitName:String, mood:Number, speed:int, accuracy:int, price:int, sellFor:int, prohObjs:Array, level2price:int, level2accuracy:int, level2speed:int, level2mood:Number, level3price:int, level3accuracy:int, level3speed:int, level3mood:Number) {
			super(unitName, accuracy, speed, mood, price, sellFor, prohObjs, level2price, level2accuracy);
			
			priceTraining2 = level2price;
			priceTraining3 = level3price;
			accuracyTraining2 = level2accuracy;
			accuracyTraining3 = level3accuracy;
			speedTraining2 = level2speed;
			speedTraining3 = level3speed;
			moodTraining2 = level2mood;
			moodTraining3 = level3mood;
		}
		
		
		//PRE: level=1
		//POST: Upgrades to Better Security.
		public function level2Training():void {
			trainingLevel = 2;
			price = priceTraining2;
			accuracy = accuracyTraining2;
			upgradePrice = priceTraining3;
			upgradeAccuracy = accuracyTraining3;
			speed = speedTraining2;
			mood = moodTraining2;
		}
	
		//PRE: level=2
		//POST: Upgrades to BE THE BEST SECURITY
		public function level3Training():void {			
			trainingLevel = 3;
			price = priceTraining3;
			accuracy = accuracyTraining3;
			upgradePrice = 0;
			upgradeAccuracy = 0;
			speed = speedTraining3;
			mood = moodTraining3;
		}
		
		public function getTraining():int {
			return trainingLevel;
		}
		
		public function getUpgradeStats(level:int):Array {
			if (level == 2) {
				return [priceTraining2, accuracyTraining2-accuracy];
			} else if (level == 3) {
				return [priceTraining3, accuracyTraining3-accuracy];
			}
			return null;
		}
	}
}
