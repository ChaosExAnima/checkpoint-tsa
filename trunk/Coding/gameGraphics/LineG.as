package gameGraphics
{
	import utilities.*;
	import flash.display.*;
	import flash.events.*;
	import gameGraphics.PassengerG;
	import gameGraphics.StationG;
	import gameLogic.Line;
	
	public class LineG extends Sprite
	{
		private var speed:Number = 5;
		private var xTrav:Number = 102;
		private var yTrav:Number = 56;
		
		private var spaceW:Number = 0;
		private var spaceH:Number = 0;
		
		private var passArray:Array = new Array();
		private var movingOn:Array = new Array();
		
		private var numInLine:Number = 0;
		private var maxInLine:Number = 5;
		
		private var displayed:Sprite = new Sprite();
		
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var myNum:uint;
		
		public var station:StationG;
		
		public var logic:Line;
		
		public function LineG(mystation:StationG):void
		{
			station = mystation;
			myNum = station.whichStationNum();
			logic = station.getLogic().getLine();
			
			spaceW = xTrav/passArray.length;
			spaceH = yTrav/passArray.length;
			
			xSpeed = speed*(xTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			ySpeed = speed*(yTrav)/Math.sqrt(Math.pow(xTrav,2) + Math.pow(yTrav,2));
			
			for(var i:int = 0; i<maxInLine; i++)
				passArray.push(null);
			
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
		
		private function frameEntered(e:Event)
		{
			for(var i:int = 0; i < passArray.length; i++)
				if(passArray[i] == null)
				{
					if(i != 0)
					{
						passArray[i] = passArray[i - 1];
						passArray[i - 1] = null;
						if(passArray[i] != null)
							passArray[i].addTarg(Utilities.randRange(spaceW * i, spaceW * (i + 1)), Utilities.randRange(spaceW * i, spaceW * (i + 1)));
					}
				}else{
					passArray[i].tStep();
				}
		}
		
		public function receivePass(pass:PassengerG):Boolean // returns false if there is no space in line
		{
			if(passArray[0] == null)
			{
				passArray[0] = this.addChild(pass);
				numInLine++;
				return true;
			}else{
				return false;
			}
		}
		
		private function moveOn(index:uint)
		{
			movingOn.push(losePass(index));
		}
		
		public function losePass(index:uint):PassengerG
		{
			var retPass = passArray[index];
			passArray[index] = null;
			return retPass;
		}
		
		public function clearPasses():void
		{	
			for(var i:int = 0; i < passArray.length; i++)
			{
				passArray[i].killMe();
				passArray[i] == null;
			}
		}
		
		public function getNum():uint
		{
			return myNum;
		}
	}
}