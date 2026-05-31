public static class SumOfMultiples
{
    public static int Sum(IEnumerable<int> multiples, int max)
    {
        List<int> a = [];
        for (int c = 1; c < max; c++)
        {
            foreach (int d in multiples)
            {
                if (d == 0) { continue; }
                if (c % d == 0)
                {
                    a.Add(c);
                    break;
                }
            }
        }
        return a.Sum();
    }
}
