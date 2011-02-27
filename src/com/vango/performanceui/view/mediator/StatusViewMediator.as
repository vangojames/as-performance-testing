package com.vango.performanceui.view.mediator
{
	import com.vango.performanceui.controller.signals.OverallTestProgressSignal;
	import com.vango.performanceui.controller.signals.RunTestsSignal;
	import com.vango.performanceui.view.display.StatusView;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author James
	 */
	public class StatusViewMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var runTestsSignal:RunTestsSignal;
		[Inject]
		public var testProgressSignal:OverallTestProgressSignal;
		
		//}
		
		//{	Fields
		
		/**
		 * The typed view component
		 */
		private function get statusView():StatusView
		{
			return viewComponent as StatusView;
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Called on mediator registration
		 */
		override public function onRegister():void
		{
			testProgressSignal.add(onTestProgress);
			statusView.runSignal.add(onRunRequest);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles test progress
		 */
		private function onTestProgress(currentTestName:String, progress:Number):void
		{
			statusView.overallProgress = progress;
			statusView.currentTestName = currentTestName;
		}
		
		/**
		 * Handles run requests
		 */
		private function onRunRequest():void
		{
			runTestsSignal.dispatch();
		}
		
		//}
	}
}
