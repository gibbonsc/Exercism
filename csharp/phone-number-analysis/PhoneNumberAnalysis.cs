public static class PhoneNumber
{
    public static (bool IsNewYork, bool IsFake, string LocalNumber) Analyze(string phoneNumber)
    {
        (string areaCode, string prefix, string last4) =
            (phoneNumber.Substring(0,3), phoneNumber.Substring(4,3), phoneNumber.Substring(8,4));
        return (areaCode == "212", prefix == "555", last4);
    }

    public static bool IsFake((bool IsNewYork, bool IsFake, string LocalNumber) phoneNumberInfo)
    {
        return phoneNumberInfo.IsFake;
    }
}
