﻿package gameGraphics {		import gameLogic.CheepieXRayMachine;		/* Encapsulates the graphical representation of a Cheepie X-ray machine. */		public class CheepieXRayMachineG extends XRayMachineG {				public function CheepieXRayMachineG(xLoc:Number, yLoc:Number) {			super(xLoc, yLoc, new CheepieXRayMachine(), new GCheepieXRayMachine());		}	}}