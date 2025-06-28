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

    static string IntPromilleAsSignedPercentageString(int promille) {
        if (promille < 0)
            return String.format("%.1f%%", double(promille)/10.0);
        return String.format("+%.1f%%", double(promille)/10.0);
    }

    // If we need 12.34, then value is 1234 and divisor is 100
    // If we need 123.4, then value is 1234 and divisor is 10
    static string FixedPointIntAsString(int value, int divisor) {
        return String.format("%.1f", double(value)/double(divisor));
    }

    static string FloatToSignedStr(float v) {
        if (v > 0) {
            return String.Format("+%.1f", v);
        }
        return String.Format("%.1f", v);
    }

    static string IntToSignedStr(int v) {
        if (v > 0) {
            return "+"..v;
        }
        return ""..v;
    }
}