module dbd.core.methods;

import core.sys.windows.windows;
import core.sys.windows.wtypes: BSTR;
import std.utf: toUTFz, encode;
import std.algorithm: each;
import std.conv: to;

import dbd.core.dll;

bool isProperty(string[] items...) {
	foreach(item; items)
		if(item == "@property")
			return true;
	return false;
}

enum skip;

mixin template PascalClass(string name)
{
	private mixin template PascalImportImpl(T, alias method, size_t overloadIndex)
	{
		import std.traits;
		import std.conv : to;
		import std.algorithm: map;
		import std.array: join;

		static if(isProperty(__traits(getFunctionAttributes, method))) {
			static assert(__traits(isStaticFunction, method) == false);

			static if (is(ReturnType!method == void) && Parameters!method.length == 1)
			{
				pragma(mangle, method.mangleof)
				private void implementation(Parameters!method args)
				{
					static if(is(Parameters!method[0] == bool))
					{
						setPropertyBool(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == float))
					{
						setPropertyFloat(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == short))
					{
						setPropertyShort(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == int))
					{
						setPropertyInt(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == uint))
					{
						setPropertyUInt(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == long))
					{
						setPropertyInt64(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == ulong))
					{
						setPropertyUInt64(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == string))
					{
						setPropertyString(_reference, __traits(identifier, method), args[0]);
					}
					else static if(is(Parameters!method[0] == enum))
					{
						setPropertyEnum(_reference, __traits(identifier, method),args[0].to!string );
					}
					else static if(is(Parameters!method[0] : E[], E))
					{
						static if(is(E == enum))
						{
							setPropertySet(_reference, __traits(identifier, method), args[0].map!(item => item.to!string).join(","));
						}
						else
						{
							static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
						}
					}
					else static if(is(Parameters!method[0] : Object))
					{
						setPropertyReference(_reference, __traits(identifier, method), (args[0] is null) ? null : args[0].reference);
					}
					else static if( isDelegate!(Parameters!method[0]))
					{                            
                        alias dlg = Parameters!method[0];
                        static if (Parameters!dlg.length == 1 && is(Parameters!dlg[0] : Object))
                        {
                            setEventArgsRef(this, __traits(identifier, method), args[0].ptr, args[0].funcptr);
                        }
						else static if (Parameters!dlg.length == 3 && is(Parameters!dlg[0] : Object ) && is(Parameters!dlg[1] : Object ) && is(Parameters!dlg[2] == struct ))
                        {
							setEventArgsRefRefStruct!(Parameters!dlg[2])(this, __traits(identifier, method), args[0].ptr, args[0].funcptr);
                        }
                        else
                        {
                            static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
                        }
					}
					else static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
				}
			}
			else static if (!is(ReturnType!method == void) && Parameters!method.length == 0)
			{
				pragma(mangle, method.mangleof)
				private ReturnType!method implementation()
				{
					static if(is(ReturnType!method == bool))
					{
						return getPropertyBool(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == float))
					{
						return getPropertyFloat(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == short))
					{
						return getPropertyShort(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == int))
					{
						return getPropertyInt(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == uint))
					{
						return getPropertyUInt(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == long))
					{
						return getPropertyInt64(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == ulong))
					{
						return getPropertyUInt64(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == string))
					{
						return getPropertyString(_reference, __traits(identifier, method));
					}
					else static if(is(ReturnType!method == enum))
					{
						return getPropertyEnum(_reference, __traits(identifier, method)).to!(ReturnType!method);
					}
					else static if(is(ReturnType!method : E[], E))
					{
						static if(is(E == enum))
						{
							//static assert(false, "IS ENUM ARRAY");
							// getPropertySet(): Comma separated
							ReturnType!method empty;			
							return empty;
						}
						else
						{
							static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
						}
					}
					else static if(is(ReturnType!method : Object))
					{
						auto r = cast(void*) getPropertyReference(_reference, __traits(identifier, method));
						return (r is null) ? null : new ReturnType!method(r);
					}
					else static if(is(ReturnType!method == struct))
					{
						return *(cast(ReturnType!method*) getPropertyStruct(_reference, __traits(identifier, method)));
					}
					
					else static if( isDelegate!(ReturnType!method))
					{                            
                        return null;
                        /*alias dlg = Parameters!method[0];
                        static if (Parameters!dlg.length == 1 && is(Parameters!dlg[0] : Object))
                        {
                            alias methodInstance = __traits(getOverloads, this, __traits(identifier, method))[0];
                            setEventArgsRef(this, __traits(identifier, method), methodInstance.ptr, methodInstance.funcptr);
                        }
                        else
                        {
                            assert(false, "Not implemented");
                        }*/
					}
                    else
					{
						static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
					} 
				}
			} else static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
		} 
		else 
		{
			static if (__traits(isStaticFunction, method))
			{
				pragma(mangle, method.mangleof)
				private static ReturnType!method implementation(Parameters!method args)
				{
					//	executeClassMethodReturnRefArgsRef
					static if(is(ReturnType!method : Object) && args.length == 1 && is(typeof(args[0]) : Object))
					{
						auto arg0Reference = args[0] is null ? null : args[0].reference;
						auto resultReference = executeClassMethodReturnRefArgsRef(name, __traits(identifier, method), arg0Reference);
						return new ReturnType!method(resultReference);
					} 
					//	executeClassMethodReturnRefArgsIntInt
					else static if(is(ReturnType!method : Object) && args.length == 2 && is(typeof(args[0]) : int) && is(typeof(args[1]) : int))
					{
						auto resultReference = executeClassMethodReturnRefArgsIntInt(name, __traits(identifier, method), args[0], args[1]);
						return new ReturnType!method(resultReference);
					} 
					// executeClassMethodReturnRefArgsString
					else static if(is(ReturnType!method : Object) && args.length == 1 && is(typeof(args[0]) == string))
					{
						auto resultReference = executeClassMethodReturnRefArgsString(name, __traits(identifier, method), args[0]);
						return new ReturnType!method(resultReference);
					}
					// executeClassMethodReturnRefArgsNone
					else static if(is(ReturnType!method : Object) && args.length == 0)
					{
						auto resultReference = executeClassMethodReturnRefArgsNone(name, __traits(identifier, method));
						return new ReturnType!method(resultReference);
					}
					// executeClassMethodReturnRefArgsRefNativeInt
					else static if(is(ReturnType!method : Object) && args.length == 2 && is(typeof(args[0]) : Object) && is(typeof(args[1]) == ptrdiff_t))
					{
						auto arg0Reference = args[0] is null ? null : args[0].reference;
						auto resultReference = executeClassMethodReturnRefArgsRefNativeInt(name, __traits(identifier, method), arg0Reference, args[1]);
						return new ReturnType!method(resultReference);
					}
					// executeClassMethodReturnIntArgsNone
					else static if(is(ReturnType!method : int) && args.length == 0)
					{
						return executeClassMethodReturnIntArgsNone(name, __traits(identifier, method));
					}
					// executeClassMethodReturnNoneArgsNone
					else static if(is(ReturnType!method == void) && args.length == 0)
					{
						executeClassMethodReturnNoneArgsNone(name, __traits(identifier, method));
					}
					// executeClassMethodReturnNoneArgsString
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == string))
					{
						executeClassMethodReturnNoneArgsString(name, __traits(identifier, method), args[0]);
					}
					//	executeClassMethodReturnNoneArgsRefRef
					else static if(is(ReturnType!method : void) && args.length == 2 && is(typeof(args[0]) : Object) && is(typeof(args[1]) : Object))
					{
						auto arg0Reference = args[0] is null ? null : args[0].reference;
						auto arg1Reference = args[1] is null ? null : args[1].reference;
						executeClassMethodReturnNoneArgsRefRef(name, __traits(identifier, method), arg0Reference, arg1Reference);
					} 
					// executeClassMethodReturnBoolArgsString
					else static if(is(ReturnType!method == bool) && args.length == 1 && is(typeof(args[0]) == string))
					{
						return executeClassMethodReturnBoolArgsString(name, __traits(identifier, method), args[0]);
					}
					// executeClassMethodReturnRefArgsIntUInt
					else static if(is(ReturnType!method : Object) && args.length == 2 && is(typeof(args[0]) == enum) && is(typeof(args[1]) == uint))
					{
						// TODO: Is Int correct, for x64?
						auto resultReference = executeClassMethodReturnRefArgsIntUInt(name, __traits(identifier, method), args[0], args[1]);
						return new ReturnType!method(resultReference);
					}
					// executeClassMethodReturnRefArgsRefRefRefBool
					else static if(is(ReturnType!method : Object) && args.length == 4 
						&& is(typeof(args[0]) : Object) && is(typeof(args[1]) : Object) && is(typeof(args[2]) : Object) && is(typeof(args[3]) == bool))
					{
						auto arg0Reference = args[0] is null ? null : args[0].reference;
						auto arg1Reference = args[1] is null ? null : args[1].reference;
						auto arg2Reference = args[2] is null ? null : args[2].reference;
						auto resultReference = executeClassMethodReturnRefArgsRefRefRefBool(name, __traits(identifier, method), arg0Reference, arg1Reference, arg2Reference, args[3]);
						return new ReturnType!method(resultReference);
					}
					// executeClassMethodReturnStringArgsNone
					else static if(is(ReturnType!method == string) && args.length == 0)
					{
						return executeClassMethodReturnStringArgsNone(name, __traits(identifier, method));
					}
					// executeClassMethodReturnStringArgsStringStringString
					else static if(is(ReturnType!method == string) && args.length == 3 && is(typeof(args[0]) == string) && is(typeof(args[1]) == string) && is(typeof(args[2]) == string))
					{
						return executeClassMethodReturnStringArgsStringStringString(name, __traits(identifier, method), args[0], args[1], args[2]);
					}
					// executeClassMethodReturnStrucArgsFloatFloatFloatFloat
					else static if(is(ReturnType!method == struct) && args.length == 4 && is(typeof(args[0]) == float) && is(typeof(args[1]) == float ) && is(typeof(args[2]) == float ) && is(typeof(args[3]) == float ))
					{
						auto resultReference =  executeClassMethodReturnStructArgsFloatFloatFloatFloat(name, __traits(identifier, method), args[0], args[1], args[2], args[3]);
						return *cast(ReturnType!method*) resultReference;
					}
					else 
					{
						static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
					}
				}
			}
			else
			{
				pragma(mangle, method.mangleof)
				private ReturnType!method implementation(Parameters!method args)
				{
					//	executeInstanceMethodReturnBoolArgsNone
					static if(is(ReturnType!method == bool) && args.length == 0)
					{
						return executeInstanceMethodReturnBoolArgsNone(_reference, __traits(identifier, method));
					}

					//	executeInstanceMethodReturnBoolArgsBool
					else static if(is(ReturnType!method == bool) && args.length == 1 && is(typeof(args[0]) == bool))
					{
						return executeInstanceMethodReturnBoolArgsBool(_reference, __traits(identifier, method), args[0]);
					}

					//	executeInstanceMethodReturnBoolArgsInt
					else static if(is(ReturnType!method == bool) && args.length == 1 && is(typeof(args[0]) == int))
					{
						return executeInstanceMethodReturnBoolArgsInt(_reference, __traits(identifier, method), args[0]);
					}

					//	executeInstanceMethodReturnBoolArgsFloatFloat
					else static if(is(ReturnType!method == bool) && args.length == 2 && is(typeof(args[0]) == float) && is(typeof(args[1]) == float))
					{
						return executeInstanceMethodReturnBoolArgsFloatFloat(_reference, __traits(identifier, method), args[0], args[1]);
					}

					//	executeInstanceMethodReturnBoolArgsRef
					else static if(is(ReturnType!method == bool) && args.length == 1 && is(typeof(args[0]) : Object))
					{
						return executeInstanceMethodReturnBoolArgsRef(_reference, __traits(identifier, method), args[0].reference);
					}

					//	executeInstanceMethodReturnBoolArgsRefInt
					else static if(is(ReturnType!method == bool) && args.length == 2 && is(typeof(args[0]) : Object) && is(typeof(args[1]) : int))
					{
						return executeInstanceMethodReturnBoolArgsRefInt(_reference, __traits(identifier, method), args[0].reference, args[1]);
					}

					//	executeInstanceMethodReturnBoolArgsString
					else static if(is(ReturnType!method == bool) && args.length == 1 && is(typeof(args[0]) : string))
					{
						return executeInstanceMethodReturnBoolArgsString(_reference, __traits(identifier, method), args[0]);
					}

					//	executeInstanceMethodReturnIntArgsNone
					else static if(is(ReturnType!method == int) && args.length == 0)
					{
						return executeInstanceMethodReturnIntArgsNone(_reference, __traits(identifier, method));
					}

					//	executeInstanceMethodReturnUIntArgsNone
					else static if(is(ReturnType!method == ulong) && args.length == 0)
					{
						return executeInstanceMethodReturnULongArgsNone(_reference, __traits(identifier, method));
					}

					//	executeInstanceMethodReturnLongArgsNone
					else static if(is(ReturnType!method == long) && args.length == 0)
					{
						return executeInstanceMethodReturnLongArgsNone(_reference, __traits(identifier, method));
					}

					//	executeInstanceMethodReturnULongArgsNone
					else static if(is(ReturnType!method == ulong) && args.length == 0)
					{
						return executeInstanceMethodReturnULongArgsNone(_reference, __traits(identifier, method));
					}

					// executeInstanceMethodReturnNoneArgsRef
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) : Object))
					{
						executeInstanceMethodReturnNoneArgsRef(_reference, __traits(identifier, method), args[0].reference);
					}

					// executeInstanceMethodReturnNoneArgsRefString
					else static if(is(ReturnType!method == void) && args.length == 2 && is(typeof(args[0]) : Object) && is(typeof(args[1]) == string))
					{
						executeInstanceMethodReturnNoneArgsRefString(_reference, __traits(identifier, method), args[0].reference, args[1]);
					}

					// executeInstanceMethodReturnNoneArgsRefBool
					else static if(is(ReturnType!method == void) && args.length == 2 && is(typeof(args[0]) : Object) && is(typeof(args[1]) == bool))
					{
						executeInstanceMethodReturnNoneArgsRefBool(_reference, __traits(identifier, method), args[0].reference, args[1]);
					}

					// executeInstanceMethodReturnNoneArgsRefInt
					else static if(is(ReturnType!method == void) && args.length == 2 && is(typeof(args[0]) : Object) && is(typeof(args[1]) == int))
					{
						executeInstanceMethodReturnNoneArgsRefInt(_reference, __traits(identifier, method), args[0].reference, args[1]);
					}

					// executeInstanceMethodReturnNoneArgsIntf
					else static if(is(ReturnType!method == void) && args.length == 1  && is(typeof(args[0]) == interface))
					{
						executeInstanceMethodReturnNoneArgsRef(_reference, __traits(identifier, method), (cast(TObject) args[0]).reference);
					}

					// executeInstanceMethodReturnNoneArgsString
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == string))
					{
						executeInstanceMethodReturnNoneArgsString(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsBool
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == bool))
					{
						executeInstanceMethodReturnNoneArgsBool(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsBoolBool
					else static if(is(ReturnType!method == void) && args.length == 2 && is(typeof(args[0]) == bool) && is(typeof(args[1]) == bool))
					{
						executeInstanceMethodReturnNoneArgsBoolBool(_reference, __traits(identifier, method), args[0], args[1]);
					}

					// executeInstanceMethodReturnNoneArgsInt
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == int))
					{
						executeInstanceMethodReturnNoneArgsInt(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsUInt
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == uint))
					{
						executeInstanceMethodReturnNoneArgsUInt(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsLong
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == long))
					{
						executeInstanceMethodReturnNoneArgsLong(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsULong
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == ulong))
					{
						executeInstanceMethodReturnNoneArgsULong(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsIntInt
					else static if(is(ReturnType!method == void) && args.length == 2 && is(typeof(args[0]) == int) && is(typeof(args[1]) == int))
					{
						executeInstanceMethodReturnNoneArgsIntInt(_reference, __traits(identifier, method), args[0], args[1]);
					}

					// executeInstanceMethodReturnNoneArgsIntRef
					else static if(is(ReturnType!method == void) && args.length == 2 && is(typeof(args[0]) == int) && is(typeof(args[1]) : Object))
					{
						executeInstanceMethodReturnNoneArgsIntRef(_reference, __traits(identifier, method), args[0], args[1].reference);
					}

					// executeInstanceMethodReturnNoneArgsFloat
					else static if(is(ReturnType!method == void) && args.length == 1 && is(typeof(args[0]) == float))
					{
						executeInstanceMethodReturnNoneArgsFloat(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnNoneArgsFloatFloatBool
					else static if(is(ReturnType!method == void) && args.length == 3 && is(typeof(args[0]) == float) && is(typeof(args[1]) == float) && is(typeof(args[2]) == bool))
					{
						executeInstanceMethodReturnNoneArgsFloatFloatBool(_reference, __traits(identifier, method), args[0], args[1], args[2]);
					}

					// executeInstanceMethodReturnNoneArgsNone
					else static if(is(ReturnType!method == void) && args.length == 0)
					{
						executeInstanceMethodReturnNoneArgsNone(_reference, __traits(identifier, method));
					}
					
					// executeInstanceMethodReturnStringArgsNone
					else static if(is(ReturnType!method == string) && args.length == 0)
					{
						return executeInstanceMethodReturnStringArgsNone(_reference, __traits(identifier, method));
					}

					// executeInstanceMethodReturnStringArgsInt
					else static if(is(ReturnType!method == string) && args.length == 1 && is(typeof(args[0]) == int))
					{
						return executeInstanceMethodReturnStringArgsInt(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnStringArgsIntInt
					else static if(is(ReturnType!method == string) && args.length == 2 && is(typeof(args[0]) == int) && is(typeof(args[1]) == int))
					{
						return executeInstanceMethodReturnStringArgsIntInt(_reference, __traits(identifier, method), args[0], args[1]);
					}

					// executeInstanceMethodReturnRefArgsNone
					else static if(is(ReturnType!method : Object) && args.length == 0)
					{
						auto resultReference = executeInstanceMethodReturnRefArgsNone(_reference, __traits(identifier, method));
						return new ReturnType!method(resultReference);
					}

					// executeInstanceMethodReturnRefArgsString
					else static if(is(ReturnType!method : Object) && args.length == 1 && is(typeof(args[0]) == string))
					{
						auto resultReference = executeInstanceMethodReturnRefArgsString(_reference, __traits(identifier, method), args[0]);
						return new ReturnType!method(resultReference);
					}

					// executeInstanceMethodReturnIntArgsString
					else static if(is(ReturnType!method == int) && args.length == 1 && is(typeof(args[0]) == string))
					{
						return executeInstanceMethodReturnIntArgsString(_reference, __traits(identifier, method), args[0]);
					}

					// executeInstanceMethodReturnIntArgsStringRef
					else static if(is(ReturnType!method == int) && args.length == 2 && is(typeof(args[0]) == string ) && is(typeof(args[1]) : Object))
					{
						return executeInstanceMethodReturnIntArgsStringRef(_reference, __traits(identifier, method), args[0], args[1].reference);
					}

					// executeInstanceMethodReturnFloatArgsNone
					else static if(is(ReturnType!method == float) && args.length == 0)
					{
						return executeInstanceMethodReturnFloatArgsNone(_reference, __traits(identifier, method));
					}

					// executeInstanceMethodReturnRefArgsInt
					else static if(is(ReturnType!method : Object) && args.length == 1 && is(typeof(args[0]) == int ))
					{
						auto resultReference =  executeInstanceMethodReturnRefArgsInt(_reference, __traits(identifier, method), args[0]);
						return new ReturnType!method(resultReference);
					}

					// executeInstanceMethodReturnRefArgsStringBool
					else static if(is(ReturnType!method : Object) && args.length == 2 && is(typeof(args[0]) == string) && is(typeof(args[1]) == bool ))
					{
						auto resultReference =  executeInstanceMethodReturnRefArgsStringBool(_reference, __traits(identifier, method), args[0], args[1]);
						return new ReturnType!method(resultReference);
					}

					// executeInstanceMethodReturnRefArgsStringIntBool
					else static if(is(ReturnType!method : Object) && args.length == 3 && is(typeof(args[0]) == string) && is(typeof(args[1]) == int ) && is(typeof(args[2]) == bool ))
					{
						auto resultReference =  executeInstanceMethodReturnRefArgsStringIntBool(_reference, __traits(identifier, method), args[0], args[1], args[2]);
						return new ReturnType!method(resultReference);
					}

					// executeInstanceMethodReturnLongArgsUByteArrLongLong
					else static if(is(ReturnType!method : long) && args.length == 3 && is(typeof(args[0]) == ubyte[]) && is(typeof(args[1]) == long ) && is(typeof(args[2]) == long ))
					{
						return executeInstanceMethodReturnLongArgsUByteArrLongLong(_reference, __traits(identifier, method), args[0], args[1], args[2]);
					}

					else
					{
						static assert(false, "Not implemented: " ~ fullyQualifiedName!method );
					} 
				}
				
				
				/*
				executeInstanceMethodReturnEnumArgsNone
				executeInstanceMethodReturnNoneArgsStructFloat
				executeInstanceMethodReturnNoneArgsStructStructFloat
				executeInstanceMethodReturnNoneArgsStructStructFloatRef
				executeInstanceMethodReturnNoneArgsRefStructStructFloatBoolean
				executeInstanceMethodReturnNoneArgsRefFloat
				executeInstanceMethodReturnNoneArgsFloatFloatFloatFloatFloat
				*/
			}
		}
	}
	
	import std.traits;
	
	this(void* reference)
	{
		super(reference);
	}

	this(DelphiObject obj)
	{
		super(obj.reference);
	}

	static foreach(memberName; __traits(derivedMembers, typeof(this))) {
		static if(isSomeFunction!(__traits(getMember, typeof(this), memberName)))
		{
			static foreach(oi, overload; __traits(getOverloads, typeof(this), memberName))
			{
				static if(!hasUDA!(overload, skip) && memberName != "__ctor")
				{
					mixin PascalImportImpl!(typeof(this), overload, oi);

					// Create for each object property a member variable for performance reasons
					// ...
				}
				
				
			}
		}
	}
}

void executeInstanceMethodReturnNoneArgsNone(void* reference, string name)
{
	alias extern(Windows) void function(void*, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsNone");
	auto fn = cast(FN) fp;
	fn(reference, pChar);
}

string executeInstanceMethodReturnEnumArgsNone(void* reference, string name)
{
	alias extern(Windows) void function(void*, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnEnumArgsNone");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

int executeInstanceMethodReturnIntArgsNone(void* reference, string name)
{
	alias extern(Windows) int function(void*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnIntArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

long executeInstanceMethodReturnLongArgsNone(void* reference, string name)
{
	alias extern(Windows) long function(void*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnLongArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

ulong executeInstanceMethodReturnULongArgsNone(void* reference, string name)
{
	alias extern(Windows) ulong function(void*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnULongArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

bool executeInstanceMethodReturnBoolArgsNone(void* reference, string name)
{
	alias extern(Windows) bool function(void*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

bool executeInstanceMethodReturnBoolArgsBool(void* reference, string name, bool b)
{
	alias extern(Windows) bool function(void*, char*, bool) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsBool");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, b);
}

bool executeInstanceMethodReturnBoolArgsInt(void* reference, string name, int i)
{
	alias extern(Windows) bool function(void*, char*, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsInt");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, i);
}

bool executeInstanceMethodReturnBoolArgsFloatFloat(void* reference, string name, float f1, float f2)
{
	alias extern(Windows) bool function(void*, char*, float, float) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsFloatFloat");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, f1, f2);
}

bool executeInstanceMethodReturnBoolArgsRef(void* reference, string name, void* reference2)
{
	alias extern(Windows) bool function(void*, char*, void*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsRef");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, reference2);
}

bool executeInstanceMethodReturnBoolArgsRefInt(void* reference, string name, void* reference2, int i1)
{
	alias extern(Windows) bool function(void*, char*, void*, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsRefInt");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, reference2, i1);
}

bool executeInstanceMethodReturnBoolArgsString(void* reference, string name, string value)
{
	alias extern(Windows) bool function(void*, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnBoolArgsString");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue);
}

int executeInstanceMethodReturnIntArgsString(void* reference, string name, string value)
{
	alias extern(Windows) int function(void*, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnIntArgsString");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue);
}

void executeInstanceMethodReturnNoneArgsString(void* reference, string name, string value)
{
	alias extern(Windows) void function(void*, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsString");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, pCharValue);
}

void executeInstanceMethodReturnNoneArgsBool(void* reference, string name, bool value)
{
	alias extern(Windows) void function(void*, char*, bool) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsBool");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value);
}

void executeInstanceMethodReturnNoneArgsBoolBool(void* reference, string name, bool b1, bool b2)
{
	alias extern(Windows) void function(void*, char*, bool, bool) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsBoolBool");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, b1, b2);
}

void executeInstanceMethodReturnNoneArgsInt(void* reference, string name, int value)
{
	alias extern(Windows) void function(void*, char*, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsInt");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value);
}

void executeInstanceMethodReturnNoneArgsUInt(void* reference, string name, uint value)
{
	alias extern(Windows) void function(void*, char*, uint) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsUInt");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value);
}

void executeInstanceMethodReturnNoneArgsLong(void* reference, string name, long value)
{
	alias extern(Windows) void function(void*, char*, long) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsLong");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value);
}

void executeInstanceMethodReturnNoneArgsULong(void* reference, string name, ulong value)
{
	alias extern(Windows) void function(void*, char*, ulong) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsULong");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value);
}

void executeInstanceMethodReturnNoneArgsIntInt(void* reference, string name, int value1, int value2)
{
	alias extern(Windows) void function(void*, char*, int, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsIntInt");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value1, value2);
}

void executeInstanceMethodReturnNoneArgsIntRef(void* reference, string name, int value, void* reference2)
{
	alias extern(Windows) void function(void*, char*, int, void*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsIntRef");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value, reference2);
}

void executeInstanceMethodReturnNoneArgsFloat(void* reference, string name, float value)
{
	alias extern(Windows) void function(void*, char*, float) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsFloat");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, value);
}

void executeInstanceMethodReturnNoneArgsFloatFloatBool(void* reference, string name, float f1, float f2, bool b)
{
	alias extern(Windows) void function(void*, char*, float, float, bool) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsFloatFloatBool");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, f1, f2, b);
}

void* executeInstanceMethodReturnRefArgsNone(void* reference, string name)
{
	alias extern(Windows) void* function(void*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnRefArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

void* executeInstanceMethodReturnRefArgsInt(void* reference, string name, int i)
{
	alias extern(Windows) void* function(void*, char*, int) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnRefArgsInt");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, i);
}

void* executeInstanceMethodReturnRefArgsStringBool(void* reference, string name, string s, bool b)
{
	alias extern(Windows) void* function(void*, char*, char*, bool) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(s);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnRefArgsStringBool");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue, b);
}

void* executeInstanceMethodReturnRefArgsStringIntBool(void* reference, string name, string s, int i, bool b)
{
	alias extern(Windows) void* function(void*, char*, char*, int, bool) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(s);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnRefArgsStringIntBool");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue, i, b);
}

void executeInstanceMethodReturnNoneArgsRef(void* reference, string name, void* reference2)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsRef");
	alias extern(Windows) void function(void*, char*, void*) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2);
}

void executeInstanceMethodReturnNoneArgsRefString(void* reference, string name, void* reference2, string s)
{
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(s);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsRefString");
	alias extern(Windows) void function(void*, char*, void*, char*) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, pCharValue);
}

void executeInstanceMethodReturnNoneArgsRefBool(void* reference, string name, void* reference2, bool b)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsRefBool");
	alias extern(Windows) void function(void*, char*, void*, bool) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, b);
}

void executeInstanceMethodReturnNoneArgsRefInt(void* reference, string name, void* reference2, int i)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsRefInt");
	alias extern(Windows) void function(void*, char*, void*, int) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, i);
}

void executeInstanceMethodReturnNoneArgsStructFloat(void* reference, string name, void* reference2, float f)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsStructFloat");
	alias extern(Windows) void function(void*, char*, void*, float) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, f);
}

void executeInstanceMethodReturnNoneArgsStructStructFloat(void* reference, string name, void* reference2, void* reference3, float f)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsStructStructFloat");
	alias extern(Windows) void function(void*, char*, void*, void*, float) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, reference3, f);
}

void executeInstanceMethodReturnNoneArgsStructStructFloatRef(void* reference, string name, void* reference2, void* reference3, float f, void* reference4)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsStructStructFloatRef");
	alias extern(Windows) void function(void*, char*, void*, void*, float, void*) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, reference3, f, reference4);
}

void executeInstanceMethodReturnNoneArgsRefStructStructFloatBoolean(void* reference, string name, void* reference2, void* reference3, void* reference4, float f, bool b)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsRefStructStructFloatBoolean");
	alias extern(Windows) void function(void*, char*, void*, void*, void*, float, bool) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2, reference3, reference4, f, b);	
}

void executeInstanceMethodReturnNoneArgsRefFloat(void* reference, string name, void* reference2, float f)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsRefFloat");
	alias extern(Windows) void function(void*, char*, void*, float) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, reference2,f);
}

void executeInstanceMethodReturnNoneArgsFloatFloatFloatFloatFloat(void* reference, string name, float f1, float f2, float f3, float f4, float f5)
{
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnNoneArgsFloatFloatFloatFloatFloat");
	alias extern(Windows) void function(void*, char*, float, float, float, float, float) FN;
	auto fn = cast(FN) fp;
	fn(reference, pCharName, f1, f2, f3, f4, f5);
}

void* executeInstanceMethodReturnRefArgsString(void* reference, string name, string value)
{
	alias extern(Windows) void* function(void*, char*, char*) FN;
	
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnRefArgsString");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue);
}

string executeInstanceMethodReturnStringArgsNone(void* reference, string name)
{
	alias extern(Windows) void function(void*, char*, out BSTR) FN;
	
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnStringArgsNone_Out_String");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pCharName, bStr);
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	return s;
}

string executeInstanceMethodReturnStringArgsInt(void* reference, string name, int i)
{
	alias extern(Windows) void function(void*, char*, int, out BSTR) FN;
	
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnStringArgsInt_Out_String");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pCharName, i, bStr);
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	return s;
}

string executeInstanceMethodReturnStringArgsIntInt(void* reference, string name, int i1, int i2)
{
	alias extern(Windows) void function(void*, char*, int, int, out BSTR) FN;
	
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnStringArgsIntInt_Out_String");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pCharName, i1, i2, bStr);
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	return s;
}

int executeInstanceMethodReturnIntArgsStringRef(void* reference, string name, string value, void* r)
{
	alias extern(Windows) int function(void*, char*, char*, void*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnIntArgsStringRef");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, pCharValue, r);
}

float executeInstanceMethodReturnFloatArgsNone(void* reference, string name)
{
	alias extern(Windows) float function(void*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnFloatArgsNone");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName);
}

long executeInstanceMethodReturnLongArgsUByteArrLongLong(void* reference, string name, ubyte[] arr, long l1, long l2)
{
	// Works only for 64
	alias extern(Windows) long function(void*, char*, ubyte* arr, ulong, long, long ) FN;
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeInstanceMethodReturnLongArgsUByteArrLongLong");
	auto fn = cast(FN) fp;
	return fn(reference, pCharName, arr.ptr, arr.length, l1, l2);
}

void* executeClassMethodReturnRefArgsString(string qualifiedName, string name, string value)
{
	alias extern(Windows) void* function(char*, char*, char*) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsString");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, pCharValue);
}

void* executeClassMethodReturnRefArgsNone(string qualifiedName, string name)
{
	alias extern(Windows) void* function(char*, char*) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsNone");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName);
}

void executeClassMethodReturnNoneArgsNone(string qualifiedName, string name)
{
	alias extern(Windows) void function(char*, char*) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnNoneArgsNone");
	auto fn = cast(FN) fp;
	fn(pCharQualifiedName, pCharName);
}

void* executeClassMethodReturnRefArgsRef(string qualifiedName, string name, void* reference)
{
	alias extern(Windows) void* function(char*, char*, void*) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsRef");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, reference);
}

void* executeClassMethodReturnRefArgsIntInt(string qualifiedName, string name, int i1, int i2)
{
	alias extern(Windows) void* function(char*, char*, int, int) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsIntInt");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, i1, i2);
}

void* executeClassMethodReturnRefArgsIntUInt(string qualifiedName, string name, int i1, uint i2)
{
	alias extern(Windows) void* function(char*, char*, int, uint) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsIntUInt");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, i1, i2);
}

void* executeClassMethodReturnRefArgsRefRefRefBool(string qualifiedName, string name, void* ref1, void* ref2, void* ref3, bool b)
{
	alias extern(Windows) void* function(char*, char*, void*, void*, void*, bool) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsRefRefRefBool");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, ref1, ref2, ref3, b);
}

void executeClassMethodReturnNoneArgsRefRef(string qualifiedName, string name, void* ref1, void* ref2)
{
	alias extern(Windows) void function(char*, char*, void*, void*) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnNoneArgsRefRef");
	auto fn = cast(FN) fp;
	fn(pCharQualifiedName, pCharName, ref1, ref2);
}

private BSTR allocateBSTR(string s)
{
	wstring ws = s.to!wstring;
	return allocateBSTR(ws);
}

private BSTR allocateBSTR(wstring ws)
{
	return SysAllocStringLen(ws.ptr, cast(UINT) ws.length);
}

void executeClassMethodReturnNoneArgsString(string qualifiedName, string name, string value)
{
	alias extern(Windows) void function(char*, char*, BSTR) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnNoneArgsString");
	auto fn = cast(FN) fp;
	
	BSTR bStr = allocateBSTR(value);
	fn(pCharQualifiedName, pCharName, bStr);
	SysFreeString(bStr);
}

bool executeClassMethodReturnBoolArgsString(string qualifiedName, string name, string value)
{
	alias extern(Windows) bool function(char*, char*, BSTR) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnNoneArgsString");
	auto fn = cast(FN) fp;
	
	BSTR bStr = allocateBSTR(value);
	bool result = fn(pCharQualifiedName, pCharName, bStr);
	SysFreeString(bStr);
	return result;
}

int executeClassMethodReturnIntArgsNone(string qualifiedName, string name)
{
	alias extern(Windows) int function(char*, char*) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnIntArgsNone");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName);
}

string executeClassMethodReturnStringArgsNone(string qualifiedName, string name)
{
	alias extern(Windows) void function(char*, char*, out BSTR) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnNoneArgs_Out_String");
	auto fn = cast(FN) fp;

	BSTR bStr;
	fn(pCharQualifiedName, pCharName, bStr);
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	return s;
}

string executeClassMethodReturnStringArgsStringStringString(string qualifiedName, string name, string v1, string v2, string v3)
{
	alias extern(Windows) void function(char*, char*, BSTR, BSTR, BSTR, out BSTR) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnNoneArgsStringStringString_Out_String");
	auto fn = cast(FN) fp;

	BSTR bStr1 = allocateBSTR(v1);
	BSTR bStr2 = allocateBSTR(v2);
	BSTR bStr3 = allocateBSTR(v3);
	
	BSTR bStr;
	fn(pCharQualifiedName, pCharName, bStr1, bStr2, bStr3, bStr);
	SysFreeString(bStr1);
	SysFreeString(bStr2);
	SysFreeString(bStr3);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

void* executeClassMethodReturnRefArgsRefNativeInt(string qualifiedName, string name, void* reference, ptrdiff_t i)
{
	alias extern(Windows) void* function(char*, char*, void*, ptrdiff_t) FN;
	
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnRefArgsRefNativeInt");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, reference, i);
}

void* executeClassMethodReturnStructArgsFloatFloatFloatFloat(string qualifiedName, string name, float f1, float f2, float f3, float f4)
{
	alias extern(Windows) void* function(char*, char*, float, float, float, float) FN;
	auto pCharQualifiedName = toUTFz!(char*)(qualifiedName);
	auto pCharName = toUTFz!(char*)(name);
	FARPROC fp = GetProcAddress(dbdLibrary.handle, "executeClassMethodReturnStructArgsFloatFloatFloatFloat");
	auto fn = cast(FN) fp;
	return fn(pCharQualifiedName, pCharName, f1, f2, f3, f4);
}