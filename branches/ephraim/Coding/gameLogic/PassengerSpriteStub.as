package gameLogic
{
	import flash.display.DisplayObject;
    import flash.display.Sprite;
	import flash.display.MovieClip;
	
    public class PassengerSpriteStub extends Sprite
    {
		var m_passengerMC:MovieClip;
		
		public function PassengerSpriteStub(){ }
		
		public function SetMovieClip(aMC:MovieClip)
		{
			m_passengerMC = aMC;
			addChild(m_passengerMC);
		}

    }
}
