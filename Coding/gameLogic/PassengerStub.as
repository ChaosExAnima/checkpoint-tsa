﻿package gameLogic {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import gameLogic.*
	//import gameLogic.PassengerSpriteStub;
	//import gameLogic.ProhibitedObject;
	
    public class PassengerStub
    {
		var m_sprite:PassengerSpriteStub;
		var m_conceal:int;
		var m_prohibObj:ProhibitedObject;
		
		public function PassengerStub()
		{
			m_sprite = new PassengerSpriteStub();
			m_conceal = 50;
			
			m_prohibObj = new ProhibitedObject("bomb", "littlebomb, 0.4",30,10,	25,	75,	0.9);
			//m_prohibObj = new Bomb();
			
			switch(Math.round(Math.random()*(3)))
			{
				case 0:
					m_prohibObj.setKindOfObj("bomb");// = ;
					break;
				case 1:
					m_prohibObj.setKindOfObj("drugs");// = ;
					break;
				case 2:
					m_prohibObj.setKindOfObj("gun");// = ;
					break;
				case 3:
					m_prohibObj.setKindOfObj("knife");// = ;
					break;
				default:
					m_prohibObj.setKindOfObj(null);// = ;
					break;
					
			}
													

			
		}
		
		public function carriesWhat():ProhibitedObject {return m_prohibObj;}
		public function GetConceal():int{ return m_conceal;}
		public function GetDistance(x:int, y:int):int{ return Math.sqrt(Math.pow(x-m_sprite.x,2)+Math.pow(y-m_sprite.y,2));}
		public function SetPos(x:int, y:int){ m_sprite.x = x; m_sprite.y = y;}
		
		public function SetConceal(conceal:int){ m_conceal = conceal;}
		public function SetSpriteMC(aMC:MovieClip) { m_sprite.SetMovieClip(aMC);}
		public function GetSprite(){ return m_sprite; }
    }
}