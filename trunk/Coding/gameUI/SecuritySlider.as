package gameUI {
	
	import gameLogic.Airport;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class SecuritySlider extends MovieClip {
		private var m_bMarkerDrag:Boolean = false;
		private var m_stage:Stage;
		private var m_alertFunction = null;
		
		private var _min:int;
		private var _max:int;
		
		public function SecuritySlider():void {
			_min = 0;
			_max = this.height;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDown) 
			this.addEventListener(MouseEvent.MOUSE_UP, sliderMouseReleased);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			m_stage = stage;
			m_stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMove);
			
			this.gotoAndStop(3);
			Airport.changeSecurityAlertLevel(this.currentFrame);
		}
		
		public function registerAlert(aFunction):void {
			m_alertFunction = aFunction;
		}
		
		public function getSliderVal():int {
			return this.currentFrame;
		}
		
		private function sliderMouseDown(event:MouseEvent):void {
			m_bMarkerDrag = true;
		}
		
		private function sliderMouseReleased(event:MouseEvent):void {
			if(!m_bMarkerDrag) {
				return;
			}
			
			m_bMarkerDrag = false;
			var newFrame:int = (this.totalFrames + 1) - ((stage.mouseY-(this.y+m_stage.y)) / (_max/this.totalFrames));
			this.gotoAndStop(newFrame);
					
			if(m_alertFunction)
				m_alertFunction(getSliderVal());
		}
		
		private function sliderMouseMove(event:MouseEvent):void {
			if(m_bMarkerDrag)
			{
				if(_min > m_stage.mouseY-(this.y+m_stage.y))
					this.gotoAndStop(this.totalFrames);
				else if(_max < m_stage.mouseY-(this.y+m_stage.y))
					this.gotoAndStop(1);
				else
				{
					var newFrame:int = (this.totalFrames + 1) - ((m_stage.mouseY-this.y) / (_max/this.totalFrames));
					this.gotoAndStop(newFrame);
				}
				Airport.changeSecurityAlertLevel(this.currentFrame);
			}
		}

	}
	
	
	
}