package gameGraphics {

	import utilities.*;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import gameGraphics.PassColor;
	
	public class Torso extends MovieClip {
		public static var _gender:String = 'male';
		
		public function Torso() { }

		// Returns a reference to a randomly chosen new torso type
		public function getTorso():MovieClip {
			var newTorso:MovieClip;

			switch(Utilities.randRange(0,2)) {
				case 0:
					newTorso = new torso1();
					break;
				case 1:
					newTorso = new torso2();
					_gender = 'female';
					break;
				case 2:
					newTorso = new torso3();
					break;
			}
			
			return (newTorso);
		}

		// Randomly picks a color for the shirt, skin, and hair, then returns the colors as an array
		public function setColor(torso:MovieClip, color:Array = null):Array {
			var newColors: Array;
			
			var curBody:MovieClip = changeDir(torso); //Used to get a reference to the body instance
			
			var curShirt:MovieClip = curBody.shirt;
			var curSkin:MovieClip = curBody.flesh;
			var curHair:MovieClip = curBody.hair;
			var curHat:MovieClip;
			if (curBody.hat) {
				curHat = curBody.hat;
			}
			
			var shirtColor:Array = PassColor.shirtArray[Utilities.randRange(0, PassColor.shirtArray.length-1)];
			var skinColor:Array =  PassColor.skinArray[Utilities.randRange(0, PassColor.skinArray.length-1)];
			var hairColor:Array =  PassColor.hairArray[Utilities.randRange(0, PassColor.hairArray.length-1)];
			
			if (!color) {
				curShirt.transform.colorTransform = new ColorTransform(0,0,0,1,shirtColor[0],shirtColor[1],shirtColor[2],0);
				curSkin.transform.colorTransform  = new ColorTransform(0,0,0,1, skinColor[0], skinColor[1], skinColor[2],0);
				curHair.transform.colorTransform  = new ColorTransform(0,0,0,1, hairColor[0], hairColor[1], hairColor[2],0);
				if (curHat) {
					curHat.transform.colorTransform = new ColorTransform(0,0,0,1,shirtColor[0],shirtColor[1],shirtColor[2],0);
				}

				newColors = new Array(
					[shirtColor[0], shirtColor[1], shirtColor[2]],
					[ skinColor[0],  skinColor[1],  skinColor[2]],
					[ hairColor[0],  hairColor[1],  hairColor[2]]);
			} else {
				curShirt.transform.colorTransform = new ColorTransform(0,0,0,1,color[0][0],color[0][1],color[0][2],0);
				curSkin.transform.colorTransform  = new ColorTransform(0,0,0,1,color[1][0],color[1][1],color[1][2],0);
				curHair.transform.colorTransform  = new ColorTransform(0,0,0,1,color[2][0],color[2][1],color[2][2],0);
				if (curHat) {
					curHat.transform.colorTransform = new ColorTransform(0,0,0,1,color[0][0],color[0][1],color[0][2],0);
				}
				newColors = new Array(
					[color[0][0],color[0][1],color[0][2]],
					[color[1][0],color[1][1],color[1][2]],
					[color[2][0],color[2][1],color[2][2]]);
			}
			return(newColors);
		}
		
		// Gets a reference to the current body
		private function changeDir(torso:MovieClip):MovieClip {
			var body:MovieClip;	
			var dir:int = torso.currentFrame;
			
			switch (dir) {
				case 1:
					body = torso.south;
					break;
				case 2:
					body = torso.southeast;
					break;
				case 3:
					body = torso.east;
					break;
				case 4:
					body = torso.northeast;
					break;
				case 5:
					body = torso.north;
					break;
				case 6:
					body = torso.northwest;
					break;
				case 7:
					body = torso.west;
					break;
				case 8:
					body = torso.southwest;
					break;
				default:
					body = torso.south;
					break;
			}
			return(body);
		}
		
		// Not implemented yet!
		public function poseDefault():void {
			
		}
		
		// Not implemented yet!
		public function poseArrest():void {
			
		}
		
		// Not implemented yet!
		public function poseBored():void {
			
		}
		
		// Not implemented yet!
		public function poseCross():void {
			
		}
		
		public function getGender():String {
			return(_gender);
		}
	}
}