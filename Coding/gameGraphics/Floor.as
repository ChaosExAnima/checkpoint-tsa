﻿package gameGraphics
{
	import utilities.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import gameGraphics.PassengerG;
	import gameLogic.Airport;
	
	public class Floor extends PassContainer
	{
		private var width_:Number = 0; // the width of each cell in the array in pixels (currently 10)
		private var height_:Number = 0; // the height of each cell in the array in pixels (currently 10)
		private var floorW:Number = 0; // the total width of the array in pixels (currently 1800)
		private var floorH:Number = 0; // the total height of the array in pixels (currently 1350)
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

		private var target:PassContainer;
			
		
		
		public function Floor(gridXRes:Number, gridYRes:Number, x_:Number, y_:Number, w_:Number, h_:Number):void // constructor; gridXRes/gridYRes: the x and y dimensions of each cell in the array in pixels; w_/h_: the total width and height of the floor area
		{
			
			x = x_;
			y = y_;
			
			setGrid(gridXRes, gridYRes, w_, h_);
			
			addChild(drawnBits); // important: must be added to the flash graphical heirarchy, not good enough to just contain the variable
			addChild(gridDraw);
			this.addEventListener(Event.ENTER_FRAME, frameEntered);
		}
		
		// Creates grid
		public function setGrid(gridXRes:Number, gridYRes:Number, w_:Number, h_:Number)
		{
			floorW = w_;
			floorH = h_;
			
			width_ = gridXRes;
			height_ = gridYRes;
			
			// arrayW/arrayH MUST be integers.  Note: as code stands now this presents a problem 
			// if gridRes is not a multiple of the total pixels of it's associated dimension
			arrayW = Math.ceil(floorW/width_); // = 180
			arrayH = Math.ceil(floorH/height_); // = 135
			
			// Creates a 2D array filled with "0", 180x135
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
		
		// Resets ZBuffer Array
		private function createZBufferArray()
		{
			depth_array = new Array(arrayW*arrayH - 1); //Empty array 24120 entries long
		}
		
		
		private function frameEntered(e:Event)
		{
			createZBufferArray();
			
			// Checks all passengers in array if they are initialized
			for(var i:int = 0; i < passArray.length; i++) {
				if(passArray[i].initted()) {
					checkPass(i); // Does collision detection and moves person
				}
			}			
			
			var newPassArray:Array = new Array();
			
			
			var depth_count:int = 0;
			for(i = 0; i < depth_array.length; i++) // For all in the depth array...
			{
				if(depth_array[i]!=null) // ... and is a person ...
				{
					if(!passArray[depth_array[i]].obsolete) // ... and is not obsolete
					{
						this.setChildIndex(passArray[depth_array[i]],depth_count); //Sets person depth
						++depth_count;
						
						newPassArray.push(passArray[depth_array[i]]);
						
					}else { // ... and is obsolete
						var pass:PassengerG = passArray[depth_array[i]];
						if(pass.getLine().isNotFull()) {
							pickupBox(pass.getFootPrintX(),
									  pass.getFootPrintY(),
									  pass.getFootPrintW(),
									  pass.getFootPrintH()); // Removes collision block
							moveOn(pass); // Sends person to next target
						} else if(!pass.rerouting) {
							var rand:Point = AirportG.boundingBox.randPoint();
							pass.rerouting = true;
							pass.setTarg(rand.x, rand.y);
							trace("randtarg: "+rand.x+","+rand.y);
							pass.atTic = 0;
							newPassArray.push(pass);
							pass.setLine(pass.getLine());
						}else{
							pass.atTic++;
						}
					}			
				}
			}
			
			passArray = newPassArray;
//trace("passArray #1: " + this.name + " " + passArray);		
			
			if(!gridDrawn && drawGrid)
				gridDrawer();
			if(drawFull)
				fullDrawer();
		}
		
		// Moves passenger to line
		protected override function moveOn(pass:PassengerG):Boolean
		{
			if(!Airport.hasTicketChecker() || target == null)
			{
				//trace("we're being handed off");
				
				var passLine:LineG = pass.getLine();
				pass.x = (this.x-passLine.x) + pass.x;
				pass.y = (this.y-passLine.y) + pass.y;
				pass.getLine().receivePass(pass);
			}else{
				target.receivePass(pass);
			}
			//removeChild(pass);
			return true;
		}
		
		// Does collision detection
		private function checkPass(pass:Number):void
		{
			// X: -20 Y: -10 W: 40 H: 20
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
			// Does passenger routing
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
			// Skip if close enough to the current waypoint
			if(passArray[pass].closeEnough())
			{
				//trace("close enough");
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
				dropLowBox(nX, nY, nW, nH); // Put collision box on next position
			}else{
				passArray[pass].stopWalk();
				dropLowBox(x_, y_, w_, h_);	
				if(passArray[pass].atTic >= passArray[pass].waitTic && !passArray[pass].rerouting)
				{
					var rand:Point = AirportG.boundingBox.randPoint();
					passArray[pass].rerouting = true;
					passArray[pass].setTarg(rand.x, rand.y);
					Utilities.addMark(rand.x, rand.y);
					passArray[pass].atTic = 0;
				}else{
					passArray[pass].atTic++;
				}
			}
			depth_array[retLowResX(passArray[pass].x) + arrayW*retLowResY(passArray[pass].y)] = pass; // Sets the depth of the person
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
			// x_/(1800/24300)
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
		
		public override function receivePass(pass:PassengerG):Boolean
		{
			
			pass.startWalk();
			
			passArray.push(pass);
			this.addChild(pass);
			
			return true;
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
				
				if(passArray[i].parent)
					passArray[i].parent.removeChild(passArray[i]);
			}
			passArray = null;			
			passArray = new Array();
			setGrid(width_,height_,floorW,floorH);
		}
		
		public function get passengerArray():Array {
			return passArray;
		}
		
		public function setTarget(newTarg:PassContainer):void
		{
			target = newTarg;
		}
		
// ------------------------------DEBUGGING AND DISPLAY FUNCTIONS ---------------------//
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
		
		public function getTargetedLines():Array {
			var lineArray:Array = new Array();
			for (var i:int = 0; i < Airport.getNrStations(); i++) {
				lineArray.push(0);
			}
			//trace("Line array: "+lineArray);
			
			for each (var pass:PassengerG in passArray) {
				var line:int = pass.getLine().getNum();
				//trace("current line: "+line);
				lineArray[line-1]++;
			}
			//trace("lineArray post popcont: "+lineArray);
			return (lineArray);
		}
		
		/*public override function toString():String
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
		}*/
	}
}