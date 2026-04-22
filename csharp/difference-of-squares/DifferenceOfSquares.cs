public static class DifferenceOfSquares
{
    public static int CalculateSquareOfSum(int max)
    {
        int result = 0;
        for (int i = 0; i <= max; i++)
        {
            result += i;
        }
        return result * result;
    }

    public static int CalculateSumOfSquares(int max)
    {
        int result = 0;
        for (int i = 0; i <= max; i++)
        {
            result += i * i;
        }
        return result;
    }

    public static int CalculateDifferenceOfSquares(int max)
    {
        return CalculateSquareOfSum(max) - CalculateSumOfSquares(max);
    }
}