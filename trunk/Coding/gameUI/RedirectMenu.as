package gameUI {
	import gameGraphics.PassengerG;
	import gameUI.Interface;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;	
	import flash.events.MouseEvent;
	
	public class RedirectMenu extends MovieClip {
		private var _person:PassengerG;
		private var _lineArray:Array = new Array();
		private var _UI:Interface;
		
		public function RedirectMenu(person:PassengerG, UI:Interface):void {
			_person = person;
			_UI = UI;
			_lineArray.push(this.b_line1, this.b_line2, this.b_line3, this.b_line4, this.b_line5);
			
			while (_lineArray.length != _UI.getNumStations()) {
				_lineArray.pop();
			}
			
			for (var i:int = 0; i < _lineArray.length; i++) {
				_lineArray[i].addEventListener(MouseEvent.CLICK, redirect);
			}
			if (true) {
				this.b_line5.addEventListener(MouseEvent.CLICK, debug);
			}
			this.x += 50;
			
			_person.halt(true);
			
			var mood:int = _person.logic.getMood();
			var time:int = _person.logic.getTimeLeft()/3;
			
			if (time > 40) {
				time = 40;
			}
			this.icon_time.gotoAndStop(time);
			
			if (mood <= 25) {
				this.icon_mood.gotoAndStop(4);
			} else if (mood <= 50) {
				this.icon_mood.gotoAndStop(3);
			} else if (mood <= 75) {
				this.icon_mood.gotoAndStop(2);
			} else if (75 < mood) {
				this.icon_mood.gotoAndStop(1);
			}
		}
		
		private function redirect(e:MouseEvent):void {
			for (var i:int = 0; i < _lineArray.length; i++) {
				if (_lineArray[i] == e.target) {
					trace("Line Set!");
					_person.setLine(_UI.getStation(i+1).line);
					_person.halt(false);
					parent.removeChild(this);
				}
			}
		}
		
		private function debug(e:MouseEvent):void {
			trace("Here's what I am doing:");
			trace("Rerouting: "+_person.rerouting);
			trace("In line: "+_person.logic.line);
			trace("Parent is: "+_person.parent);
			trace("Is Obsolete: "+_person.obsolete);
		}
	}
}