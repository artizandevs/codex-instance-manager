[xml]$markup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Codex Instance Manager" Width="920" Height="680" MinWidth="850" MinHeight="630" WindowStartupLocation="CenterScreen" Background="#11181C" Foreground="#EBF1F3" FontFamily="Segoe UI" FontSize="14">
 <Window.Resources>
  <Style TargetType="TextBox"><Setter Property="Background" Value="#202B32"/><Setter Property="Foreground" Value="#EBF1F3"/><Setter Property="BorderBrush" Value="#3B4B54"/><Setter Property="Padding" Value="10,7"/><Setter Property="MinHeight" Value="36"/><Setter Property="VerticalContentAlignment" Value="Center"/></Style>
  <Style TargetType="ComboBox"><Setter Property="MinHeight" Value="36"/><Setter Property="Padding" Value="8"/><Setter Property="Foreground" Value="#11181C"/></Style>
  <Style TargetType="Button"><Setter Property="Padding" Value="15,10"/><Setter Property="Margin" Value="0,0,8,0"/><Setter Property="Background" Value="#283840"/><Setter Property="Foreground" Value="#EBF1F3"/><Setter Property="BorderThickness" Value="0"/><Setter Property="Cursor" Value="Hand"/><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border Background="{TemplateBinding Background}" CornerRadius="7" Padding="{TemplateBinding Padding}"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Opacity" Value="0.8"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.35"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style>
  <Style TargetType="CheckBox"><Setter Property="Foreground" Value="#DBE5E9"/><Setter Property="Margin" Value="0,8,0,8"/></Style>
  <Style x:Key="FieldLabel" TargetType="TextBlock"><Setter Property="Foreground" Value="#A9BCC6"/><Setter Property="Margin" Value="0,16,0,6"/><Setter Property="FontSize" Value="12"/></Style>
  <Style TargetType="ListBoxItem"><Setter Property="Padding" Value="12"/><Setter Property="Margin" Value="0,4"/><Setter Property="Foreground" Value="#DDE7EB"/><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="ListBoxItem"><Border x:Name="ItemBorder" CornerRadius="7" Padding="{TemplateBinding Padding}" Background="Transparent"><ContentPresenter/></Border><ControlTemplate.Triggers><Trigger Property="IsSelected" Value="True"><Setter TargetName="ItemBorder" Property="Background" Value="#24483E"/></Trigger><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="ItemBorder" Property="BorderBrush" Value="#77C8AC"/><Setter TargetName="ItemBorder" Property="BorderThickness" Value="1"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style>
 </Window.Resources>
 <Grid Margin="28">
  <Grid.RowDefinitions><RowDefinition Height="90"/><RowDefinition Height="*"/><RowDefinition Height="66"/></Grid.RowDefinitions>
  <DockPanel><Border Background="#8FE0BE" CornerRadius="12" Width="64" Height="64" Margin="0,0,16,0" VerticalAlignment="Top"><Image x:Name="BrandLogo" Margin="7"/></Border><StackPanel><TextBlock Text="Codex Instance Manager" FontSize="28" FontWeight="SemiBold"/><TextBlock Text="Name an instance. Open another account." Foreground="#99B3C0" Margin="0,8,0,0"/></StackPanel></DockPanel>
  <Grid Grid.Row="1"><Grid.ColumnDefinitions><ColumnDefinition Width="240"/><ColumnDefinition Width="20"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
   <Border Background="#182329" CornerRadius="12" Padding="16"><Grid><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
    <Button x:Name="NewButton" Content="+  New instance" Background="#8FE0BE" Foreground="#10251C" Margin="0,0,0,14"/>
    <ListBox x:Name="InstanceList" Grid.Row="1" Background="Transparent" BorderThickness="0" DisplayMemberPath="Name"/>
    <TextBlock Grid.Row="2" Text="Keep your main Codex window open normally. Each instance has its own login and saved state." TextWrapping="Wrap" Foreground="#99B3C0" FontSize="12" Margin="0,16,0,0"/>
   </Grid></Border>
   <Border Grid.Column="2" Background="#182329" CornerRadius="12" Padding="24"><Grid><Grid.RowDefinitions><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
    <ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel Margin="0,0,8,16">
     <TextBlock x:Name="EditorTitle" Text="Your instance" FontSize="21" FontWeight="SemiBold"/>
     <TextBlock Style="{StaticResource FieldLabel}" Text="INSTANCE NAME"/><TextBox x:Name="NameField" MaxLength="80"/>
     <TextBlock Text="Save creates a desktop shortcut. Sign into the desired account the first time you open it." TextWrapping="Wrap" Foreground="#99B3C0" FontSize="12" Margin="0,10,0,20"/>
     <Border Background="#202B32" CornerRadius="8" Padding="16"><StackPanel>
      <TextBlock Text="Bring your main context with you" FontWeight="SemiBold"/>
      <TextBlock Text="Copy local projects and chats into this instance. Copies continue independently. Cloud chats and open tabs stay with the main account." Foreground="#99B3C0" TextWrapping="Wrap" FontSize="12" Margin="0,8,0,12"/>
      <Button x:Name="ImportButton" Content="Copy main projects &amp; chats" HorizontalAlignment="Left"/>
      <CheckBox x:Name="BrainCheck" Content="Consult main guidance and memories" Margin="0,14,0,0"/>
     </StackPanel></Border>
     <TextBlock x:Name="HomeInfo" Foreground="#77939F" FontSize="11" TextWrapping="Wrap" Margin="0,18,0,0"/>
    </StackPanel></ScrollViewer>
    <StackPanel Grid.Row="1" Orientation="Horizontal"><Button x:Name="SaveButton" Content="Save"/><Button x:Name="LaunchButton" Content="Open Codex" Background="#8FE0BE" Foreground="#10251C"/><Button x:Name="RemoveButton" Content="Remove" Background="#49343B"/></StackPanel>
   </Grid></Border>
  </Grid>
  <TextBlock x:Name="StatusText" Grid.Row="2" Text="Ready." Foreground="#99B3C0" TextWrapping="Wrap" VerticalAlignment="Center"/>
 </Grid>
