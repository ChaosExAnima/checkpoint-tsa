package gameLogic {
	/* This class encapsulates a metal detector with efficiency slider 
		and the possibility of an additional guard. */
		
	public class MetalDetector extends SliderMachine {
		
		protected var guard:Boolean = false;
		protected var priceGuard:int;
		protected var speedUpGuard:Number;
		protected var upgradeNextPrice:int;
		protected var upgradeNextAcc:Number;
		
		public function MetalDetector(unitName:String, mood:Number, price:int, sellFor:int, prohObjs:Array, accuracyMin:int, accuracyMax:int, speedMin:Number, speedMax:Number, priceGuard:int, speedUpGuard:Number, upgradePrice:int, upgradeAcc:Number) {
			super(unitName, mood, price, sellFor, prohObjs, accuracyMin, accuracyMax, speedMin, speedMax, priceGuard, speedUpGuard);
			this.priceGuard = priceGuard;
			this.speedUpGuard = speedUpGuard;
			this.upgradeNextPrice = upgradePrice;
			this.upgradeNextAcc = upgradeAcc;
			
		}
		
		//PRE: No guard was added yet.
		//POST: A guard is added to the MetalDetector - effects are set in priceGuard and speedUpGuard.
		public function addGuard():void {
			if (guard == false) {
				buy(priceGuard);
				//seelFor does not change, since we don't get anything back from selling the guard.
				speed = speed - speedUpGuard;
				speedMin = speedMin - speedUpGuard;
				speedMax = speedMax - speedUpGuard;
				this.upgradePrice = upgradeNextPrice;
				this.upgradeAccuracy = upgradeNextAcc;
				guard = true;
			}
		}
		
		// Determines if guard is added
		public function isGuard():Boolean {
			return guard;
		}
	}
}