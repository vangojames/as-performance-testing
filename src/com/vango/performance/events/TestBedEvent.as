package com.vango.performance.events
{
	import flash.events.Event;

	/**
	 * @author James
	 */
	public class TestBedEvent extends Event
	{
		//{	Properties
		
		/**
		 * The current test
		 */
		public function get currentTestCount():int { return _currentTestCount; }
		public function set currentTestCount(currentTestCount:int):void
		{
			_currentTestCount = currentTestCount;
		}
		private var _currentTestCount:int;

		/**
		 * The total number of tests to run
		 */
		public function get totalTestCount():int { return _totalTestCount; }
		public function set totalTestCount(totalTestCount:int):void
		{
			_totalTestCount = totalTestCount;
		}
		private var _totalTestCount:int;

		/**
		 * The name of the current test
		 */
		public function get currentTestName():String { return _currentTestName; }
		public function set currentTestName(currentTestName:String):void
		{
			_currentTestName = currentTestName;
		}
		private var _currentTestName:String;
		
		//}
		
		//{	Types
		
		public static const TEST_START:String = "testBedStart";
		public static const TEST_PROGRESS:String = "testBedProgress";
		public static const TEST_COMPLETE:String = "testBedComplete";
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function TestBedEvent(type:String, currentTestName:String, currentTestCount:int, totalTestCount:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.currentTestName = currentTestName;
			this.currentTestCount = currentTestCount;
			this.totalTestCount = totalTestCount;
		}
		
		//}
	}
}
