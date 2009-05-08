package gameGraphics {
	import gameLogic.TicketChecker;
	import gameGraphics.PassengerG;
	import gameLogic.Airport;
	import flash.display.MovieClip;
	
	public class TicketCheckerG extends MovieClip {
		private var _unit:MovieClip;
		private var _logic:TicketChecker;
		private var _airport:AirportG;
		
		public function TicketCheckerG(airport:AirportG):void {
			_unit = new GTicketChecker();
			Airport.addTicketChecker();
			_logic = Airport.getTicketChecker();
			_airport = airport;
			this.addChild(_unit);
		}
		
				
		//Sends passengers to a line. 
		//Without powerup: Random line
		//with powerup: shortest line
		public function sendPassengerToLine(pass:PassengerG):void {
			var lineArray:Array = _airport.preline.getTargetedLines();
			lineArray = lineArray.sort();
			var targLine = _airport.lines[lineArray[0]-1].line;
			pass.setLine(targLine);
		}

	}
}