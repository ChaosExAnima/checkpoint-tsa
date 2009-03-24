package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
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
		
		public var afloor:Floor = new Floor(10, 10, 0, 0, 1800, 1350);
		
		public function AirportG():void
		{
			this.addChild(escalatorA);
			this.addChild(escalatorB);
			this.addChild(escalatorC);
			this.addChild(escalatorD);
			this.addChild(escalatorE);
			
			personMaker = new GraphPassFact(this);
			
			this.addChild(afloor);
			
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
		
		private function frameEntered(e:Event)
		{
			// escalatorA.getWaiting().forEach(moveToFloor);
			var waiting:Array = escalatorA.getWaiting();
			for(var i = 0; i < waiting.length; i++)
			{
				moveToFloor(waiting[i], escalatorA);
			}
			
			waiting = escalatorB.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToFloor(waiting[i], escalatorB);
			}
			
			waiting = escalatorC.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToFloor(waiting[i], escalatorC);
			}
			
			waiting = escalatorD.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToFloor(waiting[i], escalatorD);
			}
			
			waiting = escalatorE.getWaiting();
			for(i = 0; i < waiting.length; i++)
			{
				moveToFloor(waiting[i], escalatorE);
			}
		}
		
		public function moveToFloor(pass:PassengerG, escalator:Escalator):void
		{
			trace("movetofloor: "+PassengerG);
			
			pass.x = (escalator.x-afloor.x) + pass.x;
			pass.y = (escalator.y-afloor.y) + pass.y;
			afloor.receivePass(pass);

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
			afloor.clearPasses();
		}
		
		public function addLine():void {
			if (lines.length >= 5) {
				return;
			}
			
			lines.push(new StationG(lines.length));
			Airport.addStation(lines.length);
			
			var sX:int = 1220;
			var sY:int = 340;
			
			for each (var line:StationG in lines) {
				line.x = sX;
				line.y = sY;
				sX += 108;
				sY += 56;
				this.addChild(line);
				line.hideSpots();
			}
			
			
		}

	}
}