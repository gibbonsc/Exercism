public static class ResistorColor
{
    private static string[] _colorBands = [
        "black", "brown", "red", "orange", "yellow",
        "green", "blue", "violet", "grey", "white"
    ];

    public static int ColorCode(string color)
        => _colorBands.IndexOf(color);  // IndexOf searches the array

    public static string[] Colors()
        => _colorBands;
}
