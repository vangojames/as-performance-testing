package com.vango.performanceui.view.mediator
{
	import com.vango.performanceui.controller.signals.AddTestSignal;
	import com.vango.performanceui.view.display.PerformanceUIView;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author James
	 */
	public class PerformanceUIMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var addTestSignal:AddTestSignal;
		
		/**
		 * Returns the types view component
		 */
		private function get performanceUI():PerformanceUIView
		{
			return viewComponent as PerformanceUIView;
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Handles registration of the mediator
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			// add listener for add test
			addViewListener("add", onAddTest);
			// fire add test after a frame
			setTimeout(onAddTest, 100, null);
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Handles adding tests
		 */
		private function onAddTest(event:Event):void
		{
			// dispatch all tests
			var tests:Array = performanceUI.testQueue;
			for each(var test:Object in tests)
			{
				addTestSignal.dispatch(test["testName"], test["testClass"], test["testCount"]);
			}
			// clear test queue
			performanceUI.testQueue.length = 0;
		}
		
		//}
	}
}
