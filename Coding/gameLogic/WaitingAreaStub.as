package gameLogic{
	
	import gameLogic.PassengerStub;
	
    public class WaitingAreaStub
    {
		var m_passengerArray:Array;
		
		public function WaitingAreaStub()
		{
			m_passengerArray = new Array();
		}

		public function AddPassenger(passenger:PassengerStub)
		{
			m_passengerArray.push(passenger);
		}
		
		public function GetPassengerAtIndex(index:int){ return m_passengerArray[index];}

    }
}
