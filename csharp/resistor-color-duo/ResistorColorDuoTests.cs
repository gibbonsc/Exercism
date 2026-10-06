public class ResistorColorDuoTests
{
    [Fact]
    public void Brown_and_black()
    {
        Assert.Equal(10, ResistorColorDuo.Value(["brown", "black"]));
    }

    [Fact]
    public void Blue_and_grey()
    {
        Assert.Equal(68, ResistorColorDuo.Value(["blue", "grey"]));
    }

    [Fact]
    public void Yellow_and_violet()
    {
        Assert.Equal(47, ResistorColorDuo.Value(["yellow", "violet"]));
    }

    [Fact]
    public void White_and_red()
    {
        Assert.Equal(92, ResistorColorDuo.Value(["white", "red"]));
    }

    [Fact]
    public void Orange_and_orange()
    {
        Assert.Equal(33, ResistorColorDuo.Value(["orange", "orange"]));
    }

    [Fact]
    public void Ignore_additional_colors()
    {
        Assert.Equal(51, ResistorColorDuo.Value(["green", "brown", "orange"]));
    }

    [Fact]
    public void Black_and_brown_one_digit()
    {
        Assert.Equal(1, ResistorColorDuo.Value(["black", "brown"]));
    }
}
