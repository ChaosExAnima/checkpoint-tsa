package utilities {
//This class contains utility function to use in any class
public class Utilities {
	import flash.geom.Point;
	import flash.display.Sprite;
	
	public static function randRange(min, max):int {
		return Math.round(Math.random()*(max-min))+min;
	}
	
	public static function gaussDistribution(expected,rho,min,max):int {
		return (max-min)/2;
	}
	
	public static function getDist(obj1:Sprite, obj2:Sprite):Number {
		var pnt1:Point = new Point(obj1.x, obj1.y);
		var pnt2:Point = new Point(obj2.x, obj2.y);
		
		return (Point.distance(pnt1, pnt2));
	}
	
	public static function offset(obj1:Sprite, obj2:Sprite):Point {
		var targ:Point = new Point(obj1.x-obj2.x, obj1.y-obj2.y);
		return targ;
	}
}
}