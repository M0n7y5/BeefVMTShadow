using System.Collections;
using System;
using System.Interop;
using static System.Windows;


// Ported from https://github.com/thamelodev/VShadow
namespace VMTShadowBeef
{
	class VMTObjectManager
	{
		void* _ObjectPointer;
		void** _ObjectVTable;
		void** _ObjectVTableFake;
		int _ObjectVTableSize;

		Dictionary<int, void*> _Hooks = new Dictionary<int, void*>() ~ delete _;
		uint8[] buffer ~ delete _;

		public this(void* object)
		{
			_ObjectPointer = object;
			_ObjectVTable = ((void**)object);
			_ObjectVTableSize = GetFunctionCount();

			buffer = new uint8[_ObjectVTableSize];

			for(int i = 0; i <= _ObjectVTableSize; ++i)
			{
				_ObjectVTableFake[i] = _ObjectVTable[i];
			}

			*((void**)object) = _ObjectVTableFake;
		}

		private int GetFunctionCount()
		{
			MEMORY_BASIC_INFORMATION mbi = default;
			int i = 0;

			MemProtect executableFlags = .PAGE_EXECUTE | .PAGE_EXECUTE_READ | .PAGE_EXECUTE_READWRITE | .PAGE_EXECUTE_WRITECOPY;

			while (VirtualQuery(((void**)_ObjectVTable)[i], &mbi, sizeof(MEMORY_BASIC_INFORMATION)) != 0)
			{
				if((mbi.State != .MEM_COMMIT) ||
					(mbi.Protect.HasFlag(.PAGE_GUARD | .PAGE_NOACCESS)) ||
					!(mbi.Protect.HasFlag(executableFlags)))
				{
					break;
				}

				i++;
			}

			return i;
		}

		public VMTHook Hook(int index, void* hookFunction)
		{
			void* _oFunc = *(void**)_ObjectVTableFake[index];

			*(void**)_ObjectVTableFake[index] = hookFunction;

			_Hooks.Add(index, _oFunc);



			return default;
		}


		[CLink]// Kernel32.lib
		public static extern c_uint VirtualQuery(void* addr, MEMORY_BASIC_INFORMATION* mbi, c_uint lenght);

	}
}
