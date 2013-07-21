package com.starz.control
{
	import flash.display.Sprite;
	import com.starz.events.AnalyticsEvent;
	import flash.external.ExternalInterface;

	public class AnalyticsManager extends Sprite
	{

		public function AnalyticsManager():void
		{

		}
		public function track(e:AnalyticsEvent):void
		{
			trace("GA Event: "+e.analyticsData.data);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("_gaq.push", ['_trackEvent', "Game Event", String(e.analyticsData.data)]);
				}
				catch (e:Error)
				{

				}
			}
			else
			{

			}
		}
	}

}