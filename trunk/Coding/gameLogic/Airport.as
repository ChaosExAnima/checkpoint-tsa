package gameLogic {
/*
	This class models the airport as a whole
*/
public class Airport {
	
	//sets the overall security alert level from 1 to 5.
	private static var securityAlertLevel:int=3;
	//Gives a color description of the security alert level. 1: green, 2: blue, 3: yellow, 4: orange, 5: red
	private static var securityAlertLevelColors:Array; //String
	
	//stores the stations built up in the airport, first station is at index 0, fifth station at index 4
	//Center station is always created with the Airport:
	private static var stations:Array = new Array(5); //Stations
	
	//stores the number of stations built in the aiport
	private static var nrStations:int=0;
	
	//stores the TicketChecker used in the airport
	private static var ticketChecker:TicketChecker;
	
	//stores the WaitingArea used in the airport
	private static var waitingArea:WaitingArea = new WaitingArea();
	
	public function Airport() {
		//addStation(3);
	}

	//PRE: level between 1 and 5
	//POST: changes the security alert to level, if its value is between one and five. 
	public static function changeSecurityAlertLevel(level:int):void {
		if (level >= 1 && level <= 5)
			securityAlertLevel = level;
	}
	
	public static function getSecurityAlertLevel():int {
		return securityAlertLevel;
	}
	
	//returns how many percent the set accuracy at level 3 has to be changed
	//multiply return value with actual set value to get actual accuracy level
	internal static function getSecurityAlertLevelMultiplier():Number {
		switch(securityAlertLevel) {
			case 1:
				return 0.8;
			case 2:
				return 0.9;
			case 3:
				return 1;	
			case 4:
				return 1.1;
			case 5:
				return 1.2;
			default:
				return 0;
		}
	}
	
	//adds a station to the airport, where 1 <= place <= 5
	public static function addStation(place:int):void {
		nrStations++;
		stations[place-1] = new Station(place);
		trace("nrStations = "+nrStations);
	}
	
	//removes a station from the airport, where 1 <= place <= 5
	public static function removeStation(place:int):void {
		stations[place-1] = null;
		nrStations--;
	}
	
	public static function getNrStations():int {
		return nrStations;
	}
	
	//returns specific station in the airport, where 1 <= place <=5
	public static function getStation(place:int):Station {
		return stations[place-1];
	}
	
	public static function getWaitingArea():WaitingArea {
		return waitingArea;
	}
	
	//PRE: A TicketChecker must not exist yet.
	public static function addTicketChecker():void {
		ticketChecker = new TicketChecker();
	}
	
	public static function getTicketChecker():TicketChecker {
		return ticketChecker;
	}
	
	public static function hasTicketChecker():Boolean {
		if (ticketChecker == null) return false;
		else return true;
	}
	
}
}