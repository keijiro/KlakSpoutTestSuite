#!/bin/sh

src_base="."
dst_base="$HOME/Windows/Documents/VideoInteropTestSuite"

[ -d "$dst_base" ] || mkdir "$dst_base"

make_cmd() {
    echo "New-Item -Target \\$1\\$3 -Path $2\\$3 -Item SymbolicLink"
}

link_prj() {
    src="$src_base"/"$1"
    dst="$dst_base"/"$1"

    [ -d "$dst" ] || mkdir "$dst"

    src_wsl=$(wslpath -w "$src")
    dst_wsl=$(wslpath -w "$dst")

    cmd1=$(make_cmd $src_wsl $dst_wsl "Assets")
    cmd2=$(make_cmd $src_wsl $dst_wsl "Packages")
    cmd3=$(make_cmd $src_wsl $dst_wsl "ProjectSettings")

    opt="'-command $cmd1; $cmd2; $cmd3'"

    powershell.exe -command start-process powershell -verb runas $opt
}

for dir in "$src_base"/*; do
    [ -e "$dir" ] || continue
    [ -d "$dir" ] || continue

    name=$(basename "$dir")

    [ "$name" = "TD" ] && continue

    link_prj "$name"
done
