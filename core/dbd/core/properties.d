module dbd.core.properties;

import core.sys.windows.windows;
import core.sys.windows.wtypes: BSTR;
import std.utf: toUTFz, encode;
import std.conv: to;
import std.algorithm: each;

import dbd.core.dll, dbd.core.delphiobject;

template GenObjectProperty(string name, alias classType, bool read = true, bool write = true)
{
    static if(read && write)
	{
		import std.traits:fullyQualifiedName;
		enum className = fullyQualifiedName!classType;
		
		const char[] GenObjectProperty = 
		`
		private `~className~` _`~name~`;

		@property `~className~` `~name~`() 
		{
			auto r = cast(void*) getPropertyReference(_reference, "`~name~`");

			if(r is null)
			{
				_`~name~` = null;
			}
			else if (_`~name~` is null || _`~name~`.reference !is r)
			{
				_`~name~` = new `~className~`(r);
			}
			return _`~name~`;
		}
		
		@property void `~name~`(`~className~` value) 
		{
			setPropertyReference(_reference, "`~name~`", (value is null) ? null : value.reference);
			_`~name~` = value;
		}
		`;
	}
}

/*
template GenStructProperty(string name, alias structType, bool read = true, bool write = true)
{
    static if(read && write)
	{
		import std.traits:fullyQualifiedName;
		enum structName = fullyQualifiedName!structType;
		
		const char[] GenStructProperty = 
		`
		@property `~structName~` `~name~`() 
		{
			return *(cast(`~structName~`*) getPropertyStruct(_reference, "`~name~`"));
		}
		`;
	}
}
*/

// TODO: IS index == size_t ?
struct IntegerArrayProperty(BaseType)
{
	private DelphiObject _obj;
	private string _propertyName;
	
	this(DelphiObject obj, string propertyName) 
	{ 
		_obj = obj; 
		_propertyName = propertyName;
	}
	
	BaseType opIndex(int index)
	{ 
		auto r = getIntegerIndexedPropertyReference(_obj.reference, _propertyName, index);
		return new BaseType(r); 
	}
}

template GenIntegerIndexedProperty(string name, alias ArrayType)
{
	const char[] GenIntegerIndexedProperty = 
	`
	
	@property IntegerArrayProperty!`~ArrayType.stringof~` `~name~`()
	{
		return IntegerArrayProperty!`~ArrayType.stringof~`(this, "`~name~`");
	}`;
}

void setPropertyReference(void* reference1, string name, void* value)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyReference");
	alias extern(Windows) void function(void*, char*, void*) FN;
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

void* getPropertyReference(void* reference, string name)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyReference");
	alias extern(Windows) void* function(void*, char*) FN;
	auto fn = cast(FN) fp;
	return fn(reference, pChar);
}

void* getPropertyStruct(void* reference, string name)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyStruct");
	alias extern(Windows) void* function(void*, char*) FN;
	auto fn = cast(FN) fp;
	return fn(reference, pChar);
}

// TODO: Is index == size_t?
void* getIntegerIndexedPropertyReference(void* reference, string name, int index)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getIntegerIndexedPropertyReference");
	alias extern(Windows) void* function(void*, char*, int) FN;
	auto fn = cast(FN) fp;
	return fn(reference, pChar, index);
}

void setPropertyShort(void* reference, string name, short value)
{
	alias extern(Windows) void function(void*, char*, short) FN;
	
	auto pChar = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertySmallInt");
	auto fn = cast(FN) fp;
	fn(reference, pChar, value);
}

short getPropertyShort(void* reference1, string name)
{
	alias extern(Windows) short function(void*, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertySmallInt");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyInt(void* reference, string name, int value)
{
	alias extern(Windows) void function(void*, char*, int) FN;
	auto pChar = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyInteger");
	auto fn = cast(FN) fp;
	fn(reference, pChar, value);
}

int getPropertyInt(void* reference1, string name)
{
	alias extern(Windows) int function(void*, char*) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyInteger");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyUInt(void* reference1, string name, uint value)
{
	alias extern(Windows) void function(void*, char*, uint) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyCardinal");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

uint getPropertyUInt(void* reference1, string name)
{
	alias extern(Windows) uint function(void*, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyCardinal");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyInt64(void* reference, string name, long value)
{
	alias extern(Windows) void function(void*, char*, long) FN;
	auto pChar = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyInt64");
	auto fn = cast(FN) fp;
	fn(reference, pChar, value);
}

long getPropertyInt64(void* reference1, string name)
{
	alias extern(Windows) long function(void*, char*) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyInt64");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyUInt64(void* reference1, string name, ulong value)
{
	alias extern(Windows) void function(void*, char*, ulong) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyUInt64");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

ulong getPropertyUInt64(void* reference1, string name)
{
	alias extern(Windows) ulong function(void*, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyUInt64");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyEnum(void* reference, string name, string value)
{
	alias extern(Windows) void function(void*, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyEnum");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, pCharValue);
}

string getPropertyEnum(void* reference, string name)
{
	alias extern(Windows) void function(void*, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyEnum");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

void setPropertySet(void* reference, string name, string value)
{
	alias extern(Windows) void function(void*, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertySet");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, pCharValue);
}

string getPropertySet(void* reference, string name)
{
	alias extern(Windows) void function(void*, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertySet");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

void setPropertyBool(void* reference1, string name, bool value)
{
	alias extern(Windows) void function(void*, char*, bool) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyBoolean");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

bool getPropertyBool(void* reference1, string name)
{
	alias extern(Windows) bool function(void*, char*) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyBool");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyFloat(void* reference1, string name, float value)
{
	alias extern(Windows) void function(void*, char*, float) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertySingle");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

float getPropertyFloat(void* reference1, string name)
{
	alias extern(Windows) float function(void*, char*) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertySingle");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyString(void* reference1, string name, string value)
{
	alias extern(Windows) void function(void*, char*, BSTR) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setPropertyString");
	auto fn = cast(FN) fp;
	
	wchar[] ws;
	value.each!(c => encode(ws, c));
	BSTR bStr = SysAllocStringLen(ws.ptr, cast(UINT) ws.length);
	
	fn(reference1, pCharName, bStr);
	SysFreeString(bStr);
}

string getPropertyString(void* reference, string name)
{
	alias extern(Windows) void function(void*, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "getPropertyString");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}