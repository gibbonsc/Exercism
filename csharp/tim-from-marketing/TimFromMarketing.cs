static class Badge
{
    public static string Print(int? id, string name, string? department)
    {
        string returnId = "";
        if (id != null)
        {
            returnId = $"[{id}] - ";
        }
        return returnId + $"{name} - {(department ?? "owner").ToUpper()}";
    }
}
