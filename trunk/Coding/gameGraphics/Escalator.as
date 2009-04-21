package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.events.*;

	public class Escalator extends Sprite
	{
		private var speed:Number = 3;
		private var xTrav:Number = 160;
		private var yTrav:Number = 180;
		
		private var passArray:Array = new Array();
		private var movingOn:Array = new Array();
		private var waiting:Array = new Array();
		
		private var sinceLast:uint = 0;
		private var longEnough:uint = 10;
		
		//private var displayed:Sprite = new Sprite();
		
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var _startX:int = 0;
		private var _startY:int = -36;
		
		
		public function Escalator():void
		{
			sinceLast = longEnough;
			
			//displayed.graphics.lineStyle(5, 0xFF0000, 1, false, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.MITER, 3);
			//displayed.graphics.moveTo(0, 0);
			//displayed.graphics.lineTo(xTrav, -yTrav);
			
			//this.addChild(displayed);
			
			xSpeed = speed*(xTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			ySpeed = speed*(yTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
		
		private function frameEntered(e:Event)
		{
			sinceLast++;
			
			if(sinceLast >= longEnough && waiting[0] != null)
			{
				sinceLast = 0;
				passArray.push(this.addChild(waiting.pop()));
			}
			
			for(var i:int = 0; i < passArray.length; i++)
				if(passArray[i].initted())
				{
					passArray[i].x += xSpeed;
					passArray[i].y -= ySpeed;
					
					if(passArray[i].y <=  -yTrav)
					{
						moveOn(i);
					}
				}
		}
		
		public function receivePass(pass:PassengerG):void
		{
			//passArray.push(this.addChild(pass));
			pass.stopWalk();
			pass.x += _startX;
			pass.y += _startY;
			waiting.push(pass);
		}
		
		private function moveOn(index:uint)
		{
			movingOn.push(losePass(index));
		}
		
		public function losePass(index:uint):PassengerG
		{
			var retPass = this.removeChild(passArray.splice(index,1)[0]);
			return retPass;
		}
		
		public function getWaiting():Array
		{
			var retArray:Array = movingOn;
			movingOn = new Array();
			return retArray;
		}
		
		public function clearPasses():void
		{	
			for(var i:int = 0; i < passArray.length; i++)
			{
				passArray[i].killMe();
				this.removeChild(passArray[i]);
			}
			passArray = null;
			passArray = new Array();
		}
	}
}