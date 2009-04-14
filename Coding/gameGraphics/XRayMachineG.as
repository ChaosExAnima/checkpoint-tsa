package gameGraphics {

	import gameLogic.XRayMachine;
	import flash.display.MovieClip;
	
	/* This class contains all variables and methods common to each graphical representation of a XRayMachine,
	   like the ability in the UI to power up gun or knife. */
	   
	public class XRayMachineG extends SliderMachineG {
	
		public function XRayMachineG(xLoc:Number, yLoc:Number, secCheck:XRayMachine, xrayMachine:MovieClip) {
			super(xLoc, yLoc, secCheck, xrayMachine);
		}
	}
}