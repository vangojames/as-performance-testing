package com.vango.performance.vo
{
	/**
	 * @author James
	 */
	public class TestResult
	{
		//{	Properties
		
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
		 * The amount of time the test took
		 */
		public function get testDuration():Number { return _testDuration; }
		public function set testDuration(value:Number):void
		{
			_testDuration = value;
		}
		private var _testDuration:Number;

		/**
		 * The test number that ths is
		 */
		public function get testNumber():int { return _testNumber; }
		public function set testNumber(value:int):void
		{
			_testNumber = value;
		}
		private var _testNumber:int;
		
		//}
	}
}
