package com.hackurday.nomtracker.view.events {
	
	import flash.events.Event;

	/**
	 * Session Event.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class SessionEvent extends Event {
		
		public static const TRY_LOGIN:String = "tryLogin";
		public static const LOGOUT:String = "logout";
		
		public var credentials:Object;
			
		public function SessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, credentials:Object=null) {
			super(type, bubbles, cancelable);
			this.credentials = credentials;
		}
		
	}
	
}