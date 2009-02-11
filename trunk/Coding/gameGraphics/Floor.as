﻿package gameGraphics
{
	import utilities.*;
	import flash.display.*;
	import flash.events.*;
	import gameGraphics.PassengerG;
	
	public class Floor extends Sprite
	{
		private var width_:Number = 0; // the width of each cell in the array in pixels
		private var height_:Number = 0; // the height of each cell in the array in pixels
		private var floorW:Number = 0; // the total width of the array in pixels
		private var floorH:Number = 0; // the total height of the array in pixels
		private var arrayW:Number = 0; // the width of the array in cells
		private var arrayH:Number = 0; // the height of the array in cells
		
		private var zBufferStart:int = 000;
		
		private var floor_array:Array = new Array(); // the hit detection array
		public var depth_array:Array = new Array(); // depth buffer array, precalculated Z indexes
		
		private var drawGrid:Boolean = false; // true: draws visual representation of array cells
		private var drawFull:Boolean = false; // true: draws visual representation of filled cells
		
		private var drawnBits:Sprite = new Sprite(); // sprite for drawing filled cells
		private var gridDraw:Sprite = new Sprite(); // sprite for drawing grid, separate so the grid doesn't have to be redrawn every frame
		
		private var gridDrawn:Boolean = false; // boolean variable to track if the grid has been drawn since last update
		
		private var passArray:Array = new Array(); // one dimensional array holds all passengers
		
		
		public function Floor(gridXRes:Number, gridYRes:Number, x_:Number, y_:Number, w_:Number, h_:Number):void // constructor; gridXRes/gridYRes: the x and y dimensions of each cell in the array in pixels; w_/h_: the total width and height of the floor area
		{
			
			x = x_;
			y = y_;
			
			setGrid(gridXRes, gridYRes, w_, h_);
			
			//dropBox(1430.4,534.0,180,180);
			//dropBox(1090.4,319.0,230,135.0);
			
//			dropBox(100,100,1600,20);
//			dropBox(100,100,20,1150);
			
//			dropBox(100,1250,1600,20);
//			dropBox(1700,100,20,1150);
			
			addChild(drawnBits); // important: must be added to the flash graphical heirarchy, not good enough to just contain the variable
			addChild(gridDraw);
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
		
		public function setGrid(gridXRes:Number, gridYRes:Number, w_:Number, h_:Number) // concerned with everything that changes when the grids resolution changes
		{
			floorW = w_;
			floorH = h_;
			
			width_ = gridXRes;
			height_ = gridYRes;
			
			arrayW = Math.ceil(floorW/width_); // arrayW/arrayH MUST be integers.  Note: as code stands now this presents a problem if gridRes is not a multiple of the total pixels of it's associated dimension
			arrayH = Math.ceil(floorH/height_);
			
			floor_array = new Array();
			for(var i:int = 0; i<arrayW; i++)
			{
				var tempArray:Array = new Array();
				for(var u:int = 0; u<arrayH; u++){tempArray.push("0");}
				floor_array.push(tempArray);
			}
			
			gridDrawn = false;
			
			createZBufferArray();
		}
		
		private function createZBufferArray()
		{
			depth_array = new Array(arrayW*arrayH - 1);
		}
		
		public function gridOn():void
		{
			drawGrid = true;
			gridDrawn = false;
		}
		
		public function gridOff():void
		{
			drawGrid = false;
			gridDraw.graphics.clear();
		}
		
		public function gridStat():Boolean
		{
			return drawGrid;
		}
		
		public function blockOn():void
		{
			drawFull = true;
		}
		
		public function blockOff():void
		{
			drawFull = false;
			drawnBits.graphics.clear();
		}
		
		public function blockStat():Boolean
		{
			return drawFull;
		}
		
		private function frameEntered(e:Event)
		{
			createZBufferArray();
			for(var i:int = 0; i < passArray.length; i++)
				if(passArray[i].initted())
					checkPass(i);
				
			
			var newPassArray:Array = new Array();
			
			
			var depth_count:int = 0;
			for(i = 0; i < depth_array.length; i++)
			{
				if(depth_array[i]!=null)
				{
					if(!passArray[depth_array[i]].obsolete)
					{
						this.setChildIndex(passArray[depth_array[i]],depth_count);
						++depth_count;
						
						passArray[depth_array[i]];		  			
						newPassArray.push(passArray[depth_array[i]]);
						
					}else{
						pickupBox(passArray[depth_array[i]].getFootPrintX(),passArray[depth_array[i]].getFootPrintY(),passArray[depth_array[i]].getFootPrintW(),passArray[depth_array[i]].getFootPrintH())
						removeChild(passArray[depth_array[i]]);
						
					}			
				}
			}
			
			passArray = newPassArray;
			
			if(!gridDrawn && drawGrid)
				gridDrawer();
			if(drawFull)
				fullDrawer();
		}
		
		private function gridDrawer():void
		{
			gridDraw.graphics.clear();
			gridDraw.graphics.lineStyle(1,0x000000);
			gridDraw.graphics.beginFill(0x0000FF,0);
			for(var i_:Number = 0; i_<=floorW; i_+=width_)
			{
				gridDraw.graphics.moveTo(i_,0);
				gridDraw.graphics.lineTo(i_,floorH)
			}
			for(i_ = 0; i_<=floorH; i_+=height_)
			{
				gridDraw.graphics.moveTo(0,i_);
				gridDraw.graphics.lineTo(floorW,i_)
			}
			gridDraw.graphics.endFill();
			gridDrawn = true;
		}
		
		private function fullDrawer():void
		{
			drawnBits.graphics.clear();
			drawnBits.graphics.lineStyle(0,0x0000FF);
			drawnBits.graphics.beginFill(0x0000FF);
			var i_:int = 1;
			
			for(var y_:int = 0; y_<arrayH; y_++)
			{
				for(var x_:int = 0; x_<arrayW; x_+=i_)
				{
					for(i_ = 1; floor_array[SUtilities.inBounds(x_ + i_ - 1,arrayW - 1)][SUtilities.inBounds(y_,arrayH - 1)] == 1 && x_ + i_ -1 < arrayW; i_++){}
					if(i_ != 1)
						drawnBits.graphics.drawRect(retHighResX(x_), retHighResY(y_), (i_ - 1)*width_, height_);
				}
			}
			drawnBits.graphics.endFill();
		}
		
		
		public override function toString():String
		{
			var outString:String = new String();
	
			for(var y_:int = 0; y_<arrayH; y_++)
			{
				for(var x_:int = 0; x_<arrayW; x_++)
				{
					outString = outString+floor_array[x_][y_]+" ";
				}
				outString = outString+"\n";
			}
	
			return outString;
		}
		
		private function checkPass(pass:Number):void
		{
			var w_:int = lowResWidth(passArray[pass].getFootPrintX(), passArray[pass].getFootPrintW());
			var h_:int = lowResHeight(passArray[pass].getFootPrintY(), passArray[pass].getFootPrintH());
			var x_:int = retLowResX(passArray[pass].getFootPrintX());
			var y_:int = retLowResY(passArray[pass].getFootPrintY());

			var nW:int = lowResWidth((passArray[pass].getFootPrintX() + passArray[pass].getSpeedX()), passArray[pass].getFootPrintW());
			var nH:int = lowResHeight((passArray[pass].getFootPrintY() + passArray[pass].getSpeedY()), passArray[pass].getFootPrintH());
			var nX:int = retLowResX(passArray[pass].getFootPrintX() + passArray[pass].getSpeedX());
			var nY:int = retLowResY(passArray[pass].getFootPrintY() + passArray[pass].getSpeedY());
			
			pickupLowBox(x_, y_, w_, h_);
			var foundOverlap:Boolean = false;
			for(var iy:int = nY; (! foundOverlap) && iy < nH + nY; iy++)
			{
				for(var ix:int = nX; (! foundOverlap) && ix < nW + nX; ix++)
				{
					if(floor_array[SUtilities.inBounds(ix,arrayW - 1)][SUtilities.inBounds(iy,arrayH - 1)] == 1)
						foundOverlap = true;
				}
			}
			
			if(passArray[pass].rerouting)
			{
				if(passArray[pass].atTic >= passArray[pass].reroutTic)
				{
					passArray[pass].rerouting = false;
					passArray[pass].skipTarg();
					passArray[pass].atTic = 0;
				}else{
					passArray[pass].atTic++;
				}
			}
			
			if(passArray[pass].closeEnough())
			{
				trace("close enough");
				passArray[pass].skipTarg();
			}
			
			if(! foundOverlap)
			{
				passArray[pass].startWalk();
				passArray[pass].tStep();
				
	
				 nW = lowResWidth(passArray[pass].getFootPrintX() , passArray[pass].getFootPrintW());
				 nH = lowResHeight(passArray[pass].getFootPrintY(), passArray[pass].getFootPrintH());
				 nX = retLowResX(passArray[pass].getFootPrintX());
				 nY = retLowResY(passArray[pass].getFootPrintY());
				dropLowBox(nX, nY, nW, nH);
			}else{
				passArray[pass].stopWalk();
				dropLowBox(x_, y_, w_, h_);	
				if(passArray[pass].atTic >= passArray[pass].waitTic && !passArray[pass].rerouting)
				{
					passArray[pass].rerouting = true;
					passArray[pass].randTarg();
					passArray[pass].atTic = 0;
				}else{
					passArray[pass].atTic++;
				}
			}
			depth_array[retLowResX(passArray[pass].x) + arrayW*retLowResY(passArray[pass].y)] = pass;
		}
		
		public function pickupBox(x_:Number, y_:Number, w_:Number, h_:Number):void
		{
			for(var i_:Number = SUtilities.inBounds(retLowResX(x_),floor_array.length); i_<SUtilities.inBounds(retLowResX(x_+w_),floor_array.length); i_++)
			{
				for(var u_:Number = SUtilities.inBounds(retLowResY(y_),floor_array[0].length); u_<SUtilities.inBounds(retLowResY(y_+h_),floor_array[0].length); u_++)
				{
					floor_array[i_][u_] = "0";
				}
			}
		}
		
		public function pickupLowBox(x_:Number, y_:Number, w_:Number, h_:Number):void
		{
			for(var i_:Number = SUtilities.inBounds(x_,floor_array.length); i_<SUtilities.inBounds(x_+w_,floor_array.length); i_++)
			{
				for(var u_:Number = SUtilities.inBounds(y_,floor_array[x_].length); u_<SUtilities.inBounds(y_+h_,floor_array[x_].length); u_++)
				{				
					floor_array[i_][u_] = "0";
				}
			}
		}
		
		public function dropBox(x_:Number, y_:Number, w_:Number, h_:Number):void
		{
			for(var i_:Number = SUtilities.inBounds(retLowResX(x_),floor_array.length); i_<SUtilities.inBounds(retLowResX(x_+w_),floor_array.length); i_++)
			{
				for(var u_:Number = SUtilities.inBounds(retLowResY(y_),floor_array[0].length); u_<SUtilities.inBounds(retLowResY(y_+h_),floor_array[0].length); u_++)
				{
					floor_array[i_][u_] = "1";
				}
			}
		}
	
		private function dropLowBox(x_:Number, y_:Number, w_:Number, h_:Number):void
		{
			for(var i_:Number = SUtilities.inBounds(x_,floor_array.length); i_<SUtilities.inBounds(x_+w_,floor_array.length); i_++)
				for(var u_:Number = SUtilities.inBounds(y_,floor_array[0].length); u_<SUtilities.inBounds(y_+h_,floor_array[0].length); u_++)
					floor_array[i_][u_] = "1";
		}
		
		public function retLowResX(x_:Number):int
		{
			return Math.round(x_/(floorW/floor_array.length));
		}
		
		public function retLowResY(y_:Number):int
		{
			return Math.round(y_/(floorH/floor_array[0].length));
		}
		
		public function lowResWidth(x_:Number, w_:Number):int
		{
			return retLowResX(w_ + x_) - retLowResX(x_);
		}
		
		public function lowResHeight(y_:Number, h_:Number):int
		{
			return retLowResY(h_ + y_) - retLowResY(y_);
		}
		
		public function retHighResX(x_:Number):Number
		{
			var resxRatio:Number = floorW/floor_array.length;
			
			return Math.round(x_*resxRatio);
		}
		
		public function retHighResY(y_:Number):Number
		{
			var resyRatio:Number = floorH/floor_array[0].length;
			
			return Math.round(y_*resyRatio);
		}
		
		public function receivePass(pass:PassengerG):void
		{
			
			pass.startWalk();
			
			passArray.push(pass);
			this.addChild(pass);
	/*		
			var tS:String = "";
			for(var i = 0; i < this.numChildren; i++)
				tS += this.getChildAt(i)+", ";
			trace("RPTS"+tS);
	*/
		}
		
		public function headCount():Number
		{
			return passArray.length;
		}
		
		public function clearPasses():void
		{	
			trace("clearing");
			for(var i:int = 0; i < passArray.length; i++)
			{
				passArray[i].killMe();
				this.removeChild(passArray[i]);
			}
			passArray = null;
			passArray = new Array();
			setGrid(width_,height_,floorW,floorH);
		}
	}
}