public static class SquareRoot
{
    public static int Root(int number)
    {
        int lowerBound = 0;
        int upperBound = number + 1;
        while (lowerBound != upperBound - 1)
        {
            int candidate = (lowerBound + upperBound) / 2;
            if (candidate * candidate <= number)
            {
                lowerBound = candidate;
            }
            else
            {
                upperBound = candidate;
            }
        }
        return lowerBound;
    }
}
