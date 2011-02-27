package com.vango.performanceui.controller.signals
{
	import com.vango.performance.vo.TestComparisonSet;

	import org.osflash.signals.Signal;

	/**
	 * @author James
	 */
	public class ComparisonsUpdatedSignal extends Signal
	{
		public function ComparisonsUpdatedSignal()
		{
			super(TestComparisonSet);
		}
	}
}
