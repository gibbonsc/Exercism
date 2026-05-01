class RemoteControlCar
{
    private int _metersDriven;

    public static RemoteControlCar Buy()
    {
        RemoteControlCar result = new();
        result._metersDriven = 0;
        return result;
    }

    public string DistanceDisplay()
        => $"Driven {_metersDriven} meters";

    public string BatteryDisplay()
    {
        string result = "Battery ";
        if (_metersDriven >= 2000)
            result += "empty";
        else
            result += $"at {(2000 - _metersDriven) / 20}%";
        return result;
    }

    public void Drive()
    {
        if (_metersDriven < 2000)
            _metersDriven += 20;
    }
}
