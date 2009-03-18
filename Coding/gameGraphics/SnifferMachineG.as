 package gameGraphics {

	import gameLogic.SnifferMachine;
	
	/* Encapsulates the graphical representation of a Sniffer machine with the ability to choose what it is sniffing at and a speed upgrade. */
	   
	public class SnifferMachineG extends SliderMachineG {
	
		public function SnifferMachineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new SnifferMachine(), new GSnifferMachine());
		}
		
		// Handles the ability in the UI of adding a guard.
		// This shall only allow to upgrade speed, if money is sufficient and if no upgrade has been executed yet.
	}
}