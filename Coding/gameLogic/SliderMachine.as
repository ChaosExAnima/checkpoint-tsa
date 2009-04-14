package  gameLogic{
	/* This class generalizes the idea of having a slider. This will be exploited by XRayMachine or Metaldetector for instance.
	*/
	import gameControl.TheGame;
	
	public class SliderMachine extends SecurityCheckUnit {
		//stores what are the Min and Max values to be set for accuracy by the slider
		protected var accuracyMin:int;
		protected var accuracyMax:int;
		
		//stores what are the Min and Max values to be set for speed by the slider
		protected var speedMin:int;
		protected var speedMax:int;
		
		protected var sliderPercentage:int = 50;
		
		public function SliderMachine(unitName:String, mood:Number, price:int, sellFor:int, prohObjs:Array,accuracyMin:int, accuracyMax:int, speedMin:int, speedMax:int, upgradePrice:int, upgradeAcc:Number) {
			super(unitName, (accuracyMin+accuracyMax)/2, (speedMin+speedMax)/2, mood, price, sellFor, prohObjs, upgradePrice, upgradeAcc);
			this.accuracyMin = accuracyMin;
			this.accuracyMax = accuracyMax;
			this.speedMin = speedMin;
			this.speedMax = speedMax;
		}
		
		//PRE: percentage between 0 and 100.
		//POST: accuracy and speed is set in the min and max range according to percentage
		public function  accSpeedSlide(percentage:int):void{
			sliderPercentage = percentage;
			accuracy = ((accuracyMax-accuracyMin)/100)*sliderPercentage + accuracyMin;
			speed = ((speedMin-speedMax)/100)*sliderPercentage + speedMax;
			speed = TheGame.minToGameTime(speed);
		}
		
		public function getSlideVal():int {
			return (sliderPercentage);
		}
	}
}