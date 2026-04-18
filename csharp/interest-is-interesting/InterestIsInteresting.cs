static class SavingsAccount
{
    public static float InterestRate(decimal balance)
    {
        if (balance < 0) { return 3.213f; }
        else if (balance < 1_000m) { return 0.5f; }
        else if (balance < 5_000m) { return 1.621f; }
        return 2.475f;
    }

    public static decimal Interest(decimal balance)
        => balance * (decimal)InterestRate(balance) / 100.0m;

    public static decimal AnnualBalanceUpdate(decimal balance)
        => balance + Interest(balance);

    public static int YearsBeforeDesiredBalance(decimal balance, decimal targetBalance)
    {
        int result = 0;
        if (balance >= targetBalance) { result = 0; }
        else
        {
            do
            {
                balance = AnnualBalanceUpdate(balance);
                result += 1;
            } while (balance < targetBalance);
        }
        return result;
    }
}
