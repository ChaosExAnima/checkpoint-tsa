package gameLogic {
	import gameData.*;
	
	/* Encapsulates the Cheepie Metal Detector with the power up possibilites for guns or knives */
	public class CheepieMetalDetector extends MetalDetector {
		private static var pricePowerUpKnife:int = Number(XMLmachineData.getXML("CheapieMetalDetector","powerUpKnifePrice","1"));//READ IN FROM XML:
		private static var pricePowerUpGun:int = Number(XMLmachineData.getXML("CheapieMetalDetector","powerUpGunPrice","1"));//READ IN FROM XML:
		
		//Power up changes accuracy for only one object. The min and max values are stored in these variables.
		private static var accuracySpecialMin:int = Number(XMLmachineData.getXML("CheapieMetalDetector","powerUpAccuracyMin","1"));//READ IN FROM XML:
		private static var accuracySpecialMax:int = Number(XMLmachineData.getXML("CheapieMetalDetector","powerUpAccuracyMax","1"));//READ IN FROM XML:
		
		private var powerUpKnife:Boolean = false;
		private var powerUpGun:Boolean = false;
		
		public function CheepieMetalDetector() {
			super(XMLmachineData.getXML("CheepieMetalDetector","name"),
				  Number(XMLmachineData.getXML("CheepieMetalDetector","moodChange","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","price","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","sellFor","1")), 
				  [new Gun(), new Knife()], 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","accuracyMin","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","accuracyMax","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","speedMin","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","speedMax","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","speedUpGuardPrice","1")), 
				  Number(XMLmachineData.getXML("CheepieMetalDetector","speedUpGuardSpeed","1"))
				  );//READ IN FROM XML:
			trace("XML data: "+accuracySpecialMin);
		}
		
		//PRE: There has to be a guard installed.
		//POST: All values are correctly set when Knife is powered up. 
		//If the power up for guns is enabled, then does nothing
		public function doPowerUpKnife():void {
			if(powerUpKnife==false&&powerUpGun==false&&guard==true) {
				buy(pricePowerUpKnife);
				sellFor = sellFor + pricePowerUpKnife/2;
				//TODO
				powerUpKnife = true;
			}
		}

		//PRE: There has to be a guard installed.
		//POST: All values are correctly set when Gun is powered up. 
		//If the power up for Knife is enabled, then does nothing
		public function doPowerUpGun():void {
			if(powerUpKnife==false&&powerUpGun==false&&guard==true) {
				buy(pricePowerUpGun);
				sellFor = sellFor + pricePowerUpGun/2;
				//TODO
				powerUpGun = true;
			}
		}
		
		// Returns true is machine is upgraded
		public function isPowerUpKnife():Boolean {
			return (powerUpKnife == true);
		}
		
		public function isPowerUpGun():Boolean {
			return (powerUpGun == true);
		}
		
		
		//Takes into account the special accuracy setting for power ups
		protected override function isCaught(pObj:ProhibitedObject):Boolean {
			var chance:Number = Math.random();
			
			if(pObj == null) return false;
			if ((pObj is Knife && powerUpKnife) || (pObj is Gun && powerUpGun)) {
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