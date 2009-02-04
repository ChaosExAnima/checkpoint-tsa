﻿package gameGraphics {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fl.motion.Color;
	import utilities.*;
	import gameGraphics.PassColor;
	
	public class Legs extends MovieClip {
		private var _wkTime:Timer;
		private var _legs:MovieClip;
		private var _shadow:MovieClip;
		private var _curFrame:uint = 1;
		
		public function Legs():void {}
		
		public function getStand():MovieClip {
			return(new stand1());
		}
		
		public function getWalk():MovieClip {
			return(new walk1());
		}
		
		// Randomly picks a color for the shirt, skin, and hair, then returns the colors as an array
		public function setColor(legs:MovieClip, color:Array = null):Array {
			var newColors: Array;
			
			dirRef(legs); //Used to get a reference to the body instance
			
			var curPants:MovieClip = _legs.pants;
			var curShoes:MovieClip = _legs.shoes;
			var curShadow:MovieClip = _legs.shade;
			var curColor:Color = new Color();
			var tintColor:uint;
			
			if (!color) {
				
				var pantsColor:Array = PassColor.shirtArray[Utilities.randRange(0, PassColor.shirtArray.length-1)];
				var shoesColor:Array =  PassColor.shoeArray[Utilities.randRange(0, PassColor.shoeArray.length-1)];
				tintColor = parseInt('0x'+pantsColor[0].toString(16)+pantsColor[1].toString(16)+pantsColor[2].toString(16));
				
				curColor.setTint(tintColor, 0.2);
				
				curPants.transform.colorTransform = new ColorTransform(0,0,0,1,pantsColor[0],pantsColor[1],pantsColor[2],0);
				curShoes.transform.colorTransform  = new ColorTransform(0,0,0,1, shoesColor[0], shoesColor[1], shoesColor[2],0);
				curShadow.transform.colorTransform = curColor;

				newColors = new Array(
					[pantsColor[0], pantsColor[1], pantsColor[2]],
					[shoesColor[0], shoesColor[1], shoesColor[2]]);
			} else {
				tintColor = parseInt('0x'+color[0][0].toString(16)+color[0][1].toString(16)+color[0][2].toString(16));
				curColor.setTint(tintColor, 0.1);
				
				curPants.transform.colorTransform = new ColorTransform(0,0,0,1,color[0][0],color[0][1],color[0][2],0);
				curShoes.transform.colorTransform  = new ColorTransform(0,0,0,1,color[1][0],color[1][1],color[1][2],0);
				curShadow.transform.colorTransform = curColor;
				
				newColors = new Array(
					[color[0][0],color[0][1],color[0][2]],
					[color[1][0],color[1][1],color[1][2]]);
			}
			return(newColors);
		}
		
		// Sets walking animation speed to match speed of characters
		public function scaleAnim(legs:MovieClip, speed:Number):void {
			if (legs is walk1)
				dirRef(legs);
			else
				return;
			
			if (!_wkTime) {
				_wkTime = new Timer((10-speed)*10);
				_wkTime.addEventListener(TimerEvent.TIMER, takeStep);
				_wkTime.start();
			}
		}
		
		private function takeStep(e:TimerEvent) {
			if (!_legs)
				return;
			_curFrame++
			if (_curFrame>8)
				_curFrame = 1;
			for (var i:uint=0;i<_legs.numChildren;i++) {
				var child:MovieClip = _legs.getChildAt(i) as MovieClip;
				child.gotoAndStop(_curFrame);
			}
			if (_shadow)
				gotoAndStop(_curFrame);
		}
		
		// Get a reference to the current leg direction
		private function dirRef(legs:MovieClip):void {
			switch (legs.currentFrame) {
				case 1:
					_legs = legs.south;
					break;
				case 2:
					_legs = legs.southeast;
					break;
				case 3:
					_legs = legs.east;
					break;
				case 4:
					_legs = legs.northeast;
					break;
				case 5:
					_legs = legs.north;
					break;
				case 6:
					_legs = legs.northwest;
					break;
				case 7:
					_legs = legs.west;
					break;
				case 8:
					_legs = legs.southwest;
					break;
				default:
					_legs = legs.south;
					trace("ERROR! dirRef function in class gameGraphics.Legs out of bounds! value is: "+legs.currentFrame);
					break;
			}
		}
	}
}
		
		