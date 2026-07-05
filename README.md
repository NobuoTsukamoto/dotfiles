# dotfiles

個人用の dotfiles です。

現在の Vim 設定は、VS Code を主な開発環境として使う前提で、Vim 側はテキストや Markdown の軽い修正に絞っています。言語補完、Python/C++ テンプレート、PlantUML/Mermaid の出力機能は Vim から外しています。

## Windows Vim

### Vim をインストールする

Windows では Vim 本家の Windows build を `winget` でインストールします。

```powershell
winget install -e --id vim.vim
```

インストール後、`vim.exe` の場所を確認します。

```powershell
Get-ChildItem "$env:LOCALAPPDATA\Programs", "$env:ProgramFiles\Vim" -Recurse -Filter vim.exe -ErrorAction SilentlyContinue |
  Select-Object FullName
```

ユーザー領域にインストールされた場合は、例えば次のような場所に入ります。

```text
C:\Users\nextr\AppData\Local\Programs\Vim\vim91
```

### PATH を通す

`vim.exe` があるディレクトリをユーザー PATH に追加します。

```powershell
$vimDir = "C:\Users\nextr\AppData\Local\Programs\Vim\vim91"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$userPath;$vimDir", "User")
```

PowerShell または Windows Terminal を開き直して確認します。

```powershell
vim --version
gvim --version
```

### .vimrc を配置する

Windows Vim は `$HOME\_vimrc` を読み込みます。まずはコピーで動作確認します。

```powershell
Copy-Item C:\Users\nextr\Projects\dotfiles\.vimrc $HOME\_vimrc -Force
vim
```

`.vimrc` は Windows Vim と WSL/Linux Vim の両方で読むため、リポジトリ上では LF 改行に固定しています。Windows 側で編集する場合も CRLF に変換しないようにします。

設定が安定したら、必要に応じてシンボリックリンクに切り替えます。

```powershell
Remove-Item $HOME\_vimrc
New-Item -ItemType SymbolicLink -Path $HOME\_vimrc -Target C:\Users\nextr\Projects\dotfiles\.vimrc
```

シンボリックリンク作成には、開発者モードまたは管理者権限が必要になる場合があります。

### プラグインをインストールする

初回起動時に `vim-plug` が未導入なら、`.vimrc` が `curl` で取得します。

自動で入らない場合は、Vim 上で実行します。

```vim
:PlugInstall
```

不要になった古いプラグインを削除する場合は、Vim 上で実行します。

```vim
:PlugClean
```

現在のプラグインは最小限です。

- `altercation/vim-colors-solarized`
- `preservim/nerdtree`
- `tyru/caw.vim`

NERDTree は起動時には開かず、必要な時だけ `<C-n>` で開きます。

## Fedora Vim

Fedora では `.vimrc` をホームディレクトリへ配置します。

```sh
ln -s ~/Projects/dotfiles/.vimrc ~/.vimrc
```

Vim 起動後、必要に応じてプラグインをインストールします。

```vim
:PlugInstall
```

## WSL Ubuntu Vim

WSL ではリポジトリを Linux 側のホームディレクトリに clone して、`.vimrc` を symlink します。

```sh
git clone https://github.com/NobuoTsukamoto/dotfiles.git ~/dotfiles
ln -sf ~/dotfiles/.vimrc ~/.vimrc
vim
```

もし Vim 起動時に `^M` や `E488: Trailing characters` が出る場合は、`.vimrc` が CRLF になっています。リポジトリを更新して LF に戻します。

```sh
cd ~/dotfiles
git pull
sed -i 's/\r$//' .vimrc
```
