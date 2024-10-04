module dbd.core.events;

import std.utf: toUTFz;
import std.traits: isDelegate, ReturnType, ParameterTypeTuple, isDelegate;
import core.sys.windows.windows;

import dbd.core.delphiobject;
import dbd.core.dll;

auto bindDelegate(T, string file = __FILE__, size_t line = __LINE__)(T t) if(isDelegate!T) {
    static T dg;

    dg = t;

    extern(Windows)
    static ReturnType!T func(ParameterTypeTuple!T args) {
            return dg(args);
    }

    return &func;
}

void setEventArgsRef(DelphiObject object, string delphiEventName, void* framePointer, void* fnPointer)
{
    alias EventArgsRef = void delegate(DelphiObject sender);
    alias EventArgsRefCallback = extern(Windows) void function(void*, void*, void*) ;
	alias Fn = extern(Windows) void function(void*, char*, void*, void*, EventArgsRefCallback) ;
	
	void delegate(void*, void*, void*) dg = (void* delphiRef, void* dRef, void* funcRef) {
		EventArgsRef ne;
		ne.funcptr = cast(void function(DelphiObject)) funcRef;
		ne.ptr = cast(void*) dRef;
		try
		{
			ne(cast(DelphiObject) cast(void*) dRef);
		}
		catch(Exception e)
		{
			import std.stdio;
			writeln(e.msg);
		}
	};
	
	auto pChar = toUTFz!(char*)(delphiEventName);
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setNotifyEvent");
	Fn fn = cast(Fn) fp;
	fn(object.reference, pChar, framePointer, fnPointer, bindDelegate(dg));
}

void setEventArgsRefRefStruct(T)(DelphiObject object, string delphiEventName, void* framePointer, void* fnPointer)
{
	alias EventArgsRefRefStruct = void delegate(DelphiObject, DelphiObject, T);
    alias EventArgsRefRefStructCallback = extern(Windows) void function(void*, void*, void*, void*, void*) ;
	alias Fn = extern(Windows) void function(void*, char*, void*, void*, EventArgsRefRefStructCallback) ;

	void delegate(void*, void*, void*, void*, void*) dg = (void* delphiRef, void* canvasRef, void* aRectRef, void* dRef, void* funcRef) {
		EventArgsRefRefStruct ne;
		ne.funcptr = cast(void function(DelphiObject, DelphiObject, T)) funcRef;
		ne.ptr = cast(void*) dRef;
		try
		{
			ne(cast(DelphiObject) cast(void*) dRef, cast(DelphiObject) cast(void*) canvasRef, *(cast(T*) cast(void*) aRectRef ));
		}
		catch(Exception e)
		{
			import std.stdio;
			writeln(e.msg);
		}
	};
	
	auto pChar = toUTFz!(char*)(delphiEventName);
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "setOnPaintEvent");
	Fn fn = cast(Fn) fp;
	fn(object.reference, pChar, framePointer, fnPointer, bindDelegate(dg));
}
