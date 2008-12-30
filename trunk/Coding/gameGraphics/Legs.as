package gameGraphics {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import utilities.Utilities;
	
	public class Legs extends MovieClip {
		private var _stand:MovieClip;
		private var _walk:MovieClip;
		private var _speed:uint;
		private var _curFrame:uint = 1;
		private var _walkTime:Timer;
		public var _curLegs:MovieClip;
		
		public function Legs(speed:uint):void {
			_speed = speed*10;
			_walkTime = new Timer(_speed);
			
			switch(Utilities.randRange(0,0)) {
				case 0:
					_stand = new PStand();
					_walk = new PWalk();
					break;
			}
			Stand();
		}
			
		public function Stand():void {
			if (this.numChildren) {
				if (this.getChildAt(0) == _walk) {
					this.removeChild(_walk);
				}
			}
			this.addChild(_stand);
			_curLegs = _stand;
			//_walkTime.reset();
			//_walkTime.removeEventListener(TimerEvent.TIMER_COMPLETE, walkFrame);
		}
		
		public function Walk():void {
			if (this.numChildren) {
				if (this.getChildAt(0) == _stand) {
					this.removeChild(_stand);
				}
			}
			this.addChild(_walk);
			_curLegs = _walk;
			if (_walkTime) {
			//_walkTime.addEventListener(TimerEvent.TIMER, walkFrame);
			//_walkTime.start();
			}
		}
		
		private function walkFrame(e:TimerEvent):void {
			var dirLegs:MovieClip = _walk.cLegs.getChildAt(0);
//			trace("Fired");
			for(var i:uint = 0; i < dirLegs.numChildren; i++) {
				var child:MovieClip = dirLegs.getChildAt(i) as MovieClip;
				child.gotoAndStop(_curFrame);
				//trace("Iteration "+i+"Child ref is "+child);
			}
			_curFrame = _curFrame < 8 ? _curFrame++ : 1;
		}
		
		public function cleanUp():void {
			trace("Cleanup time!");
			_walkTime.stop();
			_walkTime.removeEventListener(TimerEvent.TIMER, walkFrame);
			_walkTime = null;
		}
		
		private function dirRef(legs:MovieClip):MovieClip {
			var ref:MovieClip;
			
			switch (legs.currentFrame) {
				case 1:
					ref = legs.cLegs.south;
					break;
				case 2:
					ref = legs.cLegs.southeast;
					break;
				case 3:
					ref = legs.cLegs.east;
					break;
				case 4:
					ref = legs.cLegs.northeast;
					break;
				case 5:
					ref = legs.cLegs.north;
					break;
				case 6:
					ref = legs.cLegs.northwest;
					break;
				case 7:
					ref = legs.cLegs.west;
					break;
				case 8:
					ref = legs.cLegs.southwest;
					break;
				default:
					ref = legs.south;
					trace("ERROR! dirRef function in class gameGraphics.Legs out of bounds! value is: "+legs.currentFrame);
					break;
			}
			return(ref);
		}
	}
}
		
		