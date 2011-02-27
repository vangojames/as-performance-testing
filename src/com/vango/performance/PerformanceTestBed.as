package com.vango.performance
{
	import com.vango.performance.events.TestBedEvent;
	import com.vango.performance.events.TestSetEvent;
	import com.vango.performance.vo.TestComparisonSet;
	import com.vango.performance.vo.TestConfiguration;
	import com.vango.performance.vo.TestResult;
	import com.vango.performance.vo.TestResultSet;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * The abstract class that allows performance testing
	 * 
	 * @author James
	 */
	public class PerformanceTestBed extends EventDispatcher
	{
		//{	Properties
		
		/**
		 * The maximum amount of time to allow a test to run for before
		 * breaking. Allows async testing.
		 */
		public function get maxTestRunTime():int { return _maxTestRunTime; }
		public function set maxTestRunTime(value:int):void
		{
			_maxTestRunTime = value;
		}
		private var _maxTestRunTime:int = 1000;
		
		/**
		 * An array of tests
		 */
		public function get tests():Array { return _tests; }
		private var _tests:Array;
		
		/**
		 * Determines whether the test bed is running or not
		 */
		public function get isRunning():Boolean { return _isRunning; }
		private var _isRunning:Boolean;
		
		//}
		
		//{	Fields
		
		protected var _currentTestIndex:int;
		private var _currentSubTestCount:int;
		private var _testTimer:Timer;
		private var _results:Array;
		private var _resultSet:TestResultSet;
		private var _totalTestCount:int = 0;
		private var _currentTestCount:int = 0;
			
		//}
		
		//{	Constructor
		
		public function PerformanceTestBed()
		{
			_tests = [];
			_results = [];
			_testTimer = new Timer(1);
			_testTimer.addEventListener(TimerEvent.TIMER, continueTesting);
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Runs a test for performance
		 */
		public function runTest():void
		{
			if(_isRunning) return;
			log("Executing " + _tests.length + " performance tests...");
			_currentTestIndex = 0;
			_currentSubTestCount = 1;
			_currentTestCount = 1;
			_isRunning = true;
			dispatchEvent(new TestBedEvent(TestBedEvent.TEST_START, "", _currentTestCount, _totalTestCount));
			_testTimer.start();
		}
		
		/**
		 * Adds a new test to the test bed
		 */
		public function addTest(name:String, testClass:Class, testCount:int = 100):void
		{
			// create test configuration
			var test:TestConfiguration = new TestConfiguration(name, testClass, testCount);
			// add to dictionary
			_tests.push(test);
			// set test count
			_totalTestCount += testCount;
			
			// log out
			log("Added " + test.name + " (ID : " + test.id.toString() + ")");
		}
		
		/**
		 * Returns the test results for the test with the id passed in
		 */
		public function getTestResult(testId:int):TestResultSet
		{
			for each (var tr:TestResultSet in _results)
				if (tr.testId == testId) return tr;
			
			return null;
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Runs a series of tests on a test configuration
		 */
		private function runTestsOnConfiguration(tc:TestConfiguration):void
		{
			var l:int = tc.testCount;
			var startTime:int = getTimer();
			var runDuration:int = 0;
			if (_currentSubTestCount == 1) log("Running " + tc.name);
			while (_currentSubTestCount <= l)
			{
				_resultSet.addTestResult(runTestConfiguration(tc, _currentSubTestCount));
				_currentSubTestCount++;
				_currentTestCount++;
				runDuration = getTimer() - startTime;
				// check to see if the run duration has exceeded the maximum test time
				if (runDuration > maxTestRunTime)
				{
					dispatchEvent(new TestSetEvent(TestSetEvent.TEST_PROGRESS, tc.name, tc.id, _currentSubTestCount, l));
					dispatchEvent(new TestBedEvent(TestBedEvent.TEST_PROGRESS, tc.name, _currentTestCount, _totalTestCount));
					return;
				}
			}

			// trace the result set
			_results.push(_resultSet);
			log(_resultSet);
			
			// dispatch test update
			dispatchEvent(new TestSetEvent(TestSetEvent.TEST_COMPLETE, tc.name, tc.id, _currentSubTestCount, l, _resultSet));
			dispatchEvent(new TestBedEvent(TestBedEvent.TEST_PROGRESS, tc.name, _currentTestCount, _totalTestCount));
		}
		
		/**
		 * Runs a single test configuration and returns the result in miliseconds of 
		 * how long it took to run the test
		 */
		private function runTestConfiguration(tc:TestConfiguration, testNumber:int):TestResult
		{
			var time:int;
			
			// get new test instance
			var testInstance:* = tc.getInstance();
				
			// run before tests
			for each (var beforeMethodList:Array in tc.beforeMethods)
			{
				for each (var beforeMethod:String in beforeMethodList)
					testInstance[beforeMethod]();
			}
			
			// run tests
			for each (var testMethodList:Array in tc.testMethods)
			{
				for each (var testMethod:String in testMethodList)
				{
					var st:int = getTimer();
					testInstance[testMethod]();
					var et:int = getTimer();
					time += (et - st);
				}
			}
			
			// run after tests
			for each (var afterMethodList:Array in tc.afterMethods)
			{
				for each (var afterMethod:String in afterMethodList)
					testInstance[afterMethod]();
			}
			
			var result:TestResult = new TestResult();
			result.testNumber = testNumber;
			result.testDuration = time;
			result.testName = tc.name;
			
			return result;
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Runs the next test in the list
		 */
		private function continueTesting(event:TimerEvent):void
		{
			// get current test
			var tc:TestConfiguration = _tests[_currentTestIndex];
			
			// if the test is completed set the next test
			if (_currentSubTestCount >= tc.testCount)
			{
				// begin next test
				_currentSubTestCount = 1;
				_currentTestIndex++;
			}
			
			// check to see if tests have completed
			if (_currentTestIndex >= _tests.length)
			{
				_testTimer.stop();
				var l:int = _results.length;
				var comparisonSet:TestComparisonSet = new TestComparisonSet();
				for(var i:int = 0; i < l; i++)
				{
					var r:TestResultSet = _results[i];
					comparisonSet.addComparison(r);
				}
				trace(comparisonSet);
				_isRunning = false;
				dispatchEvent(new TestBedEvent(TestBedEvent.TEST_COMPLETE, tc.name, _currentTestCount, _totalTestCount));
			}
			else
			{
				// get current test
				tc = _tests[_currentTestIndex];
				// if the sub test count is one then build a new result set
				if (_currentSubTestCount == 1)
				{
					_resultSet = new TestResultSet(tc.name, tc.id);
					dispatchEvent(new TestSetEvent(TestSetEvent.TEST_START, tc.name, tc.id, 0, tc.testCount));
				}
				// run the test configuration
				runTestsOnConfiguration(tc);
			}
		}
		
		/**
		 * Logs out arguments
		 */
		private function log(...arguments):void
		{
			var traceString:String = "[PerformanceTestBed] :: ";
			
			var l:int = arguments.length;
			for(var i:int = 0; i < l; i++)
			{
				var end:String = (i == (l - 1)) ? "" : ", ";
				traceString += arguments.toString() + end;
			}

			trace(traceString);
		}
		
		//}
	}
}
