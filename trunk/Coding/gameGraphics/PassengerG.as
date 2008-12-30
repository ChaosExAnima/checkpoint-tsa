package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.events.*;
	import gameGraphics.Torso;
	import gameGraphics.Legs;
	
	public class PassengerG extends Sprite
	{
		private var xTarg:Array = new Array();
		private var yTarg:Array = new Array();
		
		private var originX:Number = 0;
		private var originY:Number = 0;
		
		private var targSpeed:Number = 0;
		
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var footPrintW:Number = 40;
		private var footPrintH:Number = 20;
		private var footPrintX:Number = -20;
		private var footPrintY:Number = -10;
		
		private var spriteOffsetX:Number = 0;
		private var spriteOffsetY:Number = -40;
		private var spriteScale:Number = 1;
		
		public var atTic:Number = 0;
		public var waitTic:Number = 0;
		public var reroutTic:Number = 0;
		public var rerouting:Boolean = false;
		public var gimmeDist:Number = 30;
		
		public var obsolete:Boolean = false;
		
		private var inittedB:Boolean = false;
		private var movingMC:MovieClip;
		
		private var myLine:LineG;
		private var myColor:Array;
		private var myTorso:MovieClip;
		private var torsoRef:Torso = new Torso();
		
		private var corpWalk:PWalk = new PWalk();
		private var corpStand:PStand = new PStand();
		
		private var _legs:MovieClip;
		
		private var logicPass:Passenger = null;
		
		public function PassengerG(x_:Number, y_:Number, logic:Passenger, line:LineG, torso:MovieClip, colors:Array):void
		{
			
			corpWalk.x = spriteOffsetX;
			corpWalk.y = spriteOffsetY;
			corpWalk.width = corpWalk.width*spriteScale;
			corpWalk.height = corpWalk.height*spriteScale;
			
			corpStand.x = spriteOffsetX;
			corpStand.y = spriteOffsetY;
			corpStand.width = corpStand.width*spriteScale;
			corpStand.height = corpStand.height*spriteScale;
			
			
			myTorso = torso;
			myColor = colors;			
			x = x_;
			y = y_;
			
			targSpeed = Utilities.randRange(3,7);
			waitTic = Utilities.randRange(15,25);
			reroutTic = Utilities.randRange(15,30);
			
			_legs = new Legs(targSpeed);
			_legs.Stand();
			
//			movingMC = corpWalk;
			
			logicPass = logic;
			
			
			setLine(line);
			
			this.addChild(_legs);
			this.addChild(myTorso);
			//this.addChild(movingMC);
			//movingMC.addChild(myTorso);			
			
			inittedB = true;
		}
		
		public function initted():Boolean
		{
			return inittedB;
		}
		
		private function frameEntered(e:Event):void
		{
			//drawMe();
		}
/*		
		public function jumpTo():void
		{
			x = xTarg[0];
			y = yTarg[0];
			atTarg();
		}
*/		
		private function recalSpeeds():void
		{
			xSpeed = targSpeed*(xTarg[0] - x)/Math.sqrt(Math.pow(xTarg[0] - x,2) + Math.pow(yTarg[0] - y,2));
			ySpeed = targSpeed*(yTarg[0] - y)/Math.sqrt(Math.pow(xTarg[0] - x,2) + Math.pow(yTarg[0] - y,2));
		}
		
		public function tStep():void
		{
			if(SUtilities.switchedSide(yTarg[0], originY, y + ySpeed) && SUtilities.switchedSide(xTarg[0], originX, x + xSpeed))
			{
				 atTarg();
			}else{
				if(xTarg.length >= 1)
				{
					x += xSpeed;
					y += ySpeed;
				}
			}
		}
		
		private function setOrigin():void
		{
			originX = x;
			originY = y;
		}
		
		private function atTarg():void
		{
			trace("at targ");
			xTarg.shift();
			yTarg.shift();
			setOrigin();
			if(xTarg.length < 1)
			{
				trace("ran out of targets");
				killMe();
			}else{
				recalSpeeds();
				updateHeading();
			}
			//randTarg();
		}
		
		public function randTarg():void
		{
			setTarg(Utilities.randRange(0,1800), Utilities.randRange(0,1350));
		}
		
		public function setTarg(x_:Number, y_:Number):void
		{
			xTarg.unshift(x_);
			yTarg.unshift(y_);
			setOrigin();
			recalSpeeds();
			updateHeading();
		}
		
		public function skipTarg():void
		{
			xTarg.shift();
			yTarg.shift();
			
			atTarg();
		}
		
		public function addTarg(x_:Number, y_:Number):void
		{
			xTarg.push(x_);
			yTarg.push(y_);
		}
		
		private function updateHeading():void
		{
			var theta:Number = Math.atan(Math.abs(xSpeed/ySpeed))*180/Math.PI;
			
			if(xSpeed >= 0 && ySpeed <= 0)
				theta = 90 - theta;
			else if(xSpeed <= 0 && ySpeed <= 0)
				theta = theta + 90;
			else if(xSpeed <= 0 && ySpeed >= 0)
				theta = 270 - theta;
			else if(xSpeed >= 0 && ySpeed >= 0)
				theta = theta + 270;
			
			theta += 22.5 + 90;
			
			theta = ((theta/360) - Math.floor(theta/360))*360;
			theta = Math.ceil(theta/45);
			if (theta != myTorso.currentFrame) {
				trace("Theta is "+theta+", currentFrame is "+myTorso.currentFrame);
	 			myTorso.gotoAndStop(theta);
			 	myTorso.addFrameScript(myTorso.currentFrame-1, setClip);
			}
			//trace(_legs._curLegs.cLegs);
			if (theta != _legs._curLegs.cLegs.currentFrame) {
				_legs._curLegs.cLegs.gotoAndStop(theta);
				_legs._curLegs.cFloor.gotoAndStop(theta);
			}
		}
		
		private function setClip():void {
			myTorso.addFrameScript(myTorso.currentFrame-1, null);
			torsoRef.setColor(myTorso, myColor);
		}
		
		public function startWalk():void
		{
			if (true) {
//				this.removeChild(movingMC);
//				movingMC = corpWalk;
//				this.addChild(movingMC);
//				movingMC.addChild(myTorso);
				_legs.Walk();
			}

			updateHeading();
			recalSpeeds();
		}
		
		public function stopWalk():void
		{
			if (true) {
				/*this.removeChild(movingMC);
				movingMC = corpStand;
				this.addChild(movingMC);
				movingMC.addChild(myTorso);*/
				_legs.Stand();
			}
			
			updateHeading();
		}
		
		public function closeEnough():Boolean
		{
			return distToTarg() <= gimmeDist;
		}
		
		public function distToTarg():Number
		{
			return Math.sqrt(Math.pow(xTarg[0] - x,2) + Math.pow(yTarg[0] - y,2));
		}
		
		public function getFootPrintX():Number
		{
			return footPrintX + x;
		}
		
		public function getFootPrintY():Number
		{
			return footPrintY + y;
		}
		
		public function getFootPrintW():Number
		{
			return footPrintW;
		}
		
		public function getFootPrintH():Number
		{
			return footPrintH;
		}
		
		public function getSpeedX():Number
		{
			return xSpeed;
		}
		
		public function getSpeedY():Number
		{
			return ySpeed;
		}
		
		public function getLine():LineG
		{
			return myLine;
		}
		
		public function setLine(newLine:LineG)
		{
			myLine = newLine;
			xTarg = new Array();
			yTarg = new Array();
			if(Airport.hasTicketChecker())
			{
				setTarg(1400,660);
				trace("found a checker");
			}else{
				setTarg(myLine.x,myLine.y);
			}
		}
		
		public function killMe():void
		{			
			trace("killing myself");		
			this.removeEventListener(Event.ENTER_FRAME, frameEntered);
			_legs.cleanUp();
//			corporealForm.graphics.clear();
			obsolete = true;
			
		}
	}
}