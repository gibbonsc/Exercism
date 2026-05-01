public static class Darts
{
    public static int Score(double x, double y)
    {
        int result = 0;
        double distSq = x * x + y * y;
        if (distSq <= 1)
        {
            result = 10;
        }
        else if (distSq <= 25)
        {
            result = 5;
        }
        else if (distSq <= 100)
        {
            result = 1;
        }
        return result;
    }
}
