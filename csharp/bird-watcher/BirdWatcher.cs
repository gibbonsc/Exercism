class BirdCount
{
    private int[] birdsPerDay;

    public BirdCount(int[] birdsPerDay)
    {
        this.birdsPerDay = birdsPerDay;
    }

    public static int[] LastWeek()
        => [0, 2, 5, 3, 7, 8, 4];

    public int Today()
        => this.birdsPerDay[(this.birdsPerDay.Length) - 1];

    public void IncrementTodaysCount()
    {
        this.birdsPerDay[(this.birdsPerDay.Length) - 1] += 1;
    }

    public bool HasDayWithoutBirds()
        => this.birdsPerDay.Contains(0);

    public int CountForFirstDays(int numberOfDays)
    {
        int total, i;
        for (total = i = 0; i < numberOfDays; i++)
            total += this.birdsPerDay[i];
        return total;
    }

    public int BusyDays()
    {
        int counter, i;
        for (counter = i = 0; i < (this.birdsPerDay.Length); i++)
            if (this.birdsPerDay[i] >= 5)
                counter++;
        return counter;
    }
}
