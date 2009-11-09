﻿package gameLogic {
public class ProhibitedObject {
	
	//stores whether the prohibited object is metal, a bomb, drugs, etc.
	protected var kindOfObj:String; 
	//stores what kind of gun, drugs etc. the prohibited object is
	protected var kindOfKindOfObj:String;
	
	//Loss in reputation when an incident occurs after the passenger went to the plane with a prohibited object.
	protected var incidentRepLoss:int;
	//Loss in reputation when the passenger goes to the plane with a prohibited object.
	protected var missingRepLoss:int;
	//Gain in reputation when a prohibited object is detected.
	protected var catchingRepGain:int;
	//Gain in money when a prohibited object is detected.
	protected var catchingMoneyGain:int;
	//Probability [0,1] of an incident occuring after a prohibited object got onto a plane.
	protected var incidentProb:Number;
	
	public function ProhibitedObject(kindOfObj:String, kindOfKindOfObj:String, incidentRepLoss:int, missingRepLoss:int, catchingRepGain:int, catchingMoneyGain:int, incidentProb:Number) {
		this.kindOfObj = kindOfObj;
		this.kindOfKindOfObj = kindOfKindOfObj;
		this.incidentRepLoss = incidentRepLoss;
	    this.missingRepLoss = missingRepLoss;
	    this.catchingRepGain = catchingRepGain;
		this.catchingMoneyGain = catchingMoneyGain;		
		this.incidentProb = incidentProb;
	}
		
	/*
	//Constructor sets the Prohibited Object to a certain kind if this kind shows up in kindOfObjs.
	public function ProhibitedObject (kOObj:String) {
		if(kindOfObjs.indexOf(kOObj) > -1)
			kindOfObj = kOObj;
	}
	*/
	
	/*
	//This method returns a subclass of a prohibited object as to the specified probabilities
	public function ProhibitedObject() {
		var dice:Number = Math.random();
		
		/* TEMPORARY COMM OUT
		if(dice<probabilityOfObjs[0]) proObj = new Metal();
		else if(dice<probabilityOfObjs[0]+propbabilityOfObjs[1]) proObj = new Bomb();
		else proObj = new Drugs();
		
		kindOfObj = "metal";
	}*/
	
		
	public function getKindOfObj():String {
		return kindOfObj;
	}
	
	public function setKindOfObj(pObj:String):void {
		kindOfObj = pObj;
	}
	
	public function getKindOfKindOfObj():String {
		return kindOfKindOfObj;
	}
	
	//PRE: Passenger got through all security checks with the prohibited object not being detected
	//POST: Decides whether an incident happens
	public function incidentHappens():Boolean {
		var dice:Number = Math.random();
		
		if (dice < incidentProb) return true;
		else return false;
	}
	
	//PRE: Elements of listOfObj must be strings, probOfObj must be numerbs that add up to 1
	//POST: This method chooses from a list of kinds of kinds of objects one with given probability
	protected function chooseKindOfKindOfObj(listOfObj:Array, probOfObj:Array):String {
		var dice:Number = Math.random();
		var probability:Number = 0;
		
		for(var i:int=0;i<listOfObj.length;i++) {
			probability = probability + probOfObj[i];
			if (dice < probability) return listOfObj[i];
		}
		return null;
	}
	
	public function incidentMsg():String {
		return "Invalid";
	}
	
	public function getCatchingRepGain():int {
		return catchingRepGain;
	}
	
	public function getCatchingMoneyGain():int {
		return catchingMoneyGain;
	}
	
	public function getMissingRepLoss():int {
		return missingRepLoss;
	}
	
	public function getIncidentRepLoss():int {
		return incidentRepLoss;
	}
	
}
}