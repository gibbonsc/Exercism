public static class ReverseString
{
    public static string Reverse(string input)
    {
        string result = "", ch;
        for (int i = input.Length; i > 0; i--)
        {
            ch = input.Substring(i - 1, 1);
            result += ch;
        }
        return result;
    }
}
