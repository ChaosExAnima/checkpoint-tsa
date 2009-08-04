﻿package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.geom.Point;
	
	public class Bounds extends Sprite
	{
		private var boundImage:Sprite = new Sprite();// = new collisionBox();
		
		
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
		public function Bounds(pnt1:Point, pnt2:Point, pnt3:Point, pnt4:Point):void
		{
			//this.addChild(Utilities.addMark(0,0));
			drawBounds(pnt1, pnt2, pnt3, pnt4);
			boundImage.mouseChildren = false;
			boundImage.mouseEnabled = false;
			this.addChild(boundImage);
		}
		
		
		// ------- setPoints -------
		/*
	  		sets point whichPoint to nx, ny. Will return false if point is invalid
			given current other points; returns true in all cases, for now.
		*/
		/*public function setPoints(whichPoint:int, nx:Number, ny:Number):Boolean
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
			//boundImage.visible = false;
			
			var glPt:Point = new Point(px, py);
			glPt = boundImage.localToGlobal(glPt);
			var inside:Boolean = boundImage.hitTestPoint(glPt.x, glPt.y, true);
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
			var rand:Point = new Point(Utilities.randRange(this.parent.x,boundImage.width+this.parent.x), Utilities.randRange(this.parent.y,boundImage.height+this.parent.y));
			var i = 0;
			while (pointIn(rand.x, rand.y) == false) {
				i++;
				rand = new Point(Utilities.randRange(this.parent.x,boundImage.width+this.parent.x), Utilities.randRange(this.parent.y,boundImage.height+this.parent.y));
			}
		
			return rand;
		}
		
		
		// ------- toggleDraw -------
		/*
	  		toggles drawing on/off, returns new state.
		*/
		public function drawBounds(pnt1:Point, pnt2:Point, pnt3:Point, pnt4:Point):void
		{
			with (boundImage) {
				graphics.clear();
				graphics.beginFill(0xFF0000, 0);
				graphics.moveTo(pnt1.x,pnt1.y);
				graphics.lineTo(pnt2.x,pnt2.y);
				graphics.lineTo(pnt3.x,pnt3.y);
				graphics.lineTo(pnt4.x,pnt4.y);
				graphics.lineTo(pnt1.x,pnt1.y);
				graphics.endFill();
			}
		}
		
		
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