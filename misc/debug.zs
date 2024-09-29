class Debug {
    static void print(string msg) {
        console.printf(msg);
    }

    static void tprint(string msg) {
        console.printf("Time "..MSTime()..": "..msg);
    }

    static void panic(string msg = "Debug panic called.") {
        ThrowAbortException(msg);
    }

    static void panicUnimplemented(Object caller) {
        ThrowAbortException("Something is unimplemented in "..caller.GetClassName());
    }

    static string intArrToString(array <int> arr) {
        if (arr.Size() == 0) {
            return "[]";
        }
        let res = "[";
        for (let i = 0; i < arr.Size() - 1; i++) {
            res = res..arr[i]..", ";
        }
        res = res..arr[arr.Size()-1].."]";
        return res;
    }
}