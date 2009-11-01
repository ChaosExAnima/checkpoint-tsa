 package gameGraphics {

	import gameLogic.*;
	import gameData.XMLmachineData;
	import gameControl.Globals;
	import flash.display.MovieClip;
		
	/* Encapsulates the graphical representation of a Sniffer machine with the ability to choose what it is sniffing at and a speed upgrade. */
	   
	public class SnifferMachineG extends SliderMachineG {
	
		public function SnifferMachineG(xLoc:Number, yLoc:Number) {
			super(xLoc, yLoc, new SnifferMachine(), new GSnifferMachine());
			behindSprite =  new GSnifferMachineBack();
			this.addChild(behindSprite);
			this.addChild(unitForm);
		}
		
		public override function upgrade(type:Boolean = false):void {
			if (type == false) {
				swapSniffer();
			} else {
				SnifferMachine(secCheck).speedUp();
			}
		}
		
		public function swapSniffer():void {
			if (whatSniffing() == "bomb" ) {
				SnifferMachine(secCheck).changeSniffingAt(new Drugs());
			} else if (whatSniffing() == "drugs" ) {
				SnifferMachine(secCheck).changeSniffingAt(new Bomb());
			}
		}
		
		public override function showUpgradeInfoText(type:Boolean = false):void {
			
			var descrText:String = XMLmachineData.getXML("SnifferMachine", "description");
			
			var results:Array = descrText.split("|");
			
			if (type == true) {
				Globals.infoBox.addText(results[1]);
			} else if (type == false && whatSniffing() == "bomb") {
				Globals.infoBox.addText(results[2]);
			} else if (type == false && whatSniffing() == "drugs") {
				Globals.infoBox.addText(results[3]);
			}
		}
		
		private function whatSniffing():String {
			return (secCheck.getProhObjs()[0].getKindOfObj());
		}
		
		override public function idle():void {
			unitForm.gotoAndStop(1);
			if (behindSprite)
				(behindSprite as MovieClip).gotoAndStop(1);
		}
		
		override public function checking():void {
			(behindSprite as MovieClip).gotoAndStop(2);
		}
	}
}