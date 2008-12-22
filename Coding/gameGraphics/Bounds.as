﻿package Utilities {/*	This class models simple accessable bounds for passengers*/	import utilities.*;	public class Bounds	{		public static var x1:Number = 66.0;		public static var y1:Number = 873.5;				public static var x2:Number = 1033.8;		public static var y2:Number = 1372.8;				public static var x3:Number = 2065.0;		public static var y3:Number = 839.5;				public static var x4:Number = 1073.1;		public static var y4:Number = 354.1;				public static var xHigh:Number = 1073.1;		public static var yHigh:Number = 354.1;				public static var xLow:Number = 1033.8;		public static var yLow:Number = 1372.8;				public static var xLeft:Number = 66.0;		public static var yLeft:Number = 873.5;				public static var xRight:Number = 2065.0;		public static var yRight:Number = 839.5;				private static var px1:Number = 66.0;		private static var py1:Number = 873.5;				private static var px2:Number = 1033.8;		private static var py2:Number = 1372.8;				private static var px3:Number = 2065.0;		private static var py3:Number = 839.5;				private static var px4:Number = 1073.1;		private static var py4:Number = 354.1;				private static var pxHigh:Number = 1073.1;		private static var pyHigh:Number = 354.1;				private static var pxLow:Number = 1033.8;		private static var pyLow:Number = 1372.8;				private static var pxLeft:Number = 66.0;		private static var pyLeft:Number = 873.5;				private static var pxRight:Number = 2065.0;		private static var pyRight:Number = 839.5;				private static var high:uint = 4;		private static var low:uint = 2;		private static var left:uint = 1;		private static var right:uint = 3;				public static function setX1(nV:Number):void		{		}				public static function pointIn(x_:Number,y_:Number):Boolean		{			if(x_ <= pxRight && x_ >= pxLeft && y_ <= pyLow && y_ >= pyHigh)			{				if(x_ < pxLow)				{					if(! (((pyLeft - pyLow)/(pxLeft - pxLow))*(x_-pxLeft) + pyLeft >= y_))					{						return false;					}				}else{					if(! (((pyRight - pyLow)/(pxRight - pxLow))*(x_-pxRight) + pyRight >= y_))					{						return false;					}				}								if(x_ < pxHigh)				{					if(! (((pyLeft - pyHigh)/(pxLeft - pxHigh))*(x_-pxLeft) + pyLeft <= y_))					{						return false;					}				}else{					if(! (((pyRight - pyHigh)/(pxRight - pxHigh))*(x_-pxRight) + pyRight <= y_))					{						return false;					}				}			}else{				return false;			}			return true;		}				public static function randomYforX(x_:Number):Number		{			var low:Number = 0;			var high:Number = 0;						if(x_ <= pxRight && x_ >= pxLeft)			{				if(x_ < pxLow)				{					low = ((pyLeft - pyLow)/(pxLeft - pxLow))*(x_-pxLeft) + pyLeft;				}else{					low = ((pyRight - pyLow)/(pxRight - pxLow))*(x_-pxRight) + pyRight;				}								if(x_ < pxHigh)				{					high = ((pyLeft - pyHigh)/(pxLeft - pxHigh))*(x_-pxLeft) + pyLeft;				}else{					high = ((pyRight - pyHigh)/(pxRight - pxHigh))*(x_-pxRight) + pyRight;				}			}else{				trace("given x_ ("+x_+") is outside of area bounds");				return null;			}			return Utilities.randRange(low,high);		}				public static function randomX():Number		{			return Utilities.randRange(pxLeft,pxRight);		}	}}