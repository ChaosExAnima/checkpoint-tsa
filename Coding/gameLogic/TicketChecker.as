package gameLogic {
	/* Encapsulates the Ticket Checker, which, when in place, directs all passengers from the waiting area to a certain line at a station */
	import gameData.XMLmachineData;
	
	public class TicketChecker {
		private var price:int;
		private var speed:Number;
		private var powerUp:Boolean;
		private var pricePowerUp:int;
		private var sellFor:int;
		
		public function TicketChecker():void {
			price = int(XMLmachineData.getXML("TicketChecker", "price"));
			speed = Number(XMLmachineData.getXML("TicketChecker", "speed"));
			pricePowerUp = int(XMLmachineData.getXML("TicketChecker", "powerUpPrice"));
			sellFor = int(XMLmachineData.getXML("TicketChecker", "sellFor"));
		}
		
		//Sends passengers to a line. 
		//Without powerup: Random line
		//with powerup: shortest line
		public function sendPassengerToLine(pass:Passenger):void {
			
		}
		
	}
	
}