﻿package gameUI {
	import gameSound.SoundManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	
	public class MusicSlider extends MovieClip {
		private var _sndMgr:SoundManager;
		private var _markerDrag:Boolean = false;
		private var _alertFunction:Function = null;
		private var _stage:DisplayObject;
		
		private var _min:int;
		private var _max:int;
		
		public function MusicSlider(aSndMgr:SoundManager):void {
			this.thumb.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDown);
			this.addEventListener(Event.ADDED_TO_STAGE, getStage);
			
			_min = 0;
			_max = this.width;
			_sndMgr = aSndMgr;
			
			setSliderVal(_sndMgr.getMusicVolume());
		}
		
		private function getStage(e:Event):void {
			_stage = parent;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMove);
   			_stage.addEventListener(MouseEvent.MOUSE_UP, sliderMouseReleased);
		}
		
		public function registerAlert(aFunction:Function):void {
			_alertFunction = aFunction;
		}
		
		public function getSliderVal():int {
			var percent = (this.thumb.x-_min) / (_max-_min) * 100;
			return percent;
		}
		
		public function setSliderVal(val:int):void {
			this.thumb.x = (val-_min) / (_max-_min) * 100;
		}
		
		private function sliderMouseDown(event:MouseEvent):void {
			_markerDrag = true;
		}
		
		private function sliderMouseReleased(event:MouseEvent):void {
			_markerDrag = false;
			
			if(_min <= _stage.mouseX-this.x && _max >= _stage.mouseX-this.x) {
				this.thumb.x = _stage.mouseX-this.x;
			}
		}
		
		private function sliderMouseMove(event:MouseEvent):void {
			if(_markerDrag) {
				if(_min > _stage.mouseX-this.x) {
					this.thumb.x = _min;
				} else if(_max < _stage.mouseX-this.x) {
					this.thumb.x = _max;
				} else {
					this.thumb.x = _stage.mouseX-this.x;
				}
				if(_alertFunction != null) {
					_alertFunction(getSliderVal());
				}
				_sndMgr.setMusicVolume(getSliderVal());
			}
		}
	}
}