using System.Interop;
using System;

namespace VMTShadowBeef
{
	enum MemState : c_uint
	{
		MEM_COMMIT = 0x1000,
		MEM_FREE = 0x10000,
		MEM_RESERVE = 0x2000
	}

	enum MemType : c_uint
	{
		MEM_IMAGE = 0x1000000,
		MEM_MAPPED = 0x40000,
		MEM_PRIVATE = 0x20000
	}

	enum MemProtect : c_uint
	{
		PAGE_EXECUTE = 0x10,
		PAGE_EXECUTE_READ = 0x20,
		PAGE_EXECUTE_READWRITE = 0x40,
		PAGE_EXECUTE_WRITECOPY = 0x80,
		PAGE_NOACCESS = 0x01,
		PAGE_GUARD = 0x100
	}

	[CRepr]
	struct MEMORY_BASIC_INFORMATION// 32Bit
	{
		public void* BaseAddress;
		public void* AllocationBase;
		public c_uint AllocationProtect;
		public c_short PartitionId;
		public c_uint RegionSize;
		public MemState State;
		public MemProtect Protect;
		public MemType Type;
	}
}
