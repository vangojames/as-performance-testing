package com.vango.performance.vo
{
	/**
	 * @author James
	 */
	public class TestComparisonSet
	{
		//{	Properties
		
		/**
		 * The ordered list of tests
		 */
		public function get tests():Array { return _tests; }
		private var _tests:Array = [];
		
		/**
		 * The fastest test in the set
		 */
		public function get fastestTest():TestResultSet { return _fastestTest; }
		private var _fastestTest:TestResultSet;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Adds a new comparison to the set
		 */
		public function addComparison(test:TestResultSet):void
		{
			// update fastest test
			if (!_fastestTest) _fastestTest = test;
			if (test.meanTestTime < _fastestTest.meanTestTime) _fastestTest = test;
			
			// push in to tests array
			_tests.push(test);
			
			// order test arrays
			_tests.sortOn(["meanTestTime"]);
		}
		
		/**
		 * Clears the tests out
		 */
		public function clear():void
		{
			_fastestTest = null;
			_tests.length = 0;
		}
		
		/**
		 * Returns a string representation of this set
		 */
		public function toString():String
		{
			var l:int = _tests.length;
			if (l == 0) return "Empty comparison set";
			
			
			var rString:String = "Comparing " + _tests.length.toString() + " test results : ";
			var t:TestResultSet = _tests[0] as TestResultSet;
			rString += "\n\tFastest : " + t.testName + 
				" (ID : " + t.testId.toString() + ")";
			
			for (var i:int = 1; i < l; i++)
			{
				t = _tests[i] as TestResultSet;
				rString += "\n\tPlace " + i.toString() + " : " 
					+ t.testName + " (ID : " + t.testId.toString() + ")";
			}
			return rString;
		}
		
		//}
	}
}
