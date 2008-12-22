﻿package gameGraphics{	import utilities.*;	import gameLogic.*;	import flash.display.*;	import flash.events.*;		public class AirportG extends Sprite	{		public var personMaker:GraphPassFact;				public var escalatorA:Escalator = new Escalator();		public var escalatorB:Escalator = new Escalator();		public var escalatorC:Escalator = new Escalator();		public var escalatorD:Escalator = new Escalator();		public var escalatorE:Escalator = new Escalator();				//public var lineA:LineG = new LineG(1);		//public var lineB:LineG = new LineG(2);		//public var lineC:LineG = new LineG(3);		//public var lineD:LineG = new LineG(4);		//public var lineE:LineG = new LineG(5);				public var lines = new Array(new LineG(1), new LineG(2), new LineG(3), new LineG(4), new LineG(5))				public var afloor:Floor = new Floor(10, 10, 0, 0, 1800, 1350);												public function AirportG():void		{			this.addChild(escalatorA);			this.addChild(escalatorB);			this.addChild(escalatorC);			this.addChild(escalatorD);			this.addChild(escalatorE);						new Airport();						personMaker = new GraphPassFact(this);									//this.addChild(lineA);			//this.addChild(lineB);			//this.addChild(lineC);			//this.addChild(lineD);			//this.addChild(lineE);						for(var i:uint = 0; i < lines.length; i++)				this.addChild(lines[i]);						this.addChild(afloor);						escalatorA.x = 20;			escalatorA.y = 1080;						escalatorB.x = 120;			escalatorB.y = 1130;						escalatorC.x = 220;			escalatorC.y = 1180;						escalatorD.x = 320;			escalatorD.y = 1230;						escalatorE.x = 420;			escalatorE.y = 1280;						var offset:uint = 55;			//			lineA.x = 1165;//			lineA.y = 322 + offset;	//			lineB.x = 1266;//			lineB.y = 375 + offset;			//			lineC.x = 1381;//			lineC.y = 433 + offset;			//			lineD.x = 1490;//			lineD.y = 486 + offset;			//			lineE.x = 1605;//			lineE.y = 540 + offset;			lines[0].x = 1165;			lines[0].y = 322 + offset;				lines[1].x = 1266;			lines[1].y = 375 + offset;						lines[2].x = 1381;			lines[2].y = 433 + offset;						lines[3].x = 1490;			lines[3].y = 486 + offset;						lines[4].x = 1605;			lines[4].y = 540 + offset;						this.addEventListener(Event.ENTER_FRAME, frameEntered);		}				private function frameEntered(e:Event)		{			// escalatorA.getWaiting().forEach(moveToFloor);			var waiting:Array = escalatorA.getWaiting();			for(var i = 0; i < waiting.length; i++)			{				moveToFloor(waiting[i], escalatorA);			}						waiting = escalatorB.getWaiting();			for(i = 0; i < waiting.length; i++)			{				moveToFloor(waiting[i], escalatorB);			}						waiting = escalatorC.getWaiting();			for(i = 0; i < waiting.length; i++)			{				moveToFloor(waiting[i], escalatorC);			}						waiting = escalatorD.getWaiting();			for(i = 0; i < waiting.length; i++)			{				moveToFloor(waiting[i], escalatorD);			}						waiting = escalatorE.getWaiting();			for(i = 0; i < waiting.length; i++)			{				moveToFloor(waiting[i], escalatorE);			}		}				public function moveToFloor(pass:PassengerG, escalator:Escalator):void		{			trace("movetofloor: "+PassengerG);						pass.x = (escalator.x-afloor.x) + pass.x;			pass.y = (escalator.y-afloor.y) + pass.y;			afloor.receivePass(pass);		}				public function addPass():void		{						switch(Utilities.randRange(1,5))			{				case 1:					escalatorA.receivePass(personMaker.makePass());				break;				case 2:					escalatorB.receivePass(personMaker.makePass());				break;				case 3:					escalatorC.receivePass(personMaker.makePass());				break;				case 4:					escalatorD.receivePass(personMaker.makePass());				break;				case 5:					escalatorE.receivePass(personMaker.makePass());				break;			}		}						public function clearPasses():void		{				escalatorA.clearPasses();			escalatorB.clearPasses();			escalatorC.clearPasses();			escalatorD.clearPasses();			escalatorE.clearPasses();			afloor.clearPasses();		}	}}