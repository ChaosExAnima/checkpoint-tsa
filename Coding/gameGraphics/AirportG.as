package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import gameControl.TheGame;
	import gameData.XMLgameData;
	import gameUI.Interface;
	import flash.display.*;
	import flash.events.*;

	
	public class AirportG extends Sprite
	{
		public var personMaker:GraphPassFact;
		
		public var escalatorA:Escalator = new Escalator();
		public var escalatorB:Escalator = new Escalator();
		public var escalatorC:Escalator = new Escalator();
		public var escalatorD:Escalator = new Escalator();
		public var escalatorE:Escalator = new Escalator();
		
		public var lines = new Array();
		private var gLines = new Array(new Sprite(), new GExit1(), 
									   new Sprite(), new GExit2(), 
									   new Sprite(), new GExit3(), 
									   new Sprite(), new GExit4(), 
									   new Sprite(), new GExit5());
		private var ticketChecker:MovieClip;
		
		public static const FLOOR_X = 105;
		public static const FLOOR_Y = 550;
		
		public var afloor:Floor = new Floor(10, 10, FLOOR_X, FLOOR_Y, 1000, 600); // The floor
		public var preline:Floor = new Floor(10, 10, FLOOR_X, FLOOR_Y, 1000, 600); // The preline
		
		public function AirportG():void
		{
			preline.setTarget(afloor);
			afloor.setTarget(null);

			this.addChild(escalatorA);
			this.addChild(new GEscalator1());
			this.addChild(escalatorB);
			this.addChild(new GEscalator2());
			this.addChild(escalatorC);
			this.addChild(new GEscalator3());
			this.addChild(escalatorD);
			this.addChild(new GEscalator4());
			this.addChild(escalatorE);
			this.addChild(new GFadeOut);
			
			personMaker = new GraphPassFact(this);
			
			this.addChild(afloor);
			this.addChild(preline);
			
			for (var i:int = 0; i < gLines.length; i++) {
				this.addChild(gLines[i]);
				if (gLines[i] is MovieClip) {
					gLines[i].mouseEnabled = false;
					gLines[i].mouseChildren = false;
				}
			}
			
			escalatorA.x = 20;
			escalatorA.y = 1080;
			
			escalatorB.x = 120;
			escalatorB.y = 1130;
			
			escalatorC.x = 220;
			escalatorC.y = 1180;
			
			escalatorD.x = 320;
			escalatorD.y = 1230;
			
			escalatorE.x = 420;
			escalatorE.y = 1280;
			
			var offset:uint = 55;
			
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
				
		// Moves people at top of escalator to floor
		private function frameEntered(e:Event)
		{
			var waiting:Array = escalatorA.getWaiting();
			for(var i = 0; i < waiting.length; i++)
			{
				moveToPreline(waiting[i], escalatorA);
			}
			
			waiting = escalatorB.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToPreline(waiting[i], escalatorB);
			}
			
			waiting = escalatorC.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToPreline(waiting[i], escalatorC);
			}
			
			waiting = escalatorD.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToPreline(waiting[i], escalatorD);
			}
			
			waiting = escalatorE.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToPreline(waiting[i], escalatorE);
			}
			
			
		}
		
		// Moves people to floor
		private function moveToPreline(pass:PassengerG, escalator:Escalator):void
		{			
			pass.x = (escalator.x-preline.x) + pass.x;
			pass.y = (escalator.y-preline.y) + pass.y;
			preline.receivePass(pass);
		}
			
		public function addPass():void
		{
			
			switch(Utilities.randRange(1,5))
			{
				case 1:
					escalatorA.receivePass(personMaker.makePass());
				break;
				case 2:
					escalatorB.receivePass(personMaker.makePass());
				break;
				case 3:
					escalatorC.receivePass(personMaker.makePass());
				break;
				case 4:
					escalatorD.receivePass(personMaker.makePass());
				break;
				case 5:
					escalatorE.receivePass(personMaker.makePass());
				break;
			}
		}
		
		public function clearPasses():void
		{	
			escalatorA.clearPasses();
			escalatorB.clearPasses();
			escalatorC.clearPasses();
			escalatorD.clearPasses();
			escalatorE.clearPasses();
			preline.clearPasses();
			afloor.clearPasses();
			
			for each (var station:StationG in lines) {
				station.line.clearPasses();
			}
		}
		
		public function addTicketChecker():void {
			if (!ticketChecker) {
				ticketChecker = new TicketCheckerG();
				this.addChild(ticketChecker);
			}
		}
		
		public function addLine():void {
			if (lines.length >= 5) {
				return;
			}
			
			lines.push(new StationG(lines.length));
			Airport.addStation(lines.length);
			
			var sX:int = 788;
			var sY:int = 564;
			
			for (var i:int=0; i < lines.length; i++) {
				lines[i].x = sX;
				lines[i].y = sY;
				sX += 108;
				sY += 56;
				gLines[i*2].addChild(lines[i]);
				gLines[(i*2)+1].gotoAndStop(2);
				gLines[(i*2)+1].mouseChildren = false;
				gLines[(i*2)+1].mouseEnabled = false;
				lines[i].hideSpots();
			}
			
			
		}

	}
}