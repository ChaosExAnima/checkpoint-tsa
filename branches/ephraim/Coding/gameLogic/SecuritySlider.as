package gameLogic{
	
  	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import gameGraphics.GameInfoG;

	public class SecuritySlider extends Sprite
    {
		var m_sliderMC:MovieClip;
		var m_bMarkerDrag:Boolean = false;
		var m_stage:Stage;
		var m_alertFunction = null;
		
		var SLIDER_MIN_Y = 0;
		var SLIDER_MAX_Y;
		
		public function SecuritySlider(aStage:Stage, sliderMC:MovieClip)
		{
			m_stage = aStage;
			m_sliderMC = sliderMC;
			addChild(m_sliderMC);
			
			SLIDER_MAX_Y = m_sliderMC.height;
			
			m_sliderMC.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDown) 
			//m_sliderMC.addEventListener(MouseEvent.MOUSE_UP, sliderMouseReleased);
			m_stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMove);
	       	// addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
   			m_stage.addEventListener(MouseEvent.MOUSE_UP, sliderMouseReleased);
			
		}
		
		public function registerAlert(aFunction)
		{
			m_alertFunction = aFunction;
		}
		
		public function getSliderVal():int
		{
			// get percentage position
			//var percent = (m_sliderMC.sliderMarker.y-SLIDER_MIN_Y) / (SLIDER_MAX_Y-SLIDER_MIN_Y) * 100;
			
			return m_sliderMC.currentFrame;
		}
		
		private function sliderMouseDown(event:MouseEvent):void 
		{
			if(m_sliderMC.hitTestPoint(m_stage.mouseX,m_stage.mouseY, false))
				m_bMarkerDrag = true;
			
		}
		
		private function sliderMouseReleased(event:MouseEvent):void 
		{
			if(!m_bMarkerDrag)
				return;
			
			m_bMarkerDrag = false;
			
			var newFrame:int = (m_sliderMC.totalFrames + 1) - ((m_stage.mouseY-(GameInfoG(parent).y+this.y)) / (m_sliderMC.height/m_sliderMC.totalFrames));
			m_sliderMC.gotoAndStop(newFrame);
					
			if(m_alertFunction)
				m_alertFunction(getSliderVal());
		}
		
		private function sliderMouseMove(event:MouseEvent):void 
		{
			if(m_bMarkerDrag)
			{
				if(SLIDER_MIN_Y > m_stage.mouseY-(GameInfoG(parent).y+this.y))
					m_sliderMC.gotoAndStop(m_sliderMC.totalFrames);
				else if(SLIDER_MAX_Y < m_stage.mouseY-(GameInfoG(parent).y+this.y))
					m_sliderMC.gotoAndStop(1);
				else
				{
					var newFrame:int = (m_sliderMC.totalFrames + 1) - ((m_stage.mouseY-(GameInfoG(parent).y+this.y)) / (m_sliderMC.height/m_sliderMC.totalFrames));
					m_sliderMC.gotoAndStop(newFrame);
					
				}
			}
		}

	}
	
	
	
}