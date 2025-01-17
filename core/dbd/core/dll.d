module dbd.core.dll;

pragma(lib, "OleAut32.lib");

import core.sys.windows.windows;
import core.runtime;

enum nil = null;

struct DBDLibrary
{
	static HMODULE handle;
	alias handle this;
	
	void load(string filePath)
	{
		if (handle)
			Runtime.unloadLibrary(handle);
		
		handle = cast(HMODULE) Runtime.loadLibrary(filePath);
		assert(handle !is null);
	}
	
	static void unload()
	{
		if (handle)
		{
			//Runtime.unloadLibrary(handle);
			handle = null;
		}
			
	}

	static ~this()
	{
		unload();
	}
}

DBDLibrary dbdLibrary;