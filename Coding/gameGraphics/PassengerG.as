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
		
		private var _colors:Array;
		private var _torso:MovieClip;
		
//		private var corpWalk:PWalk = new PWalk();
//		private var corpStand:PStand = new PStand();
		
		private var _legs:MovieClip;
		private var _legsShdw:MovieClip;
		private var _legRef:Legs = new Legs();
		private var _legColors:Array;
		public var _name:String;
		
		private var logicPass:Passenger = null;
		
		public function PassengerG(x_:Number, y_:Number, logic:Passenger, line:LineG, torso:MovieClip, colors:Array, name:String):void
		{
			
			/*corpWalk.x = spriteOffsetX;
			corpWalk.y = spriteOffsetY;
			corpWalk.width = corpWalk.width*spriteScale;
			corpWalk.height = corpWalk.height*spriteScale;
			
			corpStand.x = spriteOffsetX;
			corpStand.y = spriteOffsetY;
			corpStand.width = corpStand.width*spriteScale;
			corpStand.height = corpStand.height*spriteScale;*/
			
			
			_torso = torso;
			_colors = colors;
			_legs = _legRef.getStand();
			_legColors = _legRef.setColor(_legs)
			_name = name;
			
			x = x_;
			y = y_;
			
			targSpeed = Utilities.randRange(3,7);
			waitTic = Utilities.randRange(15,25);
			reroutTic = Utilities.randRange(15,30);
	
//			movingMC = corpWalk;
			
			logicPass = logic;
			
			
			setLine(line);
			
			this.addChild(_legs);
			this.addChild(_torso);
			//this.addChild(movingMC);
			//movingMC.addChild(_torso);			
			
			inittedB = true;
			
			this.addEventListener(MouseEvent.CLICK, showName);
		}
		
		private function showName(e:MouseEvent):void {
			trace(_name);
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
//			trace(xSpeed+", "+ySpeed);
//			trace(targSpeed);
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
			if (theta != _torso.currentFrame) {
	 			_torso.gotoAndStop(theta);
			 	_torso.addFrameScript(_torso.currentFrame-1, setClip);
			}
			if (theta != _legs.currentFrame) {
				_legs.gotoAndStop(theta);
				_legs.addFrameScript(_legs.currentFrame-1, setLegs);
			}
		}
		
		private function setClip():void {
			_torso.addFrameScript(_torso.currentFrame-1, null);
			new Torso().setColor(_torso, _colors);
		}
		
		private function setLegs():void {
			_legs.addFrameScript(_legs.currentFrame-1, null);
			_legRef.setColor(_legs, _legColors);
			_legRef.scaleAnim(_legs, targSpeed);
//			_legRef.scaleAnim(_legsShdw, targSpeed);
		}
			
		
		public function startWalk():void
		{
			if (_legs is stand1) {
				this.removeChild(_legs);
//				this.removeChild(_legsShdw);
				_legs = _legRef.getWalk();
//				_legsShdw = _legRef.getWalkShdw();
				_legs.addFrameScript(_legs.currentFrame-1, setLegs);
//				_legsShdw.addFrameScript(_legs.currentFrame-1, 
				this.addChildAt(_legs, 0);
//				this.addChildAt(_legsShdw, 0);
			}

			updateHeading();
			recalSpeeds();
		}
		
		public function stopWalk():void
		{
			if (_legs is walk1) {
				this.removeChild(_legs);
				_legs = _legRef.getStand();
				_legs.addFrameScript(_legs.currentFrame-1, setLegs);
				this.addChildAt(_legs, 0);
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
//			corporealForm.graphics.clear();
			obsolete = true;
			
		}
	}
}