package gameLogic {
/* 
	This class creates passengers and puts them somewhere on the waiting area
*/

import utilities.*;

public class PassengerFactory {
		
	//These constants define the range of initial mood of a newly created passenger.
	//Mood ranges [0,125], where 125 means best, 0 worst
	private const initialMoodMin:int = 25;
	private const initialMoodMax:int = 125;
	
	//These constants define the range of how fast mood gets worse when passengers are waiting
	private const moodCoeffMin:int = 1;
	private const moodCoeffMax:int = 2;
	
	//These constants define the range of the time left (in min) for the airplane to take off for a newly created passenger
	private const timeLeftMin:int = 45;
	private const timeLeftMax:int = 180;
	
	//These constants define the range of the concealment for a newly created passenger
	private const concealmentMin:int = 0;
	private const concealmentMax:int = 100;
	
	//probability of a newly created passenger carrying a prohibited item
	private const illegal:Number = 0.6; //0.1
		
	public function createPassenger():Passenger {
		var initMood:int = Utilities.randRange(initialMoodMin,initialMoodMax);
		var moodCoeff:int = Utilities.randRange(moodCoeffMin,moodCoeffMax);
		var initTimeLeft:int = Utilities.randRange(timeLeftMin,timeLeftMax);
		var concealment:int = Utilities.randRange(concealmentMin, concealmentMax); // perhaps other function => Gauss' bell curve?
		var gotoStation:Station = randomStation();
		
		if (ifIllegal()) {
			return new Passenger(initMood, moodCoeff, initTimeLeft, concealment, carries(), gotoStation);
		}
		else {
			return new Passenger(initMood, moodCoeff, initTimeLeft, concealment, null, gotoStation);
		}
	}
	
	
	//Returns a random exisiting station, if at least one exists.
	//If not, returns null.
	private function randomStation():Station {
		var nrStat:int = Airport.getNrStations();
		
		if(nrStat==0) return null;
		
		var dice:int=Utilities.randRange(1,nrStat);
		
		return Airport.getStation(dice);
	}
	
	//Pre: Passenger is carrying a prohibited object
	//decides what prohibited object a passenger is carrying
	private function carries():ProhibitedObject {
		return ProhibitedObjectFactory.createProhibitedObject();
	}
	
	//decides whether a passenger carries a prohibited object or not
	private function ifIllegal():Boolean {
		if(Math.random()<illegal) return true;
		else return false;
	}
	
}
}