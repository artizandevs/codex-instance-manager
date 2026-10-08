[xml]$markup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Codex Instance Manager" Width="920" Height="700" MinWidth="850" MinHeight="650" WindowStartupLocation="CenterScreen" Background="#212121" Foreground="#ECECEC" FontFamily="Segoe UI" FontSize="13" UseLayoutRounding="True" TextOptions.TextFormattingMode="Display">
 <Window.Resources>
  <Style TargetType="TextBox">
   <Setter Property="Background" Value="#262626"/><Setter Property="Foreground" Value="#ECECEC"/><Setter Property="CaretBrush" Value="#ECECEC"/><Setter Property="SelectionBrush" Value="#545454"/><Setter Property="BorderBrush" Value="#414141"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Padding" Value="12,10"/><Setter Property="MinHeight" Value="40"/><Setter Property="VerticalContentAlignment" Value="Center"/>
   <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="TextBox"><Border x:Name="InputBorder" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="7"><ScrollViewer x:Name="PART_ContentHost"/></Border><ControlTemplate.Triggers><Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="InputBorder" Property="BorderBrush" Value="#929292"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.5"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
  </Style>
  <Style TargetType="Button">
   <Setter Property="Padding" Value="14,9"/><Setter Property="Margin" Value="0,0,8,0"/><Setter Property="Background" Value="#292929"/><Setter Property="Foreground" Value="#E3E3E3"/><Setter Property="BorderBrush" Value="#434343"/><Setter Property="BorderThickness" Value="1"/><Setter Property="Cursor" Value="Hand"/><Setter Property="FocusVisualStyle" Value="{x:Null}"/>
   <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="ButtonBorder" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="7" Padding="{TemplateBinding Padding}"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="ButtonBorder" Property="Background" Value="#353535"/></Trigger><Trigger Property="IsPressed" Value="True"><Setter Property="Opacity" Value="0.7"/></Trigger><Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="ButtonBorder" Property="BorderBrush" Value="#ADADAD"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
  </Style>
  <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
   <Setter Property="Background" Value="#ECECEC"/><Setter Property="Foreground" Value="#171717"/><Setter Property="BorderBrush" Value="#ECECEC"/>
   <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border x:Name="PrimaryBorder" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="7" Padding="{TemplateBinding Padding}"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="PrimaryBorder" Property="Background" Value="#D4D4D4"/></Trigger><Trigger Property="IsPressed" Value="True"><Setter Property="Opacity" Value="0.7"/></Trigger><Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="PrimaryBorder" Property="BorderBrush" Value="#949494"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
  </Style>
  <Style TargetType="CheckBox">
   <Setter Property="Foreground" Value="#BEBEBE"/><Setter Property="Margin" Value="0,8,0,8"/><Setter Property="Cursor" Value="Hand"/>
   <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="CheckBox"><StackPanel Orientation="Horizontal"><Border x:Name="CheckBorder" Width="16" Height="16" CornerRadius="3" Background="#262626" BorderBrush="#757575" BorderThickness="1" VerticalAlignment="Center"><Path x:Name="CheckMark" Data="M 3,7 L 6,10 L 12,4" Stroke="#212121" StrokeThickness="1.8" Visibility="Collapsed" StrokeStartLineCap="Round" StrokeEndLineCap="Round"/></Border><ContentPresenter Margin="10,0,0,0" VerticalAlignment="Center" RecognizesAccessKey="True"/></StackPanel><ControlTemplate.Triggers><Trigger Property="IsChecked" Value="True"><Setter TargetName="CheckBorder" Property="Background" Value="#E0E0E0"/><Setter TargetName="CheckBorder" Property="BorderBrush" Value="#E0E0E0"/><Setter TargetName="CheckMark" Property="Visibility" Value="Visible"/></Trigger><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="CheckBorder" Property="BorderBrush" Value="#D0D0D0"/></Trigger><Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="CheckBorder" Property="BorderBrush" Value="#FFFFFF"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
  </Style>
  <Style x:Key="FieldLabel" TargetType="TextBlock"><Setter Property="Foreground" Value="#B7B7B7"/><Setter Property="Margin" Value="0,24,0,8"/><Setter Property="FontSize" Value="12"/></Style>
  <Style TargetType="ListBoxItem">
   <Setter Property="Padding" Value="12,10"/><Setter Property="Margin" Value="0,2"/><Setter Property="Foreground" Value="#D6D6D6"/><Setter Property="HorizontalContentAlignment" Value="Stretch"/>
   <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="ListBoxItem"><Border x:Name="ItemBorder" CornerRadius="6" Padding="{TemplateBinding Padding}" Background="Transparent" BorderBrush="Transparent" BorderThickness="1"><ContentPresenter/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="ItemBorder" Property="Background" Value="#242424"/></Trigger><Trigger Property="IsSelected" Value="True"><Setter TargetName="ItemBorder" Property="Background" Value="#303030"/><Setter Property="Foreground" Value="#FFFFFF"/></Trigger><Trigger Property="IsKeyboardFocused" Value="True"><Setter TargetName="ItemBorder" Property="BorderBrush" Value="#747474"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter>
  </Style>
  <Style TargetType="ScrollBar">
   <Setter Property="Width" Value="10"/><Setter Property="Background" Value="Transparent"/>
   <Setter Property="Template"><Setter.Value><ControlTemplate TargetType="ScrollBar"><Track x:Name="PART_Track" IsDirectionReversed="True" Orientation="Vertical"><Track.DecreaseRepeatButton><RepeatButton Command="ScrollBar.PageUpCommand" Opacity="0" Focusable="False"/></Track.DecreaseRepeatButton><Track.Thumb><Thumb><Thumb.Template><ControlTemplate TargetType="Thumb"><Border Background="#505050" CornerRadius="3" Margin="2,0"/></ControlTemplate></Thumb.Template></Thumb></Track.Thumb><Track.IncreaseRepeatButton><RepeatButton Command="ScrollBar.PageDownCommand" Opacity="0" Focusable="False"/></Track.IncreaseRepeatButton></Track></ControlTemplate></Setter.Value></Setter>
  </Style>
 </Window.Resources>
 <Grid>
  <Grid.RowDefinitions><RowDefinition Height="72"/><RowDefinition Height="*"/><RowDefinition Height="52"/></Grid.RowDefinitions>
  <Grid.ColumnDefinitions><ColumnDefinition Width="232"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
  <Border Grid.RowSpan="3" Background="#171717" BorderBrush="#2E2E2E" BorderThickness="0,0,1,0"/>
  <StackPanel Orientation="Horizontal" Margin="22,0" VerticalAlignment="Center"><Border Width="40" Height="40" Background="#B7B7B7" CornerRadius="8" Margin="0,0,12,0"><Image x:Name="BrandLogo" Margin="3"/></Border><StackPanel VerticalAlignment="Center"><TextBlock Text="Codex" FontSize="15" FontWeight="SemiBold"/><TextBlock Text="Instance Manager" FontSize="11" Foreground="#929292" Margin="0,2,0,0"/></StackPanel></StackPanel>
  <Border Grid.Column="1" BorderBrush="#343434" BorderThickness="0,0,0,1" Padding="32,0"><TextBlock Text="Manage instances" VerticalAlignment="Center" FontSize="14" Foreground="#C3C3C3"/></Border>
  <Grid Grid.Row="1" Margin="16,12,16,20"><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
   <Button x:Name="NewButton" Content="+  New instance" Background="Transparent" BorderBrush="#3B3B3B" Margin="0,0,0,24" HorizontalContentAlignment="Left"/>
   <TextBlock Grid.Row="1" Text="Instances" Foreground="#929292" FontSize="11" Margin="12,0,0,8"/>
   <ListBox x:Name="InstanceList" Grid.Row="2" Background="Transparent" BorderThickness="0" DisplayMemberPath="Name"/>
   <TextBlock Grid.Row="3" Text="Your main Codex window stays open normally. Each instance has its own login." TextWrapping="Wrap" Foreground="#828282" FontSize="11" LineHeight="17" Margin="12,20,8,0"/>
  </Grid>
  <Grid Grid.Row="1" Grid.Column="1" Margin="32,28,32,24"><Grid.RowDefinitions><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
   <ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel Margin="0,0,10,20">
    <TextBlock x:Name="EditorTitle" Text="Your instance" FontSize="25" FontWeight="SemiBold"/>
    <TextBlock Text="A separate space for another account." Foreground="#9E9E9E" Margin="0,8,0,0"/>
    <TextBlock Style="{StaticResource FieldLabel}" Text="Instance name"/><TextBox x:Name="NameField" MaxLength="80"/>
    <TextBlock Text="Save creates a desktop shortcut. Sign in on first launch." TextWrapping="Wrap" Foreground="#929292" FontSize="12" LineHeight="18" Margin="0,10,0,24"/>
    <Border Background="#242424" BorderBrush="#3A3A3A" BorderThickness="1" CornerRadius="9" Padding="18"><StackPanel>
     <TextBlock Text="Main context" FontSize="14" FontWeight="SemiBold"/>
     <TextBlock Text="Copy local projects and chats into this instance. Copies continue independently. Cloud chats and open tabs stay with your main account." Foreground="#A4A4A4" TextWrapping="Wrap" FontSize="12" LineHeight="18" Margin="0,8,0,16"/>
     <Button x:Name="ImportButton" Content="Copy main projects &amp; chats" HorizontalAlignment="Left"/>
     <CheckBox x:Name="BrainCheck" Content="Consult main guidance and memories" Margin="0,18,0,0"/>
    </StackPanel></Border>
    <TextBlock x:Name="HomeInfo" Foreground="#828282" FontSize="11" TextWrapping="Wrap" LineHeight="16" Margin="0,18,0,0"/>
   </StackPanel></ScrollViewer>
   <Grid Grid.Row="1" Margin="0,18,0,0"><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions><StackPanel Orientation="Horizontal"><Button x:Name="LaunchButton" Content="Open Codex" Style="{StaticResource PrimaryButton}"/><Button x:Name="SaveButton" Content="Save"/></StackPanel><Button x:Name="RemoveButton" Grid.Column="1" Content="Remove" Foreground="#C79A9A" Background="Transparent" BorderBrush="Transparent" Margin="0"/></Grid>
  </Grid>
  <Border Grid.Row="2" Grid.Column="1" BorderBrush="#343434" BorderThickness="0,1,0,0" Padding="32,0"><TextBlock x:Name="StatusText" Text="Ready." Foreground="#A3A3A3" FontSize="11" TextWrapping="Wrap" VerticalAlignment="Center"/></Border>
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

