package gameGraphics {

	import gameLogic.XRayMachine;
	import flash.display.MovieClip;
	
	/* This class contains all variables and methods common to each graphical representation of a XRayMachine,
	   like the ability in the UI to power up gun or knife. */
	   
	public class XRayMachineG extends SliderMachineG {
	
		public function XRayMachineG(xLoc:Number, yLoc:Number, secCheck:XRayMachine, xrayMachine:MovieClip) {
			super(xLoc, yLoc, secCheck, xrayMachine);
		}
		
		public override function upgrade(type:Boolean = false):void {
			if (type == false) {
				XRayMachine(secCheck).doPowerUpGunKnife();
				upgradeAcc[0] = XRayMachine(secCheck).upgradeAcc;
				upgradeType[0] = "gun";
				upgradeType[1] = "knife";
			} else {
				XRayMachine(secCheck).doPowerUpBomb();
				upgradeAcc[0] = XRayMachine(secCheck).upgradeAcc;
				upgradeType[0] = "bomb";
			}
		}
	}
}