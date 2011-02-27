package com.vango.performanceui.view.display
{
	import com.vango.performanceui.context.PerformanceUIContext;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author James
	 */
	public class PerformanceUIView extends Sprite
	{
		//{	Properties
		
		/**
		 * The current queue of tests that need to be registered
		 */
		public function get testQueue():Array { return _testQueue; }
		public function set testQueue(value:Array):void
		{
			_testQueue = value;
		}
		private var _testQueue:Array = [];
		
		//}
		
		//{	Fields
		
		protected var _context:PerformanceUIContext;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function PerformanceUIView()
		{
			// initialise the class
			init();
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Adds a test to run
		 */
		public function addTest(testName:String, testClass:Class, testCount:int = 1000):void
		{
			var test:Object = {testName:testName, testClass:testClass, testCount:testCount};
			_testQueue.push(test);
			dispatchEvent(new Event("add"));
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		*/
		private function init():void
		{
			// build the context
			_context = new PerformanceUIContext(this);
		}
		
		//}
	}
}
