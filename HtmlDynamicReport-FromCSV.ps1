Function Set-AlternatingRows { 
        [CmdletBinding()] 
        Param( [Parameter(Mandatory=$True,ValueFromPipeline=$True)] 
        [object[]]$Lines, [Parameter(Mandatory=$True)] 
        [string]$CSSEvenClass, [Parameter(Mandatory=$True)] 
        [string]$CSSOddClass ) 
        
  Begin { $ClassName = $CSSEvenClass }
        Process { ForEach ($Line in $Lines) {	$Line = $Line.Replace("<tr>","<tr class=""$ClassName"">") 
             
  If ($ClassName -eq $CSSEvenClass) {	$ClassName = $CSSOddClass } 
  Else {	$ClassName = $CSSEvenClass } Return $Line } } }     

# --------------------------------------------------------------------------------------
# add +/- character to fragment. toggle all section clicking on it
$ToggleALL= "Inactive Computers"
$fragments="<a href='javascript:toggleAll();' title='Click to toggle all sections'>+/-</a>"

# create DIV seciont with name desired
$Text = "Inactive Computers"
$div = $Text.Replace(" ","_")
# Make the DIV toggle clicking on $text
$fragments+= "<a href='javascript:toggleDiv(""$div"");' title='click to collapse or expand this section'><h2>$Text</h2></a><div id=""$div"">"
# If there are multiple section DIV , must uncomment to toggle that specified section
#$fragments+="</div>"

# CSS Style starts Here
# Header starts from here (include Javascript code to toggle)
$head = @"
<Title>System Report - Inactive computers </Title>
<style>
        body { background-color:#E5E4E2;font-family:Monospace;font-size:10pt; }
        td, th { border:0px solid black; border-collapse:collapse;white-space:pre; }
        th { color:white;background-color:black; }
        table, tr, td, th { padding: 2px; margin: 0px ;white-space:pre; }
        tr:nth-child(odd) {background-color: lightgray}
        table { width:95%;margin-left:5px; margin-bottom:20px;}

    h2 {font-family:Tahoma;color:#6D7B8D;}
        .alert {color: red;}
        .footer { color:green;margin-left:10px;font-family:Tahoma;font-size:8pt;font-style:italic;}
        .transparent {background-color:#E5E4E2;}
 </style>

<script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js'>
</script>
<script type='text/javascript'>
function toggleDiv(divId) {
   `$("#"+divId).toggle();
}
function toggleAll() {
    var divs = document.getElementsByTagName('div');
    for (var i = 0; i < divs.length; i++) {
        var div = divs[i];
        `$("#"+div.id).toggle();
    }
}
</script>
 
"@

    
    # Import the Source and set the reportPath
    $reportpath= "C:\Users\SSCMLC\Documents\Script\Powershell\send-email"
    $Data = Import-Csv "C:\Users\SSCMLC\Documents\Script\Powershell\Txt for scripts\InactiveComputers.csv"
    
    <#
    # create the report elements joining Head and Fragments 
    $join = @{ 
    head = $head 
    body = $fragments
    }
    #>

    # choose type report
    # standard: use css style above
      $HTML = $Data | ConvertTo-Html -Head $head -Body $fragments | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd 
    # Dynamic Jquery: requires enhancedHTML2 module
    # Remove-Module EnhancedHTML2
    # Import-Module EnhancedHTML2
    # $HTMLfragment = $Data |ConvertTo-EnhancedHTMLFragment -EvenRowCssClass even -OddRowCssClass odd -As Table -MakeTableDynamic
    # $HTML= ConvertTo-EnhancedHTML -HTMLFragments $HTMLfragment -CssStyleSheet $Style -jQueryURI 'http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.2.min.js' -jQueryDataTableURI 'http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/jquery.dataTables.min.js'
    
    # Save Report
    $HTML | Out-File -Encoding ascii -Append "$ReportPath\ReportFromCSV.html"