</Window>
'@
$reader = New-Object Xml.XmlNodeReader $markup
$script:Window = [Windows.Markup.XamlReader]::Load($reader)
$logoPath = Join-Path $PSScriptRoot 'assets\logo-cim.png'
if (-not (Test-Path -LiteralPath $logoPath)) { $logoPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'assets\logo-cim.png' }
if (Test-Path -LiteralPath $logoPath) {
    $logoUri = New-Object Uri($logoPath)
    $brandImage = New-Object Windows.Media.Imaging.BitmapImage
    $brandImage.BeginInit()
    $brandImage.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    $brandImage.UriSource = $logoUri
    $brandImage.EndInit(); $brandImage.Freeze()
    $script:Window.FindName('BrandLogo').Source = $brandImage
    $script:Window.Icon = $brandImage
}
$script:Controls = @{}
foreach ($name in @('NewButton','InstanceList','EditorTitle','NameField','BrainCheck','HomeInfo','SaveButton','LaunchButton','ImportButton','RemoveButton','StatusText')) { $script:Controls[$name] = $script:Window.FindName($name) }
$script:Current = $null; $script:Loading = $false
function Set-Status([string]$Text, [switch]$ErrorState) {
    $script:Controls.StatusText.Text = $Text
    $script:Controls.StatusText.Foreground = $(if ($ErrorState) { '#FFB5BB' } else { '#99B3C0' })
}
function Refresh-List([string]$SelectedId = '') {
    $script:Loading = $true
    $script:Controls.InstanceList.Items.Clear()
    foreach ($profile in @(Get-Store | Sort-Object Name)) {
        [void]$script:Controls.InstanceList.Items.Add($profile)
        if ($profile.Id -eq $SelectedId) { $script:Controls.InstanceList.SelectedItem = $profile }
    }
    $script:Loading = $false
}
function Load-Editor($Profile) {
    $script:Loading = $true; $script:Current = $Profile
    $script:Controls.EditorTitle.Text = $Profile.Name
    $script:Controls.NameField.Text = $Profile.Name
    $script:Controls.BrainCheck.IsChecked = $Profile.ShareBrain
    $script:Controls.HomeInfo.Text = 'Saved privately in: ' + $Profile.CodexHome
    $script:Loading = $false
}
function Select-FirstOrNew {
    $profiles = @(Get-Store | Sort-Object Name)
    if ($profiles.Count) { Refresh-List $profiles[0].Id; Load-Editor $profiles[0] }
    else { Refresh-List; Load-Editor (New-Profile 'Account 2' ([guid]::NewGuid().ToString('N'))) }
    Set-Status 'Ready. Save an instance to create its shortcut, or open Codex.'
}
function Read-Editor {
    $profile = $script:Current | ConvertTo-Json -Depth 8 | ConvertFrom-Json
    $profile.Name = $script:Controls.NameField.Text.Trim()
    if (-not $profile.Name) { throw 'Give the instance a name.' }
    $profile.ShareBrain = $script:Controls.BrainCheck.IsChecked -eq $true
    $profile
}
function Save-Editor {
    $profile = Read-Editor
    Save-Profile $profile; Prepare-Brain $profile; New-DesktopShortcut $profile
    Refresh-List $profile.Id; Load-Editor $profile
    $profile
}
function Invoke-EditorAction([scriptblock]$Action) {
    $script:Window.IsEnabled = $false; $script:Window.Cursor = [Windows.Input.Cursors]::Wait
    try { & $Action } catch { Set-Status $_.Exception.Message -ErrorState }
    finally { $script:Window.IsEnabled = $true; $script:Window.Cursor = [Windows.Input.Cursors]::Arrow }
}
$script:Controls.InstanceList.Add_SelectionChanged({ if (-not $script:Loading -and $script:Controls.InstanceList.SelectedItem) { Load-Editor $script:Controls.InstanceList.SelectedItem } })
$script:Controls.NewButton.Add_Click({
    $profile = New-Profile ('Account ' + (@(Get-Store).Count + 2)) ([guid]::NewGuid().ToString('N'))
    $script:Controls.InstanceList.SelectedIndex = -1; Load-Editor $profile
    Set-Status 'Give this instance a name. Save creates its desktop shortcut.'
})
$script:Controls.SaveButton.Add_Click({ Invoke-EditorAction { $profile = Save-Editor; Set-Status "Saved '$($profile.Name)' and its desktop shortcut." } })
$script:Controls.LaunchButton.Add_Click({ Invoke-EditorAction { $profile = Save-Editor; Launch-Profile $profile; Set-Status "Opened '$($profile.Name)'. Sign into its account on first use." } })
$script:Controls.ImportButton.Add_Click({ Invoke-EditorAction {
    $profile = Save-Editor
    $result = Import-MainLibrary $profile {
        param($Text)
        Set-Status $Text
        [void]$script:Window.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Background)
    }
    Set-Status "Copied $($result.Chats) new local chats and $($result.Projects) projects. Skipped $($result.Skipped) unavailable chats. Open Codex to see them."
} })
$script:Controls.RemoveButton.Add_Click({
    try {
        $profile = $script:Current
        $answer = [Windows.MessageBox]::Show("Remove '$($profile.Name)' from the manager? Its saved login, chats, files and shortcut will be kept.", 'Remove instance', 'YesNo', 'Question')
        if ($answer -ne 'Yes') { return }
        Save-Store @(Get-Store | Where-Object { $_.Id -ne $profile.Id })
        Select-FirstOrNew; Set-Status 'Removed from the manager. Saved account data and files were kept.'
    } catch { Set-Status $_.Exception.Message -ErrorState }
})
Select-FirstOrNew
if ($RenderPreview) {
    if (-not $PreviewPath) { throw 'Pass -PreviewPath for the rendered preview.' }
    $demo = New-Profile 'Account 2' 'demo'
    $demo.CodexHome = '%LOCALAPPDATA%\OpenAI\CodexInstanceManager\profiles\account-2\codex-home'
    $script:Controls.InstanceList.Items.Clear()
    [void]$script:Controls.InstanceList.Items.Add($demo)
    [void]$script:Controls.InstanceList.Items.Add((New-Profile 'Account 3' 'demo-three'))
    $script:Controls.InstanceList.SelectedItem = $demo; Load-Editor $demo
    Set-Status 'Ready. Your main Codex window stays open normally.'
    # Render the content in an offscreen root; an unshown Window has no surface.
    $root = New-Object Windows.Controls.Border
    $root.Background = $script:Window.Background
    $root.Resources = $script:Window.Resources
    [Windows.Documents.TextElement]::SetForeground($root, $script:Window.Foreground)
    [Windows.Documents.TextElement]::SetFontFamily($root, $script:Window.FontFamily)
    [Windows.Documents.TextElement]::SetFontSize($root, $script:Window.FontSize)
    $content = $script:Window.Content; $script:Window.Content = $null
    $root.Child = $content
    $root.Measure((New-Object Windows.Size(920,640)))
    $root.Arrange((New-Object Windows.Rect(0,0,920,640)))
    $root.UpdateLayout()
    $bitmap = New-Object Windows.Media.Imaging.RenderTargetBitmap(920,640,96,96,[Windows.Media.PixelFormats]::Pbgra32)
    $bitmap.Render($root)
    $encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder
    $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bitmap))
    $stream = [IO.File]::Create($PreviewPath); $encoder.Save($stream); $stream.Dispose()
    Write-Output 'WPF layout loaded and rendered successfully.'
} else { [void]$script:Window.ShowDialog() }
