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
            return String.format("%.1f", double(promille)/10.0);
        return String.format("+%.1f", double(promille)/10.0);
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