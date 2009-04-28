package gameGraphics {
	import gameLogic.TicketChecker;
	import gameLogic.Passenger;
	import flash.display.MovieClip;
	
	public class TicketCheckerG extends MovieClip {
		private var _unit:MovieClip;
		private var _logic:TicketChecker;
		private var _airport:AirportG;
		
		public function TicketCheckerG(airport:AirportG):void {
			_unit = new GTicketChecker();
			_logic = new TicketChecker();
			_airport = airport;
			this.addChild(_unit);
		}
		
				
		//Sends passengers to a line. 
		//Without powerup: Random line
		//with powerup: shortest line
		public function sendPassengerToLine(pass:Passenger):void {
			var lineArray:Array = _airport.preline.getTargetedLines();
			//trace("winners of pop contest: "+lineArray.sort());
			lineArray = lineArray.sort();
			var targLine = _airport.lines[lineArray[0]].line;
			pass.setLine(targLine);
		}

	}
}