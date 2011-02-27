package com.vango.performanceui.view.display
{
	import avmplus.getQualifiedClassName;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author James
	 */
	public class LiquidComponent extends Sprite
	{
		//{	Properties
		
		/**
		 * The width of the component
		 */
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void
		{
			setSize(value, height);
		}
		private var _width:Number = 0;
		
		/**
		 * The height of the component
		 */
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void
		{
			setSize(width, value);
		}
		private var _height:Number = 0;
		
		//}
		
		//{	Private Methods
		
		private var _needsRedraw:Boolean = false;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function LiquidComponent()
		{
			try
			{
				init();	
			}
			catch(er:Error)
			{
				trace(getQualifiedClassName(this) + " :: Error initialising : " + er);	
			}
			
			// listen for stage
			if(stage) onAddedToStage(null);
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Resizes the component
		 */
		public function setSize(width:Number, height:Number):void
		{
			this._width = width;
			this._height = height;
			// set redraw flag
			_needsRedraw = true;
		}
		
		/**
		 * Draws the component
		 */
		public function draw():void
		{
			if (_needsRedraw)
			{
				doDraw();
				_needsRedraw = false;
			}
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		*/
		protected function init():void
		{
			// store current width and height
			_width = super.width;
			_height = super.height;
		}
		
		/**
		 * Draws the component
		 */
		protected function doDraw():void
		{
			trace("Warning : doDraw not implemeneted in " + getQualifiedClassName(this));
		}
				
		//}
		
		//{	Handlers
		
		/**
		 * Handles addition to the stage
		 */
		private function onAddedToStage(event:Event):void
		{
			// setup listeners
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			// add enter frame listener for redrawing
			stage.addEventListener(Event.ENTER_FRAME, onFrameHandler);
		}

		/**
		 * Handles enter frame events
		 */
		private function onFrameHandler(event:Event):void
		{
			// call draw
			draw();
		}

		/**
		 * Handles removal from the stage
		 */
		private function onRemovedFromStage(event:Event):void
		{
			// setup listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// remove enter frame listener
			stage.removeEventListener(Event.ENTER_FRAME, onFrameHandler);
		}
		
		//}
	}
}
