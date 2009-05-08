package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.geom.Point;
	
	public class Bounds extends Sprite
	{
		private var boundImage:Sprite = new collisionBox();
		
		
		// ------- Constructor -------
		/*
	  		takes four points to define bounds.  Points must be organized in a
			clockwise fassion starting with the highest and middle point (this
			class does not account for concave shapes, or shapes in which any
			3 points are colinear):
		
						 p1
						 •
				p4 •			
								• p2
			
						  •
						  p3
		*/
		public function Bounds():void
		{
			boundImage.mouseChildren = false;
			boundImage.mouseEnabled = false;
			this.addChild(boundImage);
		}
		
		
		// ------- setPoint -------
		/*
	  		sets point whichPoint to nx, ny. Will return false if point is invalid
			given current other points; returns true in all cases, for now.
		*/
		/*public function setPoint(whichPoint:int, nx:Number, ny:Number):Boolean
		{
			_xs[whichPoint - 1] = nx;
			_ys[whichPoint - 1] = ny;
			
			p1gp3 = (_xs[0] < _xs[2]);  // determines which point (top or bottom) is further to the right
			p4gp2 = (_ys[3] < _ys[1]);  // determines which point (left or right) is further down (on screen)
			
			
			return true;
		}*/
		
		
		// ------- getPoint -------
		/*
	  		returns an Array of length 2, space 1 is x, space 2 is y.
		*/
		/*public function getPoint(whichPoint:int):Array
		{
			return new Array(_xs[whichPoint - 1], _ys[whichPoint - 1]); // remember, arrays are 0 indexed!
		}*/
		
		
		// ------- pointIn -------
		/*
	  		determines if point px, py is in bounds.
		*/
		public function pointIn(px:Number, py:Number):Boolean
		{
			boundImage.mouseChildren = false;
			boundImage.mouseEnabled = false;
			boundImage.visible = false;
			var inside:Boolean = boundImage.hitTestPoint(px, py, true);
			//trace("Inside? "+inside);
			return inside;
		}
		
		
		// ------- randPoint -------
		/*
	  		returns a random point in bounds relative to parent.  May favor points grouped at
			top and bottom; equal in number to those in other longer rows
		*/
		public function randPoint():Point
		{
			var rand:Point = new Point(Utilities.randRange(0,1800), Utilities.randRange(0,1350));
			while (pointIn(rand.x, rand.y) == false) {
				rand = new Point(Utilities.randRange(0,1800), Utilities.randRange(0,1350));
			}
			
			return rand;
		}
		
		
		// ------- toggleDraw -------
		/*
	  		toggles drawing on/off, returns new state.
		*/
		/*public function toggleDraw():Boolean
		{
			drawBounds = !drawBounds;
			
			if(drawBounds)
			{
				boundImage.graphics.beginFill(0, 0);
				//boundImage.graphics.lineStyle(1);
				boundImage.graphics.moveTo(_xs[0],_ys[0]);
				
				for(var i:int = 1; i < _xs.length; i++)
				{
					boundImage.graphics.lineTo(_xs[i],_ys[i]);
				}
				boundImage.graphics.lineTo(_xs[0],_ys[0]);
				boundImage.graphics.endFill();
			}else{
				boundImage.graphics.clear();
			}
			
			trace("bound drawing is now set to "+drawBounds);
			
			return drawBounds;
		}*/
		
		
		// ------- getDrawState -------
		/*
	  		returns drawBounds.
		*/
		/*public function getDrawState():Boolean
		{
			return drawBounds;
		}*/
	}
}