package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.events.*;
	
	public class GraphPassFact
	{
		
		private var pFact:PassengerFactory = new PassengerFactory();
		private var pA:AirportG;
		private var _torsoRef:Torso = new Torso();
		private var _gen:NameGen = new NameGen();
		
		public function GraphPassFact(parAir:AirportG):void
		{
			pA = parAir;
		}
		
		public function makePass():PassengerG
		{

			var passTorso:MovieClip = _torsoRef.getTorso();
			var passName:String = _gen.getName(_torsoRef.getGender());
			var torsoColors:Array = _torsoRef.setColor(passTorso);
			
			var tempLogic:Passenger = pFact.createPassenger();
			var tempPass:PassengerG = new PassengerG(Utilities.randRange(-10,10),Utilities.randRange(-10,10), tempLogic, pA.lines[tempLogic.getGotoStationNr() - 1].line, passTorso, torsoColors, passName);
			
			return tempPass;
		}
	}
}