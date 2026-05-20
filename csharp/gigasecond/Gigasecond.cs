public static class Gigasecond
{
    public static DateTime Add(DateTime moment)
        => moment + new TimeSpan((long)10_000_000 * 1_000_000_000);
        // ten million ticks per second
        //    * one billion ticks per gigasecond
}
