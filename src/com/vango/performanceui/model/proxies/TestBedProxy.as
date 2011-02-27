package com.vango.performanceui.model.proxies
{
	import com.vango.performance.PerformanceTestBed;
	import com.vango.performance.events.TestBedEvent;
	import com.vango.performance.events.TestSetEvent;
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.controller.signals.OverallTestProgressSignal;
	import com.vango.performanceui.controller.signals.TestAddedSignal;
	import com.vango.performanceui.controller.signals.TestProgressSignal;
	import com.vango.performanceui.controller.signals.TestResultSetSignal;

	import org.robotlegs.mvcs.Actor;


	/**
	 * @author James
	 */
	public class TestBedProxy extends Actor
	{
		//{	Properties
		
		[Inject]
		public var testBed:PerformanceTestBed;
		[Inject]
		public var testAddedSignal:TestAddedSignal;
		[Inject]
		public var overallTestProgressSignal:OverallTestProgressSignal;
		[Inject]
		public var testProgressSignal:TestProgressSignal;
		[Inject]
		public var testResultSetSignal:TestResultSetSignal;
		
		//}
		
		//{	Fields
		
		/**
		 * Determines whether the test bed is running or not
		 */
		private function get isRunning():Boolean { return testBed.isRunning; }
		
		//}
		
		//{	Public Methods
		
		/**
		 * Initialises the class
		 */
		[PostConstruct]
		public function init():void
		{
			// add test set events
			testBed.addEventListener(TestSetEvent.TEST_START, onTestSetEvent);
			testBed.addEventListener(TestSetEvent.TEST_PROGRESS, onTestSetEvent);
			testBed.addEventListener(TestSetEvent.TEST_COMPLETE, onTestSetEvent);
			
			// add test bed events
			testBed.addEventListener(TestBedEvent.TEST_START, onTestBedEvent);
			testBed.addEventListener(TestBedEvent.TEST_PROGRESS, onTestBedEvent);
			testBed.addEventListener(TestBedEvent.TEST_COMPLETE, onTestBedEvent);
		}
		
		/**
		 * Adds a test to the test bed
		 */
		public function addTest(testName:String, testClass:Class, testCount:int):void
		{
			// add to the testbed
			testBed.addTest(testName, testClass, testCount);
			var tests:Array = testBed.tests;
			testAddedSignal.dispatch(tests[tests.length - 1]);
		}
		
		/**
		 * Shows the test result with the specified id
		 */
		public function setActiveTestResult(id:int):void
		{
			// get the test result
			var testResult:TestResultSet = getTestResultSet(id);
			if (testResult) testResultSetSignal.dispatch(testResult);
			else trace("No results found for id " + id);
		}
		
		/**
		 * Runs the tests
		 */
		public function runTests():void
		{
			if (!isRunning) testBed.runTest();
		}
		
		/**
		 * Returns the test result set with the specified id
		 */
		public function getTestResultSet(id:int):TestResultSet
		{
			return testBed.getTestResult(id);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles test bed events
		 */
		private function onTestBedEvent(event:TestBedEvent):void
		{
			switch(event.type)
			{
				case TestBedEvent.TEST_START:
					overallTestProgressSignal.dispatch("Beginning tests", 0);
					break;
				case TestBedEvent.TEST_PROGRESS:
					overallTestProgressSignal.dispatch("Testing '" + event.currentTestName + "'", event.currentTestCount / event.totalTestCount);
					break;
				case TestBedEvent.TEST_COMPLETE:
					overallTestProgressSignal.dispatch("All tests complete", 1);
					break;
			}
		}
		
		/**
		 * Handles test set events
		 */
		private function onTestSetEvent(event:TestSetEvent):void
		{
			testProgressSignal.dispatch(event.testId, event.testNumber / event.testCount);
		}
		
		//}
	}
}
