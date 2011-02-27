package com.vango.performance.events
{
	import com.vango.performance.vo.TestResultSet;

	import flash.events.Event;

	/**
	 * @author James
	 */
	public class TestSetEvent extends Event
	{
		//{	Properties
		
		/**
		 * The id of the test that is running
		 */
		public function get testId():int { return _testId; }
		public function set testId(value:int):void
		{
			_testId = value;
		}
		private var _testId:int;
		
		/**
		 * The name of the test
		 */
		public function get testName():String { return _testName; }
		public function set testName(value:String):void
		{
			_testName = value;
		}
		private var _testName:String;

		/**
		 * The test number
		 */
		public function get testNumber():int { return _testNumber; }
		public function set testNumber(value:int):void
		{
			_testNumber = value;
		}
		private var _testNumber:int;

		/**
		 * The total test count
		 */
		public function get testCount():int { return _testCount; }
		public function set testCount(value:int):void
		{
			_testCount = value;
		}
		private var _testCount:int;
		
		/**
		 * The test results (available on test complete)
		 */
		public function get results():TestResultSet { return _results; }
		private var _results:TestResultSet;
		
		//}
		
		//{	Types
		
		public static const TEST_START:String = "testSetStart";
		public static const TEST_PROGRESS:String = "testSetProgress";
		public static const TEST_COMPLETE:String = "testSetComplete";
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function TestSetEvent(type:String, testName:String, testId:int,
			testNumber:int, testCount:int, results:TestResultSet = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

			this._testId = testId;
			this._testName = testName;
			this._testNumber = testNumber;
			this._testCount = testCount;
			this._results = results;
		}
		
		//}
	}
}
