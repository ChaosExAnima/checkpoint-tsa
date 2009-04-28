package gameGraphics {
	import gameLogic.TicketChecker;
	import flash.display.MovieClip;
	
	public class TicketCheckerG extends MovieClip {
		private var _unit:MovieClip;
		private var _logic:TicketChecker;
		
		public function TicketCheckerG():void {
			_unit = new GTicketChecker();
			_logic = new TicketChecker();
		}
	}
}