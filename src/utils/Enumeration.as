package utils
{
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Enumeration
	{
		private static const _enums:Dictionary = new Dictionary(true);
		
		public function Enumeration()
		{
			const className:String = getQualifiedClassName(this);
			if (ApplicationDomain.currentDomain.getDefinition(className))
				throw new IllegalOperationError("Cannot create instance of the Enum class");
			if (!_enums[className])
				_enums[className] = new Vector.<Enumeration>();
			_enums[className].push(this);
		}
		
		public static function getElementsList(enumerationClass:Class):Vector.<Enumeration>
		{
			const className:String = getQualifiedClassName(enumerationClass);
			if (_enums[className])
				return _enums[className];
			return null;
		}
		
		public static function getElementByValue(value:*, enumClass:Class):Enumeration
		{
			const className:String = getQualifiedClassName(enumClass);
			if (_enums[className])
			{
				const enumsVec:Vector.<Enumeration> = _enums[className];
				for (var i:int = enumsVec.length - 1; i >= 0; i--)
				{
					if (value == enumsVec[i]['value'])
						return enumsVec[i];
				}
			}
			return null;
		}
		
		public function toString():String
		{
			return this['value'];
		}
	}
}