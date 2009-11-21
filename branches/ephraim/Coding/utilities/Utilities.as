package utilities {
//This class contains utility function to use in any class
public class Utilities {
	import flash.geom.Point;
	import flash.display.*;
	
	public static var nme:Sprite;
	
	public static function randRange(min, max):int {
		return Math.round(Math.random()*(max-min))+min;
	}
	
	public static function gaussDistribution(expected,rho,min,max):int {
		return (max-min)/2;
	}
	
	public static function getDist(obj1:Sprite, obj2:Sprite):Number {
		var pnt1:Point = obj1.localToGlobal(new Point(obj1.x, obj1.y));
		var pnt2:Point = obj2.localToGlobal(new Point(obj2.x, obj2.y));
		if (!Utilities.nme)
			Utilities.nme = obj2;
		else if (Utilities.nme == obj2)
			trace(obj2.name+" D: "+Point.distance(pnt1, pnt2));
		return (Point.distance(pnt1, pnt2));
	}
	
	public static function offset(obj1:Sprite, obj2:Sprite):Point {
		var targ:Point = new Point(obj1.x-obj2.x, obj1.y-obj2.y);
		return targ;
	}
	
	public static function addMark(lX:int, lY:int):Shape {
		var mark:Shape = new Shape();
		with (mark) {
			graphics.lineStyle(2, 0xFF0000);
			graphics.moveTo(5, 5);
			graphics.lineTo(-5, -5);
			graphics.moveTo(-5, 5);
			graphics.lineTo(5, -5);
			x = lX;
			y = lY;
		}
		return mark;
	}
}
}