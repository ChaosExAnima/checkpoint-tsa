package gameUI
{
	import utilities.*;
	import flash.display.*;
	import flash.events.*;
	//import gameLogic.Airport;
	import flash.display.MovieClip;
	
	public class UI_MenusG extends MovieClip
	{
		//public var escalatorA:Escalator = new Escalator();
		//public var escalatorB:Escalator = new Escalator();
		//public var escalatorC:Escalator = new Escalator();
		
		//public var floor:Floor = new Floor(10, 10, 0, 0, 800, 600);
		
		//Unit form that is displayed by SecurityCheckUnitG
		private var unitForm:MovieClip;
		private var airportEnv:GAirport   = new GAirport();
		
		//Logical security check unit	
		private var airportAI:Airport = new Airport();
		
		private var xLoc:Number;
		private var yLoc:Number;
		
		
		public function AirportG(xLoc:Number, yLoc:Number):void
		{
			//public function SecurityCheckUnitG(xLoc:Number, yLoc:Number, secCheck:SecurityCheckUnit, secCheckG:MovieClip) {
		    this.xLoc = xLoc;//Utilities.randRange(0,700);
			this.yLoc = yLoc;//Utilities.randRange(0,500);
			//this.airport = airport;
			this.unitForm = airportEnv;
			
			this.addChild(unitForm);
			//airport.AirportG(this);
			//this.addEventListener(Event.ENTER_FRAME, frameEntered);
			drawMe();
			//idle();
		}

		
		private function drawMe():void {
			unitForm.x = xLoc;
			unitForm.y = yLoc;
		}
		
		
		/*public function moveToFloor(escalator:Escalator, index:uint):void
		{
			floor.receivePass(escalator.losePass(index));
		}*/
	}
}