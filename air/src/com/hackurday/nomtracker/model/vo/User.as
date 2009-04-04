package com.hackurday.nomtracker.model.vo {
	
	[RemoteClass(alias="User")]
	[Bindable]
	public class User {
		
		//public var createdAt:Date;
		public var email:String;
		public var firstName:String;
		public var id:int;	
		public var lastName:String;
		//public var login:String;
		public var middleName:String;
		public var title:String;
		//public var updatedAt:Date;

		public function get firstAndLastName():String {
			return firstName + ' ' + lastName; 
		}
		
	}
	
}