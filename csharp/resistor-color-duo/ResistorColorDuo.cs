public static class ResistorColorDuo
{
    private static string[] _colorBands = [
        "black", "brown", "red", "orange", "yellow",
        "green", "blue", "violet", "grey", "white"
    ];

    public static int ColorCode(string color)
        => _colorBands.IndexOf(color);

    public static int Value(string[] colors)
        => ColorCode(colors[1]) + ColorCode(colors[0]) * 10;
}