# Use Windows' dark frame without replacing native move/resize controls.
if (-not ('Cim.DarkWindowFrame' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace Cim {
    public static class DarkWindowFrame {
        [DllImport("dwmapi.dll")]
        public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attribute, ref int value, int size);
    }
}
'@
}
$script:Window.Add_SourceInitialized({
    $handle = (New-Object Windows.Interop.WindowInteropHelper($script:Window)).Handle
    $enabled = 1; $caption = 0x00212121; $text = 0x00ECECEC
    [void][Cim.DarkWindowFrame]::DwmSetWindowAttribute($handle, 20, [ref]$enabled, 4)
    [void][Cim.DarkWindowFrame]::DwmSetWindowAttribute($handle, 35, [ref]$caption, 4)
    [void][Cim.DarkWindowFrame]::DwmSetWindowAttribute($handle, 36, [ref]$text, 4)
})

$script:Controls = @{}
foreach ($name in @('NewButton','InstanceList','EditorTitle','NameField','BrainCheck','HomeInfo','SaveButton','LaunchButton','ImportButton','RemoveButton','StatusText')) { $script:Controls[$name] = $script:Window.FindName($name) }
$script:Current = $null; $script:Loading = $false
function Set-Status([string]$Text, [switch]$ErrorState) {
    $script:Controls.StatusText.Text = $Text
    $script:Controls.StatusText.Foreground = $(if ($ErrorState) { '#E9A5A5' } else { '#A3A3A3' })
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
