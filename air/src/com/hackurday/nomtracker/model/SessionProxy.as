package com.hackurday.nomtracker.model {
	
	import com.hackurday.nomtracker.model.vo.User;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * Session proxy.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class SessionProxy extends Proxy {
	   
		/* --- Variables --- */
		
		public static const NAME:String = "SessionProxy";
		
		public static const SESSION_CREATED:String 		= NAME + '/sessionCreated';
		public static const SESSION_DESTROYED:String 	= NAME + '/sessionDestroyed'; 
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param data data model for proxy
		 */
		public function SessionProxy(data:Object=null) {
			super(NAME, data);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function onRemove():void {
			sendNotification(SESSION_DESTROYED);
		}
		
		override public function setData(data:Object):void {
			super.setData(data);
			sendNotification(SESSION_CREATED, user);
		}
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		/* === Event Handlers === */
		
		/* --- Public Accessors --- */
		
		public function get user():User { return data as User; }
		
		/* === Public Accessors === */
		
	}
	
}
