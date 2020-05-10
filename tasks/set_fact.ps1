# Plan: Creates a JSON fact on a target system.
Param(
  $fact_name,
  $fact_value
)

$facts_path = "C:\programdata\puppetlabs\facter\facts.d"
$file_path = "${facts_path}\\${fact_name}.json"

If (!(Test-Path $facts_path)) { New-Item -Path $facts_path -ItemType Directory -Force}

function create_fact(){
    Param(
        $fact_name,
        $fact_value
    )
    $data = (@{ $fact_name = $fact_value } | ConvertTo-Json)
    #New-Item -ItemType File -Path $file_path
    [IO.File]::WriteAllLines($file_path, $data)
}

create_fact $fact_name $fact_value