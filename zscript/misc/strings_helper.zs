class StringsHelper {
    static string Capitalize(string s) {
        let firstChar = s.Left(1);
        firstChar = firstChar.MakeUpper();
        return firstChar..s.Mid(1);
    }

    static string FormatFloat(float f, float minValToHideFraction) {
        if (f < minValToHideFraction) {
            return String.Format("%.1f", f);
        }
        return String.Format("%.0f", f);
    }
}