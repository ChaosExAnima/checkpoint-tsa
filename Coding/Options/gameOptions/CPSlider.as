﻿package gameOptions {	  	import flash.display.Sprite;	import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.display.Stage;	public class CPSlider extends Sprite    {		var m_sliderMC:MovieClip;		var m_markerY:Number;		var m_bMarkerDrag:Boolean = false;		var m_stage:Stage;		var m_alertFunction = null;				var SLIDER_MIN_X = 17;		var SLIDER_MAX_X = 136;				public function CPSlider(aStage:Stage, sliderMC:MovieClip)		{			m_stage = aStage;			m_sliderMC = sliderMC;			addChild(m_sliderMC);									m_sliderMC.sliderMarker.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDown) 			//m_sliderMC.addEventListener(MouseEvent.MOUSE_UP, sliderMouseReleased);			m_stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMove);	       	// addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);   			m_stage.addEventListener(MouseEvent.MOUSE_UP, sliderMouseReleased);					}				public function registerAlert(aFunction)		{			m_alertFunction = aFunction;		}				public function getSliderVal():int		{			// get percentage position			var percent = (m_sliderMC.sliderMarker.x-SLIDER_MIN_X) / (SLIDER_MAX_X-SLIDER_MIN_X) * 100;			return percent;		}		public function setSliderVal(valPercent:int):void		{			if(valPercent < 0 || valPercent > 100)				return;							m_sliderMC.sliderMarker.x = SLIDER_MIN_X + (valPercent / 100 * (SLIDER_MAX_X-SLIDER_MIN_X));		}						private function sliderMouseDown(event:MouseEvent):void 		{			m_bMarkerDrag = true;		}				private function sliderMouseReleased(event:MouseEvent):void 		{						if(!m_bMarkerDrag && !m_sliderMC.hitTestPoint(m_stage.mouseX, m_stage.mouseY))				return;						m_bMarkerDrag = false;			if(SLIDER_MIN_X <= m_stage.mouseX-(this.x+this.parent.x)			   && SLIDER_MAX_X >= m_stage.mouseX-(this.x+this.parent.x))			{				m_sliderMC.sliderMarker.x = m_stage.mouseX-(this.x+this.parent.x);			}						if(m_alertFunction)				m_alertFunction(getSliderVal());		}				private function sliderMouseMove(event:MouseEvent):void 		{			if(m_bMarkerDrag)			{				if(SLIDER_MIN_X > m_stage.mouseX-(this.x+this.parent.x))					m_sliderMC.sliderMarker.x = SLIDER_MIN_X;				else if(SLIDER_MAX_X < m_stage.mouseX-(this.x+this.parent.x))					m_sliderMC.sliderMarker.x = SLIDER_MAX_X;				else					m_sliderMC.sliderMarker.x = m_stage.mouseX-(this.x+this.parent.x);			}		}	}			}