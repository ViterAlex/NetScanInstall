$dir = Split-Path $MyInvocation.MyCommand.Path
Push-Location $dir
..\HP_install.psm1
#.\gui_events.ps1
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  



############################################## Методы
function searchButton_click($sender, $e){
    Run-Install -printerIP $txt_ip.Text -driverpath $txt_path.Text -printerName  $cmb_PrinterNames.SelectedItem
}

function selectPath_click($sender, $e){
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter="Файлы драйверов|*.inf|Все файлы|*.*"
    $dlg.InitialDirectory = Get-Location
    $result = $dlg.ShowDialog()
    if($result -eq [System.Windows.Forms.DialogResult]::OK){
        $txt_path.Text = $dlg.FileName
    }
}

############################################## end functions
############################################## Создание формы
$Form = New-Object System.Windows.Forms.Form    
$Form.AutoSize = $True  
$Form.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink

############################################## Контейнер для контролов
$flp = New-Object System.Windows.Forms.FlowLayoutPanel
$flp.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
$flp.Dock = [System.Windows.Forms.DockStyle]::Fill
$flp.AutoSize =$True
$Form.controls.Add($flp)
##############################################
############################################## Выбор файла драйвера
$flp1 = New-Object System.Windows.Forms.FlowLayoutPanel
$flp1.FlowDirection = [System.Windows.Forms.FlowDirection]::LeftToRight
$flp1.WrapContents = $false
$flp1.AutoSize = $True

$txt_path = New-Object System.Windows.Forms.TextBox
$txt_path.Width = 200

$btn_selectPath = New-Object System.Windows.Forms.Button
$btn_selectPath.Text = "Выбрать файл драйвера..."
$btn_selectPath.AutoSize = $True
$btn_selectPath.Add_Click({selectPath_click})

$flp1.Controls.AddRange(@($txt_path,$btn_selectPath))
##############################################
############################################## Выбор имени принтера
$flp2 = New-Object System.Windows.Forms.FlowLayoutPanel
$flp2.AutoSize = $true

$lbl = New-Object System.Windows.Forms.Label
$lbl.Text="Имя принтера:"
$lbl.AutoSize = $True
$lbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft

$cmb_PrinterNames = New-Object System.Windows.Forms.ComboBox
$cmb_PrinterNames.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cmb_PrinterNames.Size = New-Object System.Drawing.Size(180,20) 
$cmb_PrinterNames.DropDownHeight = 200 
foreach ($name in Get-printerNames) {
    $cmb_PrinterNames.Items.Add($name)
} #end foreach
$cmb_PrinterNames.SelectedIndex=0


$flp2.Controls.AddRange(@($lbl,$cmb_PrinterNames)) 
##############################################

############################################## IP-адрес
$flp3 = New-Object System.Windows.Forms.FlowLayoutPanel
$flp3.AutoSize = $true

$lbl_ip = New-Object System.Windows.Forms.Label
$lbl_ip.Text="IP:"
$lbl_ip.AutoSize = $True
$lbl_ip.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft

$txt_ip = New-Object System.Windows.Forms.TextBox
$txt_ip.Size = New-Object System.Drawing.Size(100,20)
$txt_ip.Text="192.168.23."

$flp3.Controls.AddRange(@($lbl_ip,$txt_ip)) 
##############################################

$flp.Controls.AddRange(@($flp1, $flp2, $flp3))


$Form.controls.Add($flp)
##############################################
############################################## Start buttons
$Button = New-Object System.Windows.Forms.Button 
$Button.AutoSize = $True
$Button.Text = "Установить" 
$Button.Add_Click({searchButton_click}) 
$flp.Controls.Add($Button) 
############################################## end buttons

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
Pop-Location