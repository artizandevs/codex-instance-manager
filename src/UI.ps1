[xml]$markup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Codex Instance Manager" Width="1120" Height="850" MinWidth="1000" MinHeight="780" WindowStartupLocation="CenterScreen" Background="#11181C" Foreground="#EBF1F3" FontFamily="Segoe UI" FontSize="14">
 <Window.Resources>
  <Style TargetType="TextBox"><Setter Property="Background" Value="#202B32"/><Setter Property="Foreground" Value="#EBF1F3"/><Setter Property="BorderBrush" Value="#3B4B54"/><Setter Property="Padding" Value="10,7"/><Setter Property="MinHeight" Value="36"/><Setter Property="VerticalContentAlignment" Value="Center"/></Style>
  <Style TargetType="ComboBox"><Setter Property="MinHeight" Value="36"/><Setter Property="Padding" Value="8"/><Setter Property="Foreground" Value="#11181C"/></Style>
  <Style TargetType="Button"><Setter Property="Padding" Value="15,10"/><Setter Property="Margin" Value="0,0,8,0"/><Setter Property="Background" Value="#283840"/><Setter Property="Foreground" Value="#EBF1F3"/><Setter Property="BorderThickness" Value="0"/><Setter Property="Cursor" Value="Hand"/><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="Button"><Border Background="{TemplateBinding Background}" CornerRadius="7" Padding="{TemplateBinding Padding}"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter Property="Opacity" Value="0.8"/></Trigger><Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.35"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style>
  <Style TargetType="CheckBox"><Setter Property="Foreground" Value="#DBE5E9"/><Setter Property="Margin" Value="0,8,0,8"/></Style>
  <Style x:Key="FieldLabel" TargetType="TextBlock"><Setter Property="Foreground" Value="#A9BCC6"/><Setter Property="Margin" Value="0,16,0,6"/><Setter Property="FontSize" Value="12"/></Style>
  <Style TargetType="ListBoxItem"><Setter Property="Padding" Value="12"/><Setter Property="Margin" Value="0,4"/><Setter Property="Foreground" Value="#DDE7EB"/><Setter Property="Template"><Setter.Value><ControlTemplate TargetType="ListBoxItem"><Border x:Name="ItemBorder" CornerRadius="7" Padding="{TemplateBinding Padding}" Background="Transparent"><ContentPresenter/></Border><ControlTemplate.Triggers><Trigger Property="IsSelected" Value="True"><Setter TargetName="ItemBorder" Property="Background" Value="#24483E"/></Trigger><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="ItemBorder" Property="BorderBrush" Value="#77C8AC"/><Setter TargetName="ItemBorder" Property="BorderThickness" Value="1"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Setter.Value></Setter></Style>
 </Window.Resources>
 <Grid Margin="28">
  <Grid.RowDefinitions><RowDefinition Height="80"/><RowDefinition Height="*"/><RowDefinition Height="66"/></Grid.RowDefinitions>
  <DockPanel><Border Background="#8FE0BE" CornerRadius="12" Width="64" Height="64" Margin="0,0,16,0" VerticalAlignment="Top"><Image x:Name="BrandLogo" Margin="7"/></Border><StackPanel><TextBlock Text="Codex Instance Manager" FontSize="28" FontWeight="SemiBold"/><TextBlock Text="Separate accounts. Shared knowledge. A workspace for every worker." Foreground="#99B3C0" Margin="0,8,0,0"/></StackPanel></DockPanel>
  <Grid Grid.Row="1"><Grid.ColumnDefinitions><ColumnDefinition Width="270"/><ColumnDefinition Width="24"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
   <Border Background="#182329" CornerRadius="12" Padding="16"><Grid><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
    <Button x:Name="NewButton" Content="+  New instance" Background="#8FE0BE" Foreground="#10251C" Margin="0,0,0,14"/>
    <ListBox x:Name="InstanceList" Grid.Row="1" Background="Transparent" BorderThickness="0" DisplayMemberPath="Name"/>
    <StackPanel Grid.Row="2" Margin="0,16,0,0"><TextBlock Text="DEFAULT WINDOW'S KNOWLEDGE" FontSize="11" Foreground="#8FE0BE" FontWeight="Bold"/><TextBlock x:Name="BrainPath" TextWrapping="Wrap" Foreground="#99B3C0" FontSize="12" Margin="0,7,0,0"/><TextBlock Text="Keep your default Codex window open normally. This manager opens additional instances. Shared knowledge is optional." TextWrapping="Wrap" Foreground="#77939F" FontSize="12" Margin="0,9,0,0"/></StackPanel>
   </Grid></Border>
   <Border Grid.Column="2" Background="#182329" CornerRadius="12" Padding="24"><Grid><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
    <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions><TextBlock x:Name="EditorTitle" Text="Instance settings" FontSize="21" FontWeight="SemiBold"/><TextBlock x:Name="KindLabel" Grid.Column="1" Text="WORKER" FontSize="11" Foreground="#8FE0BE" VerticalAlignment="Center"/></Grid>
    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="0,6,0,16"><StackPanel Margin="0,0,10,0">
     <TextBlock Style="{StaticResource FieldLabel}" Text="INSTANCE NAME"/><TextBox x:Name="NameField" MaxLength="80"/>
     <TextBlock Style="{StaticResource FieldLabel}" Text="PROJECT REPOSITORY"/><Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions><TextBox x:Name="RepoField"/><Button x:Name="BrowseRepo" Grid.Column="1" Content="Browse" Margin="8,0,0,0"/></Grid>
     <CheckBox x:Name="WorktreeCheck" Content="Use an isolated Git worktree"/>
     <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="16"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
      <StackPanel><TextBlock Style="{StaticResource FieldLabel}" Text="BASE BRANCH" Margin="0,6,0,6"/><ComboBox x:Name="BaseField" IsEditable="True" Text="test"/></StackPanel>
      <StackPanel Grid.Column="2"><TextBlock Style="{StaticResource FieldLabel}" Text="WORKING BRANCH" Margin="0,6,0,6"/><TextBox x:Name="BranchField"/></StackPanel>
     </Grid>
     <TextBlock Style="{StaticResource FieldLabel}" Text="WORKTREE DIRECTORY (BLANK = AUTOMATIC)"/><TextBox x:Name="WorkspaceField"/>
     <TextBlock Text="Save creates a missing worktree. Existing worktrees must match the selected repository and working branch." TextWrapping="Wrap" FontSize="11" Foreground="#77939F" Margin="0,6,0,0"/>
     <TextBlock Style="{StaticResource FieldLabel}" Text="STARTUP PROMPT (OPTIONAL DRAFT)"/><TextBox x:Name="PromptField" AcceptsReturn="True" TextWrapping="Wrap" Height="88" VerticalScrollBarVisibility="Auto" VerticalContentAlignment="Top" MaxLength="6000"/>
     <TextBlock Text="Launch opens this project with a new chat draft. Press Send in Codex to start." FontSize="11" Foreground="#77939F" TextWrapping="Wrap" Margin="0,6,0,0"/>
     <TextBlock Style="{StaticResource FieldLabel}" Text="OR OPEN AN EXISTING LOCAL CHAT (ID OR CODEX LINK)"/><TextBox x:Name="ChatField"/>
     <CheckBox x:Name="BrainCheck" Content="Use the default window's shared guidance and memories"/>
     <CheckBox x:Name="ShortcutCheck" Content="Create or refresh this instance's desktop shortcut" IsChecked="True" Margin="0,0,0,8"/>
     <TextBlock x:Name="HomeInfo" Foreground="#77939F" FontSize="11" TextWrapping="Wrap" Margin="0,6,0,0"/>
    </StackPanel></ScrollViewer>
    <StackPanel Grid.Row="2" Orientation="Horizontal"><Button x:Name="SaveButton" Content="Save instance"/><Button x:Name="LaunchButton" Content="Save &amp; launch" Background="#8FE0BE" Foreground="#10251C"/><Button x:Name="FolderButton" Content="Open folder"/><Button x:Name="RemoveButton" Content="Remove" Background="#49343B"/></StackPanel>
   </Grid></Border>
  </Grid>
  <TextBlock x:Name="StatusText" Grid.Row="2" Text="Ready. Select an instance or create a new one." Foreground="#99B3C0" TextWrapping="Wrap" VerticalAlignment="Center"/>
 </Grid>
