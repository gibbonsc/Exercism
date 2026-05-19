static class Appointment
{
    public static DateTime Schedule(string appointmentDateDescription)
    {
    // Studied about DateTime.TryParse static method:
    // https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tryparse
        DateTime dtValue;
        if (DateTime.TryParse(appointmentDateDescription, out dtValue))
            return dtValue;
        else
            throw new FormatException(
                $"Invalid DateTime format: '{appointmentDateDescription}'"
                );
    }

    public static bool HasPassed(DateTime appointmentDate)
        => appointmentDate < DateTime.Now;

    public static bool IsAfternoonAppointment(DateTime appointmentDate)
        => 12 <= appointmentDate.Hour && appointmentDate.Hour < 18;

    public static string Description(DateTime appointmentDate)
    // Studied about DateTime.ToString instance method:
    // https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tostring
        => "You have an appointment on " +
            $"{appointmentDate.ToString("G")}.";

    public static DateTime AnniversaryDate()
        => new(DateTime.Now.Year, 9, 15, 0, 0, 0);
}
