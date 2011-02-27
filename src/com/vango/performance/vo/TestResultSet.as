package com.vango.performance.vo
{
	/**
	 * The result of tests
	 * 
	 * @author James
	 */
	public class TestResultSet
	{
		//{	Properties
		
		/**
		 * The id of the test
		 */
		public function get testId():int { return _testId; }
		private var _testId:int;
		
		/**
		 * The name of the test
		 */
		public function get testName():String { return _testName; }
		private var _testName:String;
		
		/**
		 * The total duration for the test result
		 */
		public function get totalDuration():int { return _totalDuration; }
		private var _totalDuration:int;
		
		/**
		 * The average time it took for each test
		 */
		public function get meanTestTime():Number
		{
			if (_meanNeedsUpdate)
			{
				_meanTestTime = _totalDuration / _testCount;
				_meanNeedsUpdate = false;
			}
			return _meanTestTime;
		}
		private var _meanTestTime:Number;

		/**
		 * The standard deviation of tests
		 */
		public function get testDeviation():Number
		{
			if (_sdNeedsUpdate)
			{
				_testDeviation = getDeviation();
				_sdNeedsUpdate = false;
			}
			return _testDeviation;
		}
		private var _testDeviation:Number;

		/**
		 * The number of tests that ran
		 */
		public function get testCount():int { return _testCount; }
		private var _testCount:int;
		
		/**
		 * The results for the set
		 */
		public function get results():Array { return _results; }
		private var _results:Array;
		
		/**
		 * The slowest test time
		 */
		public function get slowestTime():Number { return _slowestTime; }
		private var _slowestTime:Number = 0;

		/**
		 * The fastest test time
		 */
		public function get fastestTime():Number { return _fastestTime; }
		private var _fastestTime:Number = 0;
		
		//}
		
		//{	Fields
		
		private var _sdNeedsUpdate:Boolean = true;
		private var _meanNeedsUpdate:Boolean = true;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function TestResultSet(name:String, testId:int)
		{
			_testName = name;
			_testId = testId;
			_results = [];
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Adds a new test result to the set
		 */
		public function addTestResult(result:TestResult):void
		{
			// increase test count and update total duration
			_testCount++;
			_totalDuration += result.testDuration;
			
			// push result
			_results.push(result);

			// update fastest and slowest times
			if (_results.length == 1)
			{
				_slowestTime = result.testDuration;
				_fastestTime = result.testDuration;
			}
			else
			{
				_slowestTime = Math.max(result.testDuration, _slowestTime);
				_fastestTime = Math.min(result.testDuration, _fastestTime);
			}
			
			// set flags
			_meanNeedsUpdate = true;
			_sdNeedsUpdate = true;
		}
		
		/**
		 * Returns a string representation of the test srt
		 */
		public function toString():String
		{
			var rString:String = "Test : " + testName;
			rString += "\n\tTest count : " + testCount.toString();
			rString += "\n\tTotal time : " + totalDuration.toString() + "ms";
			rString += "\n\tMean time : " + meanTestTime.toString() + "ms";
			rString += "\n\tStandard deviation : " + testDeviation.toString();
			rString += "\n\tFastest test : " + fastestTime.toString() + "ms";
			rString += "\n\tSlowest test : " + slowestTime.toString() + "ms";
			return rString;
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Returns the standard deviation for the result set
		 */
		private function getDeviation():Number
		{
			// calculate the mean
			var mean:Number = meanTestTime;
			
			// calculate the variance
			var variance:Number = 0;
			for(var i:int = 0; i < testCount; i++)
			{
				var result:TestResult = _results[i];
				variance += Math.pow((result.testDuration - mean), 2);
			}
			variance /= testCount;
			
			// now calculate the standard deviation
			return Math.pow(variance, 0.5);
		}
		
		//}
	}
}
