public class Player
{
    Random _die = new Random();

    public int RollDie()
    {
        return _die.Next(1,19);
    }

    public double GenerateSpellStrength()
    {
        return 100 * _die.NextDouble();
    }
}
