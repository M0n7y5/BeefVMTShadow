namespace VMTShadowBeef
{
	struct VMTHook
	{
		public void* OriginalFunction;
		public void* HookedFunction;

		public this(void* oFunc, void* hFunc)
		{
			this.OriginalFunction = oFunc;
			this.HookedFunction = hFunc;
		}

		public void Unhook() mut
		{
			//HookedFunction = &OriginalFunction;
		}
	}
}
