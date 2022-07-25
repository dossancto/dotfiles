set-Alias lvim $HOME\.local\bin\lvim.ps1 # incia o lunarvim
oh-my-posh --init --shell pwsh --config $HOME/powerlevel10k_lean.omp.json | Invoke-Expression # Tema
# set-Alias vim lvim # substitui o comando "vim" pelo lvim
$prog = "$HOME\desktop\projetos\programas"
$downloads = "$HOME/Downloads/"
$app = "$HOME/Apps/"
$vimthemes = "$HOME\AppData\Roaming\lunarvim\site\pack\packer\start"

# $XDG_CONFIG_HOME = "$HOME/AppData/Roaming/lunarvim/lvim/init.lua"

# Comando para Criar arquivos
function touch
{
  param(
    $arquiveName
  )
  if($null -ne $arquiveName)
  {
    $caminho = Get-Location
    Write-Output $null >> "$caminho/$arquiveName" 
  } else
  {
    Write-Output "Digite o nome de um arquivo"
  }
}

# Comando para executar arquivos e atalhos
function app
{
  param(
    $appNome
  )
  if(Test-Path "$app/$appNome.lnk")
  {
    Start-Process "$app/$appNome"
  } else
  {
    if ($appNome -eq "list")
    {
      Write-output "Lista de Apps lincados"
      Write-Output "----------------------"
      Get-ChildItem -Name $app
      Write-Output "----------------------"
    } else
    {    
      Write-Output "Aplicativo '$appNome' não Existe"
    }
  }

}

function repo
{
  param(
    $user,
    $repo
  )
  Start-Process "www.github.com/$user/$repo"
}


function unrar
{

  param(
    $fileType,
    $fileName,
    $finalPath
  )
  if($fileType -ne "rar" -and $fileType -ne "zip")
  {
    Write-Output "Tipo de arquivo não reconhecido"
    return
  }
  $path = Get-Location
  if($fileType -eq "zip")
  {
    C:/"Program Files"/winrar/winrar x $fileName $finalPath
    if($NULL -eq $path)
    {
      Write-Output "Arquivo '$fileName' Desconpactado em '$path' com sucesso"
    } else
    {
      Write-Output "Arquivo '$fileName' Desconpactado em '$finalPath' com sucesso"
    }
    return
  }
  if($fileType -eq "rar")
  {
    C:/"Program Files"/winrar/rar x $fileName $finalPath
    if($path -eq "")
    {
      Write-Output "Arquivo '$fileName' Desconpactado em '$path' com sucesso"
    } else
    {
      Write-Output "Arquivo '$fileName' Desconpactado em '$finalPath' com sucesso"
    }
    return
  }
  Write-Output "Não foi possível descompactar o arquivo"

}

# function rar{
#     param(
#       $fileType,
#       $fileName,
#       $finalPath
#     )
#     if($fileType -ne "rar" -and $fileType -ne "zip"){
#         Write-Output "Tipo de arquivo não reconhecido"
#         return
#     }

#     if($fileType -eq "zip"){
#       C:/"Program Files"/winrar/winrar a -afzip $fileName $finalPath -ep -df
#       Write-Output "Arquivo '$fileName' Desconpactado em '$finalPath' com sucesso"
#       return
#     }
#     if($fileType -eq "rar"){
#        C:/"Program Files"/winrar/rar x $fileName $finalPath
#         Write-Output "Arquivo '$fileName' Desconpactado em '$finalPath' com sucesso"
#         return
#     }
#     Write-Output "Não foi possível descompactar o arquivo"
#   }
function vim
{
  param(
    $file
  )
  neovide -- -u ~/appdata/roaming//lunarvim/lvim/init.lua --cmd "set runtimepath+=~/appdata/roaming//lunarvim/lvim/init.lua" $file
}