</Window>
'@
$reader = New-Object Xml.XmlNodeReader $markup
$script:Window = [Windows.Markup.XamlReader]::Load($reader)
$logoPath = Join-Path $PSScriptRoot 'assets\logo-cim.png'
if (-not (Test-Path -LiteralPath $logoPath)) { $logoPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'assets\logo-cim.png' }
if (Test-Path -LiteralPath $logoPath) {
    $logoUri = New-Object Uri($logoPath)
    $script:Window.FindName('BrandLogo').Source = New-Object Windows.Media.Imaging.BitmapImage($logoUri)
    $script:Window.Icon = New-Object Windows.Media.Imaging.BitmapImage($logoUri)
}
$script:Controls = @{}
foreach ($name in @('NewButton','InstanceList','BrainPath','EditorTitle','KindLabel','NameField','RepoField','BrowseRepo','WorktreeCheck','BaseField','BranchField','WorkspaceField','PromptField','ChatField','BrainCheck','ShortcutCheck','HomeInfo','SaveButton','LaunchButton','FolderButton','RemoveButton','StatusText')) { $script:Controls[$name] = $script:Window.FindName($name) }
$script:Controls.BrainPath.Text = $script:MainHome
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
    $c = $script:Controls
    $c.EditorTitle.Text = $Profile.Name
    $c.KindLabel.Text = 'SEPARATE ACCOUNT'
    $c.NameField.Text = $Profile.Name; $c.RepoField.Text = $Profile.Repo
    $c.WorktreeCheck.IsChecked = $Profile.UseWorktree
    $c.BaseField.Text = $Profile.BaseBranch; $c.BranchField.Text = $Profile.Branch
    $c.WorkspaceField.Text = $Profile.Workspace; $c.PromptField.Text = $Profile.Prompt; $c.ChatField.Text = $Profile.ChatId
    $c.BrainCheck.IsChecked = $Profile.ShareBrain
    $c.HomeInfo.Text = 'Codex folder: ' + $Profile.CodexHome
    $c.RemoveButton.IsEnabled = $true
    $script:Loading = $false
    Update-WorktreeFields
}
function Update-WorktreeFields {
    $enabled = $script:Controls.WorktreeCheck.IsChecked -eq $true
    foreach ($key in @('BaseField','BranchField','WorkspaceField')) { $script:Controls[$key].IsEnabled = $enabled }
}
function Select-FirstOrNew {
    $profiles = @(Get-Store | Sort-Object Name)
    if ($profiles.Count) {
        Refresh-List $profiles[0].Id; Load-Editor $profiles[0]
    } else {
        Refresh-List
        Load-Editor (New-Profile 'Worker 1' ([guid]::NewGuid().ToString('N')))
        Set-Status 'Create your first additional instance. Open your default Codex window normally.'
    }
}
function Read-Editor {
    $profile = $script:Current | ConvertTo-Json -Depth 8 | ConvertFrom-Json
    $c = $script:Controls
    $profile.Name = $c.NameField.Text.Trim()
    if (-not $profile.Name) { throw 'Give the instance a name.' }
    $profile.Repo = $c.RepoField.Text.Trim()
    $profile.UseWorktree = $c.WorktreeCheck.IsChecked -eq $true
    $profile.BaseBranch = $c.BaseField.Text.Trim(); $profile.Branch = $c.BranchField.Text.Trim()
    $profile.Workspace = $c.WorkspaceField.Text.Trim(); $profile.Prompt = $c.PromptField.Text
    $profile.ChatId = $c.ChatField.Text.Trim(); $profile.ShareBrain = $c.BrainCheck.IsChecked -eq $true
    if ($profile.UseWorktree -and $profile.Repo -and -not $profile.Branch) {
        $slug = ($profile.Name.ToLowerInvariant() -replace '[^a-z0-9]+','-').Trim('-')
        if (-not $slug) { $slug = 'worker' }
        $profile.Branch = 'codex/' + $slug + '-' + $profile.Id.Substring(0, [Math]::Min(6,$profile.Id.Length))
    }
    $profile
}
function Save-Editor([switch]$Open) {
    $script:Window.Cursor = [Windows.Input.Cursors]::Wait
    try {
        $profile = Read-Editor
        if (@(Get-Store | Where-Object { $_.Id -ne $profile.Id -and $_.Name -eq $profile.Name }).Count) {
            throw 'An instance already has that name. Choose another name before creating its worktree.'
        }
        # Validate launch inputs before creating a worktree or saving settings.
        [void](Get-LaunchPlan $profile (Get-AppExecutable))
        Prepare-Workspace $profile; Prepare-Brain $profile; Save-Profile $profile
        if ($script:Controls.ShortcutCheck.IsChecked) { New-DesktopShortcut $profile }
        Refresh-List $profile.Id; Load-Editor $profile
        if ($Open) { Launch-Profile $profile; Set-Status "Opened '$($profile.Name)'. Check the signed-in account; send the draft when ready." }
        else { Set-Status "Saved '$($profile.Name)'. Its worktree and shared guidance are ready." }
    } catch { Set-Status $_.Exception.Message -ErrorState }
    finally { $script:Window.Cursor = [Windows.Input.Cursors]::Arrow }
}
$script:Controls.InstanceList.Add_SelectionChanged({ if (-not $script:Loading -and $script:Controls.InstanceList.SelectedItem) { Load-Editor $script:Controls.InstanceList.SelectedItem } })
$script:Controls.WorktreeCheck.Add_Click({ Update-WorktreeFields })
$script:Controls.NewButton.Add_Click({
    $profile = New-Profile ('Worker ' + (@(Get-Store).Count + 1)) ([guid]::NewGuid().ToString('N'))
    $script:Controls.InstanceList.SelectedIndex = -1; Load-Editor $profile
    Set-Status 'New account profile. Enter a name and project, then save. Sign in once when you first launch it.'
})
$script:Controls.BrowseRepo.Add_Click({
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $dialog = New-Object Windows.Forms.FolderBrowserDialog
        $dialog.Description = 'Choose the project repository'; $dialog.ShowNewFolderButton = $false
        if ($dialog.ShowDialog() -eq 'OK') {
            $root = Get-RepoRoot $dialog.SelectedPath; $script:Controls.RepoField.Text = $root
            $branches = @(Get-Branches $root); $script:Controls.BaseField.Items.Clear()
            foreach ($branch in $branches) { [void]$script:Controls.BaseField.Items.Add($branch) }
            $script:Controls.BaseField.Text = $(if ($branches -contains 'test') { 'test' } else { (Invoke-Git $root @('rev-parse','--abbrev-ref','HEAD')).Output })
            Set-Status 'Repository selected. Choose a base branch and a distinct working branch.'
        }
        $dialog.Dispose()
    } catch { Set-Status $_.Exception.Message -ErrorState }
})
$script:Controls.SaveButton.Add_Click({ Save-Editor })
$script:Controls.LaunchButton.Add_Click({ Save-Editor -Open })
$script:Controls.FolderButton.Add_Click({
    try {
        $profile = Read-Editor; $path = $(if ($profile.Workspace) { $profile.Workspace } else { $profile.CodexHome })
        if (-not (Test-Path -LiteralPath $path -PathType Container)) { throw 'Save this instance first to create its folders.' }
        Start-Process explorer.exe -ArgumentList (Quote-Argument $path)
    } catch { Set-Status $_.Exception.Message -ErrorState }
})
$script:Controls.RemoveButton.Add_Click({
    try {
        $profile = $script:Current
        $answer = [Windows.MessageBox]::Show("Remove '$($profile.Name)' from this manager? Its files, credentials, worktree and shortcut will be kept.", 'Remove instance', 'YesNo', 'Question')
        if ($answer -ne 'Yes') { return }
        Save-Store @(Get-Store | Where-Object { $_.Id -ne $profile.Id })
        Select-FirstOrNew
        Set-Status 'Removed from the manager. All files and worktrees were kept.'
    } catch { Set-Status $_.Exception.Message -ErrorState }
})
Select-FirstOrNew
if ($RenderPreview) {
    if (-not $PreviewPath) { throw 'Pass -PreviewPath for the rendered preview.' }
    # Use fictitious paths and assignments in the public screenshot.
    $demo = New-Profile 'Frontend' 'demo'
    $demo.Repo = 'C:\Projects\MyApp'; $demo.Workspace = 'C:\Projects\MyApp-worktrees\frontend'
    $demo.Branch = 'codex/frontend'; $demo.BaseBranch = 'test'; $demo.ShareBrain = $true
    $demo.CodexHome = '%LOCALAPPDATA%\OpenAI\CodexInstanceManager\profiles\frontend\codex-home'
    $demo.Prompt = 'Build the settings page in this worktree. Follow the project guidelines and run the relevant checks.'
    $script:Controls.InstanceList.Items.Clear()
    [void]$script:Controls.InstanceList.Items.Add($demo)
    [void]$script:Controls.InstanceList.Items.Add((New-Profile 'Backend' 'backend'))
    $script:Controls.InstanceList.SelectedItem = $demo
    Load-Editor $demo
    Set-Status 'Ready. Select an additional instance or create a new one. Open your default Codex window normally.'
    $script:Controls.BrainPath.Text = '%USERPROFILE%\.codex'
    # Render the content in an offscreen root; an unshown Window has no surface.
    $root = New-Object Windows.Controls.Border
    $root.Background = $script:Window.Background
    $root.Resources = $script:Window.Resources
    [Windows.Documents.TextElement]::SetForeground($root, $script:Window.Foreground)
    [Windows.Documents.TextElement]::SetFontFamily($root, $script:Window.FontFamily)
    [Windows.Documents.TextElement]::SetFontSize($root, $script:Window.FontSize)
    $content = $script:Window.Content; $script:Window.Content = $null
    $root.Child = $content
    $root.Measure((New-Object Windows.Size(1120,850)))
    $root.Arrange((New-Object Windows.Rect(0,0,1120,850)))
    $root.UpdateLayout()
    $bitmap = New-Object Windows.Media.Imaging.RenderTargetBitmap(1120,850,96,96,[Windows.Media.PixelFormats]::Pbgra32)
    $bitmap.Render($root)
    $encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder
    $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bitmap))
    $stream = [IO.File]::Create($PreviewPath); $encoder.Save($stream); $stream.Dispose()
    Write-Output 'WPF layout loaded and rendered successfully.'
} else { [void]$script:Window.ShowDialog() }
