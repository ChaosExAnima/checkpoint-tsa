package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import gameControl.*;
	import gameData.XMLgameData;
	import gameUI.Interface;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;

	
	public class AirportG extends Sprite
	{
		public var personMaker:GraphPassFact;
		
		public var escalatorA:Escalator = new Escalator();
		public var escalatorB:Escalator = new Escalator();
		public var escalatorC:Escalator = new Escalator();
		public var escalatorD:Escalator = new Escalator();
		public var escalatorE:Escalator = new Escalator();
		
		public var lines = new Array();
		private var gLines = new Array(new Sprite(), new GLine1(), 
									   new Sprite(), new GLine2(), 
									   new Sprite(), new GLine3(), 
									   new Sprite(), new GLine4(), 
									   new Sprite(), new GLine5());
		private var gExits = new Array(new GExit1(), new GExit2(), new GExit3(), new GExit4(), new GExit5());
		private var lineHolder = new Sprite();
		public static var ticketChecker:TicketCheckerG = null;
		
		public static const FLOOR_X = 105;
		public static const FLOOR_Y = 550;
		
		public var afloor:Floor = new Floor(10, 10, FLOOR_X, FLOOR_Y, 1000, 600); // The floor
		public var preline:Floor = new Floor(10, 10, FLOOR_X, FLOOR_Y, 1000, 600); // The preline
		
		public function AirportG():void
		{
			Globals.airport = this;
			preline.setTarget(null);
			afloor.setTarget(preline);
			afloor.setBounds(new Point(420-this.x,710-this.y),
									new Point(100-this.x,880-this.y),
									new Point(690-this.x,1180-this.y),
									new Point(1000-this.x,1010-this.y));
			
			
			personMaker = new GraphPassFact(this);
			
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
			
			this.addChild(lineHolder);
			
			for each (var exit:Sprite in gExits) {
				this.addChild(exit);
				exit.mouseEnabled = false;
				exit.mouseChildren = false;
			}
			
			this.addChild(preline);
			this.addChild(afloor);
			
			afloor.mouseEnabled = false;
			preline.mouseEnabled = false;
			
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
			afloor.receivePass(pass);
		}
			
		public function addPass():void
		{
			//trace(TheGame.getPeopleActive());
			if (TheGame.getPeopleActive() < TheGame.getMaxPeopleActive()) {
				TheGame.incrementPeopleActive();
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
			trace(ticketChecker);
			if (!ticketChecker) {
				trace("Ticket checker created");
				ticketChecker = new TicketCheckerG(this);
				this.addChild(ticketChecker);
				preline.updateTicketChecker();
			}
		}
		
		public function isTicketChecker():Boolean {
			if (ticketChecker) {
				return true;
			}
			return false;
		}
		
		public function addLine():void {
			if (lines.length >= 5) {
				return;
			}
			
			lines.push(new StationG(lines.length));
			
			var sX:int = 788;
			var sY:int = 564;
			
			for (var i:int=0; i < lines.length; i++) {
				lines[i].x = sX;
				lines[i].y = sY;
				
				sX += 108;
				sY += 56;
				lineHolder.addChild(lines[i]);
				lines[i].exitSprite(gExits[i]);
				//gLines[i*2].addChild(lines[i]);
				lineHolder.addChild(gLines[(i*2)+1]);
				gExits[i].gotoAndStop(2);
				
				gLines[(i*2)+1].mouseChildren = false;
				gLines[(i*2)+1].mouseEnabled = false;
				lines[i].hideSpots();
			}
			//this.addChild(afloor);
			//this.addChild(preline);
		}

	}
}