package gameGraphics {
	
	import gameLogic.Canine;
	import flash.display.MovieClip;
	
	public class CanineG extends SecurityCheckUnitG {
		
		//Stores what uniform is displayed for the guard.
		//2 for Bombs, 3 for Drugs. These numbers are not arbitrary, since they refer to the specific timeline frame of the GCanine instance.
		private var canineTimeLine:int;
		protected var level:int = 1;
		
		public function CanineG(xLoc:Number, yLoc:Number, secCheck:Canine, canine:MovieClip, canineTimeLine:int) {
			this.canineTimeLine = canineTimeLine;
			var specificCanine:MovieClip = canine;
			specificCanine.kindOfCanine.gotoAndStop(canineTimeLine);
			super(xLoc, yLoc, secCheck, specificCanine);
			
		}
		
		public override function upgrade(type:Boolean = false):void {
			if (level == 1) {
				germanShepherdUpgrade();
			} else if (level == 2) {
				pigUpgrade();
			} else {
				trace("No more upgrades!");
			}
		}
		
		//Graphical interfaces for POWERUPS:

		//PRE: level=1 and must have enough money
		//POST: Upgrades to German Shepherd.
		public function germanShepherdUpgrade():void {
			var mc = new GCanineShepherd();
			mc.kindOfCanine.gotoAndStop(canineTimeLine);
			mc.gotoAndStop(1);
			swapUnitForm(mc);
			Canine(secCheck).germanShepherdUpgrade();
			level = 2;
		}
	
		//PRE: level=2 and must have enough money
		//POST: Upgrades to Pig
		public function pigUpgrade():void {
			var mc = new GCaninePig();
			mc.kindOfCanine.gotoAndStop(canineTimeLine);
			mc.gotoAndStop(1);
			swapUnitForm(mc);
			Canine(secCheck).pigUpgrade();
			level = 3;
		}
	}
}