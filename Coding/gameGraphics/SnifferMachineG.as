 package gameGraphics {

	import gameLogic.*;
	
	/* Encapsulates the graphical representation of a Sniffer machine with the ability to choose what it is sniffing at and a speed upgrade. */
	   
	public class SnifferMachineG extends SliderMachineG {
	
		public function SnifferMachineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new SnifferMachine(), new GSnifferMachine());
		}
		
		public override function upgrade(type:Boolean = false):void {
			if (type == false) {
				swapSniffer();
			} else {
				SnifferMachine(secCheck).speedUp();
			}
		}
		
		public function swapSniffer():void {
			if ((secCheck.getProhObjs()[0].getKindOfObj()) == "bomb" ) {
				SnifferMachine(secCheck).changeSniffingAt(new Drugs());
			} else {
				SnifferMachine(secCheck).changeSniffingAt(new Bomb());
			}
		}
	}
}