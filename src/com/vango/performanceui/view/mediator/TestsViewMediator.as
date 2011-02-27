package com.vango.performanceui.view.mediator
{
	import com.vango.performance.vo.TestConfiguration;
	import com.vango.performanceui.controller.signals.TestAddedSignal;
	import com.vango.performanceui.view.display.TestsView;

	import org.robotlegs.mvcs.Mediator;


	/**
	 * @author James
	 */
	public class TestsViewMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var testAddedSignal:TestAddedSignal;
		
		/**
		 * Returns the types view component
		 */
		private function get testView():TestsView
		{
			return viewComponent as TestsView;
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
			testAddedSignal.add(onTestAdded);
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Handles adding tests
		 */
		private function onTestAdded(tc:TestConfiguration):void
		{
			testView.addTest(tc);
		}
		
		//}
	}
}
