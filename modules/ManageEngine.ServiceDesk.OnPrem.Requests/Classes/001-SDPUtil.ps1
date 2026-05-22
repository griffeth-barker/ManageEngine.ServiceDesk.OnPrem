class SDPUtil {
    static [nullable[datetime]] ParseTime([object]$time) {
        if ($null -eq $time -or $null -eq $time.value) { return $null }
        return [DateTimeOffset]::FromUnixTimeMilliseconds([long]$time.value).UtcDateTime
    }
}
