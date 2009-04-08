package gameLogic {
	/* This class encapsulates an X-Ray machine with efficiency slider and possibilites for power ups. 
		It will be extendes by the CheepieXRayMachine and the SuperXRayMachine */
	public class XRayMachine extends SliderMachine{

		protected var powerUpGunKnife:Boolean=false;
		protected var powerUpBomb:Boolean=false;
		protected var pricePowerUpGunKnife:int;
		protected var pricePowerUpBomb:int;
		protected var accuracySpecialMin:int;
		protected var accuracySpecialMax:int;
		
		public function XRayMachine(
									unitName:String, 
									mood:Number, 
									price:int, 
									sellFor:int, 
									prohObjs:Array, 
									accuracyMin:int, 
									accuracyMax:int, 
									speedMin:Number, 
									speedMax:Number, 
									pricePowerUpGunKnife:int, 
									pricePowerUpBomb:int,
									accuracySpecialMin:int,
									accuracySpecialMax:int
									) {
			super(unitName, mood, price, sellFor, prohObjs, accuracyMin, accuracyMax, speedMin, speedMax);
			this.pricePowerUpGunKnife = pricePowerUpGunKnife;
			this.pricePowerUpBomb = pricePowerUpBomb;
			this.accuracySpecialMin = accuracySpecialMin;
			this.accuracySpecialMax = accuracySpecialMax;
		}
																	 
		
		//POST: All values are correctly set when Gun & Knife are powered up. 
		//If the power up for bombs is enabled, then does nothing
		public function doPowerUpGunKnife():void {
			if(powerUpGunKnife==false&&powerUpBomb==false) {
				buy(pricePowerUpGunKnife);
				sellFor = sellFor + pricePowerUpGunKnife/2;
				//TODO
				powerUpGunKnife = true;
			}
		}


		//POST: All values are correctly set when Bombs are powered up. 
		//If the power up for Gun & Knife is enabled, then does nothing
		public function doPowerUpBomb():void {
			if(powerUpGunKnife==false&&powerUpBomb==false) {
				buy(pricePowerUpBomb);
				sellFor = sellFor + pricePowerUpBomb/2;
				//TODO
				powerUpBomb = true;
			}
		}
		
		public function isPowerUpGunKnife():Boolean {
			return powerUpGunKnife;
		}
		
		public function isPowerUpBomb():Boolean {
			return powerUpBomb;
		}
		
		//Takes into account the special accuracy setting for power ups
		protected override function isCaught(pObj:ProhibitedObject):Boolean {
			var chance:Number = Math.random();
			
			if(pObj == null) return false;
			if ((pObj is Knife && powerUpGunKnife) || (pObj is Gun && powerUpGunKnife) || (pObj is Bomb && powerUpBomb)) {
				var bonus:int = accuracySpecialMin+((accuracySpecialMax-accuracySpecialMin)/2);
				if (chance<(((accuracy * Airport.getSecurityAlertLevelMultiplier())+bonus)/100)) 
					return true;
			} else if (prohObjs.some(testKindProhObjs))	{
				if (chance<((accuracy * Airport.getSecurityAlertLevelMultiplier())/100)) 
					return true;
			}
			return false;
			
			function testKindProhObjs(item:*, index:int, array:Array):Boolean {
				var elem:ProhibitedObject=item;
				return (elem.getKindOfObj() == pObj.getKindOfObj())
			}
		}
		
	}
	
}