package com.vango.performanceui.context
{
	import com.vango.performance.PerformanceTestBed;
	import com.vango.performanceui.controller.commands.AddComparisonCommand;
	import com.vango.performanceui.controller.commands.AddTestCommand;
	import com.vango.performanceui.controller.commands.RemoveComparisonCommand;
	import com.vango.performanceui.controller.commands.RunTestsCommand;
	import com.vango.performanceui.controller.commands.ShowTestResultsCommand;
	import com.vango.performanceui.controller.commands.StartupCommand;
	import com.vango.performanceui.controller.signals.AddComparisonSignal;
	import com.vango.performanceui.controller.signals.AddTestSignal;
	import com.vango.performanceui.controller.signals.ComparisonsUpdatedSignal;
	import com.vango.performanceui.controller.signals.OverallTestProgressSignal;
	import com.vango.performanceui.controller.signals.RemoveComparisonSignal;
	import com.vango.performanceui.controller.signals.RunTestsSignal;
	import com.vango.performanceui.controller.signals.ShowTestResultsSignal;
	import com.vango.performanceui.controller.signals.TestAddedSignal;
	import com.vango.performanceui.controller.signals.TestProgressSignal;
	import com.vango.performanceui.controller.signals.TestResultSetSignal;
	import com.vango.performanceui.model.proxies.ComparisonProxy;
	import com.vango.performanceui.model.proxies.TestBedProxy;
	import com.vango.performanceui.view.display.ComparisonRenderer;
	import com.vango.performanceui.view.display.ComparisonViewer;
	import com.vango.performanceui.view.display.ResultsViewer;
	import com.vango.performanceui.view.display.StatusView;
	import com.vango.performanceui.view.display.TestRenderer;
	import com.vango.performanceui.view.display.TestsView;
	import com.vango.performanceui.view.mediator.ComparisonRendererMediator;
	import com.vango.performanceui.view.mediator.ComparisonViewerMediator;
	import com.vango.performanceui.view.mediator.PerformanceUIMediator;
	import com.vango.performanceui.view.mediator.ResultsViewerMediator;
	import com.vango.performanceui.view.mediator.StatusViewMediator;
	import com.vango.performanceui.view.mediator.TestRendererMediator;
	import com.vango.performanceui.view.mediator.TestsViewMediator;

	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.SignalContext;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author James
	 */
	public class PerformanceUIContext extends SignalContext
	{
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function PerformanceUIContext(contextView:DisplayObjectContainer)
		{
			// startup the context
			super(contextView, true);
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Starts up the context
		 */
		override public function startup():void
		{
			// MODEL
			injector.mapSingleton(TestBedProxy);
			injector.mapSingleton(PerformanceTestBed);
			injector.mapSingleton(ComparisonProxy);
			
			// CONTROLLER
			signalCommandMap.mapSignalClass(AddTestSignal, AddTestCommand);
			signalCommandMap.mapSignalClass(ShowTestResultsSignal, ShowTestResultsCommand);
			signalCommandMap.mapSignalClass(RunTestsSignal, RunTestsCommand);
			signalCommandMap.mapSignalClass(AddComparisonSignal, AddComparisonCommand);
			signalCommandMap.mapSignalClass(RemoveComparisonSignal, RemoveComparisonCommand);
			injector.mapSingleton(TestAddedSignal);
			injector.mapSingleton(OverallTestProgressSignal);
			injector.mapSingleton(TestProgressSignal);
			injector.mapSingleton(TestResultSetSignal);
			injector.mapSingleton(ComparisonsUpdatedSignal);
			
			// VIEW
			mediatorMap.mapView(contextView, PerformanceUIMediator);
			mediatorMap.mapView(TestsView, TestsViewMediator);
			mediatorMap.mapView(TestRenderer, TestRendererMediator);
			mediatorMap.mapView(ResultsViewer, ResultsViewerMediator);
			mediatorMap.mapView(ComparisonViewer, ComparisonViewerMediator);
			mediatorMap.mapView(ComparisonRenderer, ComparisonRendererMediator);
			mediatorMap.mapView(StatusView, StatusViewMediator);
			
			// startup the app
			(signalCommandMap.mapSignalClass(Signal, StartupCommand, true) as Signal).dispatch();
		}
		
		//}
	}
}
