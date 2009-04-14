package gameGraphics {
	
	import gameLogic.Guard;
	import flash.display.MovieClip;
	
	public class GuardG extends SecurityCheckUnitG {
		
				
		public function GuardG(xLoc:Number, yLoc:Number, secCheck:Guard, guard:MovieClip) {
			super(xLoc, yLoc, secCheck, guard);
		}
		
		
		//Graphical interfaces for POWERUPS:

		//PRE: level=1 and must have enough money
		//POST: Upgrades to level 2.
		public override function upgrade(type:Boolean = false):void {
			if (getLevel() == 1) {
				Guard(secCheck).level2Training();
			} else if (getLevel() == 2) {
				Guard(secCheck).level3Training();
			}
		}
	
		public function getLevel():int {
			return (Guard(secCheck).getTraining());
		}
		
		public function getUpgradePrice():int {
			if (getLevel() != 3) {
				return (Guard(secCheck).getUpgradeStats(getLevel()+1)[0]);
			} else {
				return -1;
			}
		}
		
		public function getUpgradeAccuracy():int {
			if (getLevel() != 3) {
				return (Guard(secCheck).getUpgradeStats(getLevel()+1)[1]);
			} else {
				return -1;
			}
		}
	}
}