package com.hackurday.nomtracker.model.vo {
	
	[RemoteClass(alias="User")]
	[Bindable]
	public class User {
		
		public var createdAt:Date;
		public var email:String;
		public var name:String;
		public var id:int;	
		public var login:String;
		public var updatedAt:Date;
		
	}
	
}