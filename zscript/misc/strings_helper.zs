class StringsHelper {
    static string Capitalize(string s) {
        let firstChar = s.Left(1);
        firstChar = firstChar.MakeUpper();
        return firstChar..s.Mid(1);
    }
}