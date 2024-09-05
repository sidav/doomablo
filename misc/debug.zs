class Debug {
    static void print(string msg) {
        console.printf(msg);
    }

    static void tprint(string msg) {
        console.printf("Time "..MSTime()..": "..msg);
    }

    static void panic(string msg) {
        ThrowAbortException(msg);
    }

    static void panicUnimplemented(Object caller) {
        ThrowAbortException("Something is unimplemented in "..caller.GetClassName());
    }
}