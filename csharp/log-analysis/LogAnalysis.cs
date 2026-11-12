public static class LogAnalysis 
{
    public static string SubstringAfter(this string str, string d)
    {
        int idx = str.IndexOf(d);
        return str.Substring(idx + d.Length);
    }

    public static string SubstringBetween(this string str, string dL, string dR)
    {
        string after = SubstringAfter(str, dL);
        int idx = after.IndexOf(dR);
        return after.Substring(0, idx);
    }

    public static string Message(this string str)
    {
        return SubstringAfter(str, "]: ");
    }

    // TODO: define the 'LogLevel()' extension method on the `string` type
    public static string LogLevel(this string str)
    {
        return SubstringBetween(str, "[", "]");
    }
}